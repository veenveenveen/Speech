//
//  MeasurementModel.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

import Vapor


/// 监测数据需要记录的监测信息
///
protocol MeasurementInfo {
    
    var time: Double {get set}
    
    var value: Double {get set}
    
    init(time: Double, value: Double)
}


protocol RangeQueryable {
    
    associatedtype AttributeType: Comparable
    
    static var latest: JSON { get }
    
    static func query(range: Range<AttributeType>) throws -> JSON
}


typealias MeasurementModel = Model & MeasurementInfo


/// `Abstact` class
/// 监测数据的抽象父类，实现了部分Model协议，除了Preparation
/// Preparation 需要静态方法，只能由单独的数据结构实现
///
class Measurement: MeasurementInfo {
    
    // MARK: - Properties
    
    /// 采样时间
    var time: Double
    
    /// 采样值
    var value: Double
    
    required init(time: Double, value: Double) {
        self.id = nil
        self.exists = false
        self.time = time
        self.value = value
    }
    
    // MARK: - Model
    
    var id: Node?
    
    var exists: Bool = false
    
    // NodeInitializable
    
    required init(node: Node, in context: Context) throws {
        id = try node.extract(Attr.id)
        time = try node.extract(Attr.time)
        value = try node.extract(Attr.value)
    }
    
    // NodeRepresentable
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            Attr.id:id,
            Attr.time:time,
            Attr.value:value])
    }
}

extension Measurement: NodeInitializable, NodeRepresentable { }

extension Measurement {
    
    struct Attr {
        static let id = "id"
        static let time = "time"
        static let value = "value"
    }
}



/// `Type` define
/// 监测数据：空气湿度
///
final class Airh: Measurement, Model, RangeQueryable {
    
    // MARK: - Preparation
    
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
    
    
    // MARK: - RangeQueryable
    
    typealias AttributeType = Double
    
    static func query(range: Range<Double>) throws -> JSON {
        return try Airh.query()
            .filter( Attr.time, .greaterThanOrEquals, range.lowerBound)
            .filter( Attr.time, .lessThanOrEquals, range.upperBound)
            .all()
            .makeJSON()
    }
    
    static var latest: JSON {
        
        do {
            let f = try Airh.query().sort(Measurement.Attr.time, .descending).first()?.makeJSON().converted(to: JSON.self)
            
            return f ?? JSON( [:] )
        } catch {
            return JSON( [:] )
        }
    }
}





/// `Type` define
/// 监测数据：空气温度
///
final class Airt: Measurement, Model, RangeQueryable {
    
    // Preparation
    
    static func revert(_ database: Database) throws {
        try database.delete( MeasurementType.airTemperature.tablename )
    }
    
    static func prepare(_ database: Database) throws {
        try database.create( MeasurementType.airTemperature.tablename ) {
            $0.id()
            $0.double( Attr.value )
            $0.double( Attr.time )
        }
    }
    
    
    // MARK: - RangeQueryable
    
    typealias AttributeType = Double
    
    static func query(range: Range<Double>) throws -> JSON {
        return try Airt.query()
            .filter( Attr.time, .greaterThanOrEquals, range.lowerBound)
            .filter( Attr.time, .lessThanOrEquals, range.upperBound)
            .all()
            .makeJSON()
    }
    
    static var latest: JSON {
        
        do {
            let f = try Airt.query().sort(Measurement.Attr.time, .descending).first()?.makeJSON().converted(to: JSON.self)
            
            return f ?? JSON( [:] )
        } catch {
            return JSON( [:] )
        }
    }
}



/// `Type` define
/// 监测数据：二氧化碳浓度
///
final class Cooc: Measurement, Model, RangeQueryable {
    
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
    
    
    // MARK: - RangeQueryable
    
    typealias AttributeType = Double
    
    static func query(range: Range<Double>) throws -> JSON {
        return try Cooc.query()
            .filter( Attr.time, .greaterThanOrEquals, range.lowerBound)
            .filter( Attr.time, .lessThanOrEquals, range.upperBound)
            .all()
            .makeJSON()
    }
    
    static var latest: JSON {
        
        do {
            let f = try Cooc.query().sort(Measurement.Attr.time, .descending).first()?.makeJSON().converted(to: JSON.self)
            
            return f ?? JSON( [:] )
        } catch {
            return JSON( [:] )
        }
    }
}



/// `Type` define
/// 监测数据：光照强度
///
final class Lighti: Measurement, Model, RangeQueryable {
    
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
    
    
    
    // MARK: - RangeQueryable
    
    typealias AttributeType = Double
    
    static func query(range: Range<Double>) throws -> JSON {
        return try Lighti.query()
            .filter( Attr.time, .greaterThanOrEquals, range.lowerBound)
            .filter( Attr.time, .lessThanOrEquals, range.upperBound)
            .all()
            .makeJSON()
    }
    
    static var latest: JSON {
        
        do {
            let f = try Lighti.query().sort(Measurement.Attr.time, .descending).first()?.makeJSON().converted(to: JSON.self)
            
            return f ?? JSON( [:] )
        } catch {
            return JSON( [:] )
        }
    }
}



/// `Type` define
/// 监测数据：土壤湿度
///
final class Soilh: Measurement, Model, RangeQueryable {
    
    // Preparation
    
    static func revert(_ database: Database) throws {
        try database.delete(MeasurementType.soilHumidity.tablename)
    }
    
    static func prepare(_ database: Database) throws {
        try database.create(MeasurementType.soilHumidity.tablename) {
            $0.id()
            $0.double( Attr.value )
            $0.double( Attr.time )
        }
    }
    
    
    // MARK: - RangeQueryable
    
    typealias AttributeType = Double
    
    static func query(range: Range<Double>) throws -> JSON {
        return try Soilh.query()
            .filter( Attr.time, .greaterThanOrEquals, range.lowerBound)
            .filter( Attr.time, .lessThanOrEquals, range.upperBound)
            .all()
            .makeJSON()
    }
    
    static var latest: JSON {
        
        do {
            let f = try Soilh.query().sort(Measurement.Attr.time, .descending).first()?.makeJSON().converted(to: JSON.self)
            
            return f ?? JSON( [:] )
        } catch {
            return JSON( [:] )
        }
    }
}




/// `Type` define
/// 监测数据：土壤温度
///
final class Soilt: Measurement, Model, RangeQueryable {
    
    // Preparation
    
    static func revert(_ database: Database) throws {
        try database.delete(MeasurementType.soilTemperature.tablename)
    }
    
    static func prepare(_ database: Database) throws {
        try database.create(MeasurementType.soilTemperature.tablename) {
            $0.id()
            $0.double( Attr.value )
            $0.double( Attr.time )
        }
    }
    
    
    // MARK: - RangeQueryable
    
    typealias AttributeType = Double
    
    static func query(range: Range<Double>) throws -> JSON {
        return try Soilt.query()
            .filter( Attr.time, .greaterThanOrEquals, range.lowerBound)
            .filter( Attr.time, .lessThanOrEquals, range.upperBound)
            .all()
            .makeJSON()
    }
    
    static var latest: JSON {
        
        do {
            let f = try Soilt.query().sort(Measurement.Attr.time, .descending).first()?.makeJSON().converted(to: JSON.self)
            
            return f ?? JSON( [:] )
        } catch {
            return JSON( [:] )
        }
    }
}
