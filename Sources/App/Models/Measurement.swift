//
//  MeasurementModel.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

import Vapor

/// 监测信息种类
///
enum MeasurementType: Int, Equatable {
    
    /// 空气温度
    case airTemperature
    
    /// 空气湿度
    case airHumidity
    
    /// 土壤温度
    case soilTemperature
    
    /// 土壤湿度
    case soilHumidity
    
    /// 光照强度
    case lightIntensity
    
    /// CO2浓度
    case co2Concentration
    
    /// 综合
    case integrated
}

extension MeasurementType {
    var description: String {
        switch self {
        case .airHumidity: return "airHumidity"
        case .airTemperature: return "airTemperature"
        case .soilHumidity: return "soilHumidity"
        case .soilTemperature: return "soilTemperature"
        case .lightIntensity: return "lightIntensity"
        case .co2Concentration: return "co2Concentration"
        case .integrated: return "integrated"
        }
    }
    
    var shortDescription: String {
        switch self {
        case .airHumidity: return "airh"
        case .airTemperature: return "airt"
        case .soilHumidity: return "soilh"
        case .soilTemperature: return "soilt"
        case .lightIntensity: return "lighti"
        case .co2Concentration: return "cooc"
        case .integrated: return "all"
        }
    }
    
    var tablename: String {
        return "\(shortDescription)s"
    }
}


/// 监测数据需要记录的监测信息
///
protocol MeasurementInfo {
    
    /// yyyy
    var time: Double {get set}
    
    var value: Double {get set}
    
}

protocol MeasurementInfoInitializable {
    
    init(time: Double, value: Double)
}

protocol RangeQueryable {
    
    associatedtype AttributeType: Comparable
    
    static func query(range: Range<AttributeType>) throws -> JSON
}

/// `Type` define
/// 监测数据的抽象父类，实现了部分Model协议，除了Preparation
/// Preparation 需要静态方法，只能由单独的数据结构实现
///
class Measurement: MeasurementInfo, MeasurementInfoInitializable {
    
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
            Attr.value:value
            ])
    }
}

extension Measurement: NodeInitializable, NodeRepresentable {
    
}

extension Measurement {
    
    struct Attr {
        static let id = "id"
        static let time = "time"
        static let value = "value"
    }
}
