//
//  Lighti.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

import Vapor

/// `Type` define
/// 监测数据：光照强度
///
final class Lighti: Measurement, Model {
    
    // Preparation
    
    static func revert(_ database: Database) throws {
        try database.delete("lightis")
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("lightis") {
            $0.id()
            $0.double("time")
            $0.double("value")
        }
    }
}
