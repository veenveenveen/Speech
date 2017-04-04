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
        try database.delete( MeasurementType.airHumidity.tablename )
    }
    
    static func prepare(_ database: Database) throws {
        try database.create( MeasurementType.airHumidity.tablename ) {
            $0.id()
            $0.double( Attr.value )
            $0.double( Attr.time )
        }
    }
}


extension Airh: RangeQueryable {
    
    typealias AttributeType = Double
    
    static func query(range: Range<Double>) throws -> JSON {
        return try Airh.query()
            .filter( Attr.time, .greaterThanOrEquals, range.lowerBound)
            .filter( Attr.time, .lessThanOrEquals, range.upperBound)
            .all()
            .makeJSON()
    }
}
