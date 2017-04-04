//
//  MeasurementController.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//


import Vapor
import HTTP
import VaporPostgreSQL


typealias MeasurementModel = Model & MeasurementInfo & MeasurementInfoInitializable



/// `Type` define
/// Restful API for Measurement Model controller
///
final class MeasurementController<T> where T: MeasurementModel  {
    
    /// all models
    func index(request: Request) throws -> ResponseRepresentable {
        print(self, #function)
        return try T.all().makeNode().converted(to: JSON.self)
    }
    
    /// add a model
    func create(request: Request) throws -> ResponseRepresentable {
        print(self, #function)
        var t: T = try request.measurement()
        try t.save()
        return t
    }
    
    /// fetch a model
    func show(request: Request, t: T) throws -> ResponseRepresentable {
        print(self, #function)
        return t
    }
    
    func aboutItem(request: Request, t: T) throws -> ResponseRepresentable {
        print(self, #function)
        return t
    }
    
    /// delete a model
    func delete(request: Request, t: T) throws -> ResponseRepresentable {
        print(self, #function)
        let json = try t.makeJSON()
        try t.delete()
        return json
    }
    
    /// delete all models
    func clear(request: Request) throws -> ResponseRepresentable {
        print(self, #function)
        try VGUser.query().delete()
        return JSON([])
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


/// 使用Request创建Measurement Model
extension Request {
    
    func measurement<T: MeasurementModel>() throws -> T {
        
        guard
            let timeStr = data["time"]?.string,
            let valueStr = data["value"]?.string,
            let value = Double(valueStr) else {
                throw Abort.badRequest
        }
        
        let time = try timeStr.dateTimeIntervalFrom1970()
        
        let t = T(time: time, value: value)
        
        print(timeStr, valueStr, value, time, t)
        
        return t
    }
}
