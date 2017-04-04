///
/// Deploying URL: https://aqueous-falls-99981.herokuapp.com/api/users
///

import Foundation
import Vapor
import HTTP
import VaporPostgreSQL


let drop = Droplet()


/// create database table
drop.preparations.append(VGUser.self)
drop.preparations.append(Airh.self)
drop.preparations.append(Airt.self)
drop.preparations.append(Cooc.self)
drop.preparations.append(Lighti.self)
drop.preparations.append(Soilh.self)
drop.preparations.append(Soilt.self)


/// adds our provider to the droplet so that the database is available
do {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
} catch {
    assertionFailure("error add VaporPostgreSQL.Provider: \(error.localizedDescription)")
}


/// Regist basic grouped routes
let basic = BasicController()
basic.add(basicGroupedRoutes: drop)


/// /vgusers/xxx restful api
let userResource = VGUserController()
drop.resource("vgusers", userResource)

/// /airh/xxx restful api 75.8
let airhResource = MeasurementController<Airh>()
drop.resource("airhs", airhResource)

/// /airt/xxx restful api 25.4
let airtResource = MeasurementController<Airt>()
drop.resource("airts", airhResource)

/// /soilh/xxx restful api 82.2
let soilhResource = MeasurementController<Soilh>()
drop.resource("soilhs", airhResource)

/// /soilt/xxx restful api 22.8
let soiltResource = MeasurementController<Soilt>()
drop.resource("soilts", airhResource)

/// /lighti/xxx restful api 18.2
let lightiResource = MeasurementController<Lighti>()
drop.resource("lightis", airhResource)

/// /cooc/xxx restful api 673.6
let coocResource = MeasurementController<Cooc>()
drop.resource("coocs", airhResource)


/// Welcom page
drop.get { req in
    return try drop.view.make("welcome", [
        "message": drop.localization[req.lang, "welcome", "title"]
        ])
}


drop.run()
