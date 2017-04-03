//
//  MeasurementModel.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

/// 监测信息种类
///
public enum MeasurementType: Int, Equatable {
    
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


import Vapor

/// `Type` define
/// 监测数据：空气温度
///
class Measurement {
    
    // MARK: - Properties
    
    /// 采样时间
    var time: Double
    /// 采样值
    var value: Double
    
    init(time: Double, value: Double) {
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
        id = try node.extract("id")
        time = try node.extract("time")
        value = try node.extract("value")
    }
    
    
    // NodeRepresentable
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id":id,
            "time":time,
            "value":value
            ])
    }
}
