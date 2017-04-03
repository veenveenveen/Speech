//
//  Cooc.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

import Vapor

/// `Type` define
/// 监测数据：二氧化碳浓度
///
final class Cooc: Measurement, Model {
    
    // Preparation
    
    static func revert(_ database: Database) throws {
        try database.delete("coocs")
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("coocs") {
            $0.id()
            $0.double("time")
            $0.double("value")
        }
    }
}
