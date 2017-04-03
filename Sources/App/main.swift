/// https://aqueous-falls-99981.herokuapp.com/api/users

import Vapor
import HTTP
import VaporPostgreSQL

let drop = Droplet()

/// so that we can use our model with the database
drop.preparations.append(VGUser.self)

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

//
///// Regist basic grouped routes
//let basic = BasicController()
//basic.add(basicGroupedRoutes: drop)
//
//
///// /vgusers/xxx restful api
//let userResource = VGUserController()
//drop.resource("vgusers", userResource)
//

drop.group("api") { api in
    
    
//    api.get("sensor", "\(MeasurementType.integrated).json", handler: { (request) -> ResponseRepresentable in
//        
//        return try JSON(node: [
//            "\(MeasurementType.airHumidity)"        :   75.8,
//            "\(MeasurementType.airTemperature)"     :   25.4,
//            "\(MeasurementType.soilHumidity)"       :   82.2,
//            "\(MeasurementType.soilTemperature)"    :   22.8,
//            "\(MeasurementType.lightIntensity)"     :   18.2,
//            "\(MeasurementType.co2Concentration)"   :   673.6
//            ])
//    })
}


drop.run()
