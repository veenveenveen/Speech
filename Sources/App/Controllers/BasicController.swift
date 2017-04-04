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
//import JSON

/// 包含 ／basic/xxx 路由的处理函数
final class BasicController {
    
    /// 注册加入 ／basic 路由组
    func add(basicGroupedRoutes drop: Droplet) {
        let basic = drop.grouped("basic")
        basic.get("version", handler: version)
        basic.get("measurement", handler: measurement)
    }
    
    /// postgresql version
    func version(request: Request) throws -> ResponseRepresentable {
        guard let db = drop.database?.driver as? PostgreSQLDriver else {
            throw Abort.badRequest
        }
        
        let version = try db.raw("SELECT version()")
        
        return try JSON(node: version)
    }
    
    func measurement(request: Request) throws -> ResponseRepresentable {
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
    
}
