//
//  Airh.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

import Vapor

/// `Type` define
/// 监测数据：空气湿度
///
final class Airh: Measurement, Model {
    
    // Preparation
    
    static func revert(_ database: Database) throws {
        try database.delete("airhs")
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("airhs") {
            $0.id()
            $0.double("value")
            $0.double("time")
        }
    }
}


