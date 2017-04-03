//
//  Airt.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

import Vapor

/// `Type` define
/// 监测数据：空气温度
///
final class Airt: Measurement, Model {
    
    // Preparation
    
    static func revert(_ database: Database) throws {
        try database.delete("airts")
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("airts") {
            $0.id()
            $0.double("time")
            $0.double("value")
        }
    }
}
