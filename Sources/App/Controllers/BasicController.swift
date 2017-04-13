//
//  BasicController.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

import Foundation
import Vapor
import HTTP
import VaporPostgreSQL
import Fluent

/// 包含 ／basic/xxx 路由的处理函数
final class BasicController {
    
    /// 注册加入 ／basic 路由组
    func addToDroplet() {
        let basic = drop.grouped("basic")
        basic.get("version", handler: version)
        basic.get("integrated", handler: integrated)
        basic.get("range", handler: range)
        basic.post("make-fake-measurements", handler: fakeMeasurements)
        basic.post("make-fake-users", handler: fakeUsers)
        basic.post("columns", handler: columns)
    }
    
    /// postgresql version
    func version(request: Request) throws -> ResponseRepresentable {
        guard let db = drop.database?.driver as? PostgreSQLDriver else {
            throw Abort.badRequest
        }
        
        let version = try db.raw("SELECT version()")
        
        return try JSON(node: version)
    }
    
    
    func columns(request: Request) throws -> ResponseRepresentable {
        guard let db = drop.database?.driver as? PostgreSQLDriver else {
            throw Abort.badRequest
        }
        
        let res = try db.raw("select count(*) from information_schema.columns where table_name='vgusers';")
        
        return try JSON(node: res)
    }
    
    /// first of all types
    func integrated(request: Request) throws -> ResponseRepresentable {
        let dictionary = [
            "airHumidity" : Airh.latest,
            "airTemperature" : Airt.latest,
            "soilHumidity": Soilh.latest,
            "soilTemperature": Soilt.latest,
            "lightIntensity": Lighti.latest,
            "co2Concentration": Cooc.latest]
        
        return JSON(dictionary)
    }
    
    /// ?type=airTemperature&from=2017-03-01 08:00:00&to=2017-03-03 08:00:00
    func range(request: Request) throws -> ResponseRepresentable {
        guard
            let type = request.query?["type"]?.string,
            let fromString = request.query?["from"]?.string,
            let toString = request.query?["to"]?.string else {
                throw Abort.badRequest
        }
        
        let from = try fromString.dateTimeIntervalFrom1970()
        let to = try toString.dateTimeIntervalFrom1970()
        
        guard from < to else {
            throw Abort.custom(status: .badRequest, message: "Invalid condition: `from`<\(fromString)> > `to`<\(toString)>")
        }
        
        let range = Range<Double>(uncheckedBounds: (from, to))
        
        switch type {
        case MeasurementType.airTemperature.description:
            return try Airt.query(range: range)
        case MeasurementType.airHumidity.description:
            return try Airh.query(range: range)
        case MeasurementType.soilTemperature.description:
            return try Soilt.query(range: range)
        case MeasurementType.soilHumidity.description:
            return try Soilh.query(range: range)
        case MeasurementType.lightIntensity.description:
            return try Lighti.query(range: range)
        case MeasurementType.co2Concentration.description:
            return try Cooc.query(range: range)
        default:
            throw Abort.custom(status: .badRequest, message: "Invalid query `type`<\(type)> value")
        }
    }
    
    
    
    // MARK: - Fake data api
    
    func fakeMeasurements(request: Request) throws -> ResponseRepresentable {
        
        let meas: [MeasurementType] = [.airTemperature,
                                       .airHumidity,
                                       .co2Concentration,
                                       .lightIntensity,
                                       .soilTemperature,
                                       .soilHumidity]
        let seqs = stride(from: 1, through: 12, by: 1)
        try meas.forEach { mea in
            try seqs.forEach { seq in
                let name = mea.tablename
                guard
                    let item = drop.config["measurement", name, "\(seq)"],
                    let time = item[Measurement.Attr.time]?.string,
                    let value = item[Measurement.Attr.value]?.double else {
                        throw Abort.custom(status: .notFound, message: "read <config.\(mea.tablename).\(seq)> error")
                }
                if var m = mea.classType?.init(time: time, value: value) {
                    try m.save()
                } else {
                    throw Abort.custom(status: .badRequest, message: "class type error")
                }
            }
        }
        
        UserDefaults.standard.set("done", forKey: "CFM")
        
        return "Done"
    }
    
    private func fakeUser(path: String) throws -> VGUser {
        if
            let item = drop.config["vgusers", path],
            let un = item["username"]?.string,
            let up = item["password"]?.string,
            let ud = item["deviceid"]?.string {
            
            let ue = item["email"]?.string ?? ""
            
            return VGUser(username: un, password: up, deviceid: ud, email: ue)
        }
        throw Abort.custom(status: .notFound, message: "read <config.vgusers.\(path)> error")
    }
    
    func fakeUsers(request: Request) throws -> ResponseRepresentable {
        
        var user = try fakeUser(path: "viwii")
        try user.save()
        
        user = try fakeUser(path: "kikoy")
        try user.save()
        
        UserDefaults.standard.set("done", forKey: "CFU")
        
        return "Done"
    }
}
