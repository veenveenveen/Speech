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


/// 使用Request创建Measurement Model
extension Request {
    
    func measurement<T: MeasurementModel>() throws -> T {
        guard
            let value = data[ Measurement.Attr.value ]?.double,
            let time = data[ Measurement.Attr.time ]?.string else {
                throw Abort.badRequest
        }
        
        return T(time: time, value: value)
    }
}


/// `Type` define
/// Restful API for Measurement Model controller
///
final class MeasurementController<T>: ResourceRepresentable where T: MeasurementModel  {
    
    
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
    
    
    // MARK: - ResourceRepresentable
    
    /// So MeasurementController can be used as ResourceRepresentable by Droplet
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
    
    
    // MARK: - Views api
    
    func indexView(request: Request) throws -> ResponseRepresentable {
        let nodes = try T.all().makeNode()
        
        guard let arr = nodes.array else {
            throw Abort.custom(status: .badRequest, message: "parse error.")
        }
        
        let items = try arr.map({ (node) -> Node in
            guard
                let node = node.object,
                let id = node["id"]?.int,
                let time = node["time"]?.double,
                let value = node["value"]?.double else {
                    throw Abort.custom(status: .badRequest, message: "parse error.")
            }
            let date = Date(timeIntervalSince1970: time).description
            let nod = try Node(node: [
                Measurement.Attr.id     :   Node(id),
                Measurement.Attr.time   :   date,
                Measurement.Attr.value  :   value])
            return nod
        })
        
        let parameters = try Node(node: ["items":Node(items)])
        return try drop.view.make("measurement", parameters)
    }
}


extension MeasurementController where T: RangeQueryable, T.AttributeType == Double {
    
    func add(route: String, to drop: Droplet) {
        drop.get(route, "range", handler: range)
        drop.get(route, "views", handler: indexView)
    }
    
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




