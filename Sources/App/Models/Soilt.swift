//
//  Soilt.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

import Vapor

/// `Type` define
/// 监测数据：土壤温度
///
final class Soilt: Measurement, Model {
    
    // Preparation
    
    static func revert(_ database: Database) throws {
        try database.delete("soilts")
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("soilts") {
            $0.id()
            $0.double("time")
            $0.double("value")
        }
    }
}
