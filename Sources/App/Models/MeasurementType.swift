//
//  MeasurementType.swift
//  Speech
//
//  Created by viwii on 2017/4/12.
//
//

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
    
    var classType: MeasurementModel.Type? {
        switch self {
        case .airHumidity: return Airh.self
        case .airTemperature: return Airt.self
        case .soilHumidity: return Soilh.self
        case .soilTemperature: return Soilt.self
        case .lightIntensity: return Lighti.self
        case .co2Concentration: return Cooc.self
        case .integrated: return nil
        }
    }
}
