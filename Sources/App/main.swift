///
/// Deploying URL: https://aqueous-falls-99981.herokuapp.com/api/users
///

import Foundation
import Vapor
import HTTP
import VaporPostgreSQL

import Fluent

let drop = Droplet()

extension Droplet {
    
    func append(preparations: [Preparation.Type]) {
        var tem = self.preparations
        tem.append(contentsOf: preparations)
        self.preparations = tem
    }
}

/// create database tables
//drop.preparations.append(VGUser.self)
//drop.preparations.append(Airh.self)
//drop.preparations.append(Airt.self)
//drop.preparations.append(Cooc.self)
//drop.preparations.append(Lighti.self)
//drop.preparations.append(Soilh.self)
//drop.preparations.append(Soilt.self)

drop.append(preparations: [VGUser.self, Airh.self, Airt.self, Cooc.self, Lighti.self, Soilh.self, Soilt.self])

/// adds our provider to the droplet so that the database is available
do {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
} catch {
    assertionFailure("error add VaporPostgreSQL.Provider: \(error.localizedDescription)")
}


/// Welcom page
drop.get { req in
    return try drop.view.make("welcome", [
        "message": drop.localization[req.lang, "welcome", "title"]
        ])
}



/// Regist basic grouped routes
let basic = BasicController()
basic.add(basicGroupedRoutes: drop)

/// /vgusers/xxx restful api
let userResource = VGUserController()
drop.resource("vgusers", userResource)

/// /airh/xxx restful api 75.8
let airhResource = MeasurementController<Airh>()
drop.resource(MeasurementType.airHumidity.tablename, airhResource)
drop.get(MeasurementType.airHumidity.tablename, "range", handler: airhResource.range)

/// /airt/xxx restful api 25.4
let airtResource = MeasurementController<Airt>()
drop.resource(MeasurementType.airTemperature.tablename, airhResource)
drop.get(MeasurementType.airTemperature.tablename, "range", handler: airtResource.range)

/// /soilh/xxx restful api 82.2
let soilhResource = MeasurementController<Soilh>()
drop.resource(MeasurementType.soilHumidity.tablename, airhResource)
drop.get(MeasurementType.soilHumidity.tablename, "range", handler: soilhResource.range)

/// /soilt/xxx restful api 22.8
let soiltResource = MeasurementController<Soilt>()
drop.resource(MeasurementType.soilTemperature.tablename, airhResource)
drop.get(MeasurementType.soilTemperature.tablename, "range", handler: soiltResource.range)

/// /lighti/xxx restful api 18.2
let lightiResource = MeasurementController<Lighti>()
drop.resource(MeasurementType.lightIntensity.tablename, airhResource)
drop.get(MeasurementType.lightIntensity.tablename, "range", handler: lightiResource.range)

/// /cooc/xxx restful api 673.6
let coocResource = MeasurementController<Cooc>()
drop.resource(MeasurementType.co2Concentration.tablename, airhResource)
drop.get(MeasurementType.co2Concentration.tablename, "range", handler: coocResource.range)




drop.run()
