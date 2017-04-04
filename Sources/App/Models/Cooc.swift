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
        try database.delete(MeasurementType.co2Concentration.tablename)
    }
    
    static func prepare(_ database: Database) throws {
        try database.create(MeasurementType.co2Concentration.tablename) {
            $0.id()
            $0.double( Attr.value )
            $0.double( Attr.time )
        }
    }
}


extension Cooc: RangeQueryable {
    typealias AttributeType = Double

    static func query(range: Range<Double>) throws -> JSON {
        return try Cooc.query()
            .filter( Attr.time, .greaterThanOrEquals, range.lowerBound)
            .filter( Attr.time, .lessThanOrEquals, range.upperBound)
            .all()
            .makeJSON()
    }
}
