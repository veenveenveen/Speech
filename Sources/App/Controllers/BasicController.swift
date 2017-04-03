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

/// 包含 ／basic/xxx 路由的处理函数
final class BasicController {
    
    /// 注册加入 ／basic 路由组
    func add(basicGroupedRoutes drop: Droplet) {
        let basic = drop.grouped("basic")
        basic.get("version", handler: version)
    }
    
    /// postgresql version
    func version(request: Request) throws -> ResponseRepresentable {
        guard let db = drop.database?.driver as? PostgreSQLDriver else {
            throw Abort.badRequest
        }
        
        let version = try db.raw("SELECT version()")
        
        return try JSON(node: version)
    }
    
    
    
}
