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
        try database.delete(MeasurementType.lightIntensity.tablename)
    }
    
    static func prepare(_ database: Database) throws {
        try database.create(MeasurementType.lightIntensity.tablename) {
            $0.id()
            $0.double( Attr.value )
            $0.double( Attr.time )
        }
    }
}


extension Lighti:RangeQueryable {
    typealias AttributeType = Double

    static func query(range: Range<Double>) throws -> JSON {
        return try Lighti.query()
            .filter( Attr.time, .greaterThanOrEquals, range.lowerBound)
            .filter( Attr.time, .lessThanOrEquals, range.upperBound)
            .all()
            .makeJSON()
    }
}
