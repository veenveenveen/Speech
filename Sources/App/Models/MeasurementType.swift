//
//  MeasurementType.swift
//  SpeechApp
//
//  Created by viwii on 2017/4/2.
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

