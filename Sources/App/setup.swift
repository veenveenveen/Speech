//
//  setup.swift
//  Speech
//
//  Created by viwii on 2017/4/12.
//
//

import Foundation
import Vapor
import HTTP
import VaporPostgreSQL


func setup(drop: Droplet) throws {
    
    /// create database tables
    drop.append(preparations: [VGUser.self, Airh.self, Airt.self, Cooc.self, Lighti.self, Soilh.self, Soilt.self])
    
    
    /// adds our provider to the droplet so that the database is available
    try drop.addProvider(VaporPostgreSQL.Provider.self)
    
    
    /// Welcome page
    drop.get { req in
        
        let local = drop.localization[req.lang, "welcome", "title"]
        
        return try drop.view.make("welcome", ["message":local])
    }
    
    
    /// Regist basic grouped routes
    let basic = BasicController()
    basic.addToDroplet()
    
    
    /// /vgusers/xxx restful api
    let user = VGUserController()
    drop.resource("users", user)
    user.addToDroplet()
    
    
    /// /airh/xxx restful api 75.8
    let airhResource = MeasurementController<Airh>()
    airhResource.add(route: MeasurementType.airHumidity.tablename, to: drop)
    
    /// /airt/xxx restful api 25.4
    let airtResource = MeasurementController<Airt>()
    airtResource.add(route: MeasurementType.airTemperature.tablename, to: drop)

    
    /// /soilh/xxx restful api 82.2
    let soilhResource = MeasurementController<Soilh>()
    soilhResource.add(route: MeasurementType.soilHumidity.tablename, to: drop)

    
    /// /soilt/xxx restful api 22.8
    let soiltResource = MeasurementController<Soilt>()
    soiltResource.add(route: MeasurementType.soilTemperature.tablename, to: drop)

    
    /// /lighti/xxx restful api 18.2
    let lightiResource = MeasurementController<Lighti>()
    lightiResource.add(route: MeasurementType.lightIntensity.tablename, to: drop)

    
    /// /cooc/xxx restful api 673.6
    let coocResource = MeasurementController<Cooc>()
    coocResource.add(route: MeasurementType.co2Concentration.tablename, to: drop)
    
    drop.resource(MeasurementType.airHumidity.tablename, airhResource)

    drop.resource(MeasurementType.airTemperature.tablename, airtResource)

    drop.resource(MeasurementType.soilHumidity.tablename, soilhResource)

    drop.resource(MeasurementType.soilTemperature.tablename, soiltResource)

    drop.resource(MeasurementType.lightIntensity.tablename, lightiResource)

    drop.resource(MeasurementType.co2Concentration.tablename, coocResource)

}
