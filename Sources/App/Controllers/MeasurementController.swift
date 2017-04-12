//
//  MeasurementController.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

import Foundation

import Vapor
import HTTP
import VaporPostgreSQL


typealias MeasurementModel = Model & MeasurementInfo



/// `Type` define
/// Restful API for Measurement Model controller
///
final class MeasurementController<T> where T: MeasurementModel  {
    
    /// all models
    func index(request: Request) throws -> ResponseRepresentable {
        return try T.all().makeNode().converted(to: JSON.self)
    }
    
    /// add a model
    func create(request: Request) throws -> ResponseRepresentable {
        var t: T = try request.measurement()
        try t.save()
        return t
    }
    
    /// fetch a model
    func show(request: Request, t: T) throws -> ResponseRepresentable {
        return t
    }
    
    func aboutItem(request: Request, t: T) throws -> ResponseRepresentable {
        return t
    }
    
    /// delete a model
    func delete(request: Request, t: T) throws -> ResponseRepresentable {
        let json = try t.makeJSON()
        try t.delete()
        return json
    }
    
    /// delete all models
    func clear(request: Request) throws -> ResponseRepresentable {
        try VGUser.query().delete()
        return JSON([])
    }
    
    
    
    // MARK: - Fake data api
    
    func fakeMeasurement(request: Request) throws -> ResponseRepresentable {
        
        if let _ = UserDefaults.standard.object(forKey: "CFM") {
            return "Exsited!"
        }
        
        let meas: [MeasurementType] = [.airTemperature,.airHumidity,.co2Concentration,.lightIntensity,.soilTemperature,.soilHumidity]
        let seqs = stride(from: 1, through: 12, by: 1)
        try meas.map { $0.tablename }.forEach { key in
            try seqs.forEach { seq in
                guard
                    let item = drop.config["measurement",key,"\(seq)"],
                    let timeString = item[Measurement.Attr.time]?.string,
                    let value = item[Measurement.Attr.value]?.double else {
                        throw Abort.custom(status: .notFound, message: "read <config.\(key).\(seq)> error")
                }
                let time = try timeString.dateTimeIntervalFrom1970()
                var m = T(time: time, value: value)
                try m.save()
            }
        }
        
        UserDefaults.standard.set("done", forKey: "CFM")
        
        return "Done"
    }
    
}


/// So MeasurementController can be used as ResourceRepresentable by Droplet
///
extension MeasurementController: ResourceRepresentable {
    
    func makeResource() -> Resource<T> {
        return Resource(index: index,
                        store: create,
                        show: show,
                        replace: nil,
                        modify: nil,
                        destroy: delete,
                        clear: clear,
                        aboutItem: aboutItem,
                        aboutMultiple: nil)
    }
}

extension MeasurementController where T: RangeQueryable, T.AttributeType == Double {
    
    /// airts/range?from=2017-03-01 08:00:00&to=2017-03-03 08:00:00
    func range(request: Request) throws -> ResponseRepresentable {
        guard
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
        
        return try T.query(range: range)
    }
}


/// 使用Request创建Measurement Model
extension Request {
    
    func measurement<T: MeasurementModel>() throws -> T {
        guard
            let value = data[ Measurement.Attr.value ]?.double,
            let timeStr = data[ Measurement.Attr.time ]?.string else {
                throw Abort.badRequest
        }
        
        let time = try timeStr.dateTimeIntervalFrom1970()
        
        return T(time: time, value: value)
    }
}


