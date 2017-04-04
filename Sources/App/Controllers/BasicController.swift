//
//  BasicController.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

import Vapor
import HTTP
import VaporPostgreSQL
import Fluent

/// 包含 ／basic/xxx 路由的处理函数
final class BasicController {
    
    /// 注册加入 ／basic 路由组
    func add(basicGroupedRoutes drop: Droplet) {
        let basic = drop.grouped("basic")
        basic.get("version", handler: version)
        basic.get("integrated", handler: integrated)
        basic.get("range", handler: range)
    }
    
    /// postgresql version
    func version(request: Request) throws -> ResponseRepresentable {
        guard let db = drop.database?.driver as? PostgreSQLDriver else {
            throw Abort.badRequest
        }
        
        let version = try db.raw("SELECT version()")
        
        return try JSON(node: version)
    }
    
    /// first of all types
    func integrated(request: Request) throws -> ResponseRepresentable {
        var nodes = [JSON]()
        var json: JSON
        
        if let f = try Airh.query().first() {
            json = try f.makeNode().converted(to: JSON.self)
        } else {
            json = JSON( [:] )
        }
        nodes.append(JSON( ["airHumidity" : json ] ) )

        if let f = try Airt.query().first() {
            json = try f.makeNode().converted(to: JSON.self)
        } else {
            json = JSON( [:] )
        }
        nodes.append(JSON( ["airTemperature" : json ] ) )
        
        if let f = try Soilh.query().first() {
            json = try f.makeNode().converted(to: JSON.self)
        } else {
            json = JSON( [:] )
        }
        nodes.append(JSON( ["soilHumidity" : json ] ) )
        
        if let f = try Soilt.query().first() {
            json = try f.makeNode().converted(to: JSON.self)
        } else {
            json = JSON( [:] )
        }
        nodes.append(JSON( ["soilTemperature" : json ] ) )
        
        if let f = try Lighti.query().first() {
            json = try f.makeNode().converted(to: JSON.self)
        } else {
            json = JSON( [:] )
        }
        nodes.append(JSON( ["lightIntensity" : json ] ) )
        
        if let f = try Cooc.query().first() {
            json = try f.makeNode().converted(to: JSON.self)
        } else {
            json = JSON( [:] )
        }
        nodes.append(JSON( ["co2Concentration" : json ] ) )

        return try nodes.makeJSON()
    }
    
    /// { from:2017-03-01 08:00:00, to:2017-03-03 08:00:00 }
    func airTemperature(request: Request) throws -> ResponseRepresentable {
        guard
            let fromString = request.data["from"]?.string,
            let toString = request.data["to"]?.string else {
                throw Abort.badRequest
        }
        
        let from = try fromString.dateTimeIntervalFrom1970()
        let to = try toString.dateTimeIntervalFrom1970()
        
        guard from < to else {
            throw Abort.badRequest
        }
        
        return try Airt.query()
            .filter("time", .greaterThanOrEquals, from)
            .filter("time", .lessThanOrEquals, to)
            .all()
            .makeJSON()
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
}
