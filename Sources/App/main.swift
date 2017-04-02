import Vapor
import HTTP

let drop = Droplet()

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.group("api") { api in
    
    api.post("login", handler: { (request) -> ResponseRepresentable in
        
        guard
            let username = request.data["username"]?.string,
            let password = request.data["password"]?.string else {
                throw Abort.badRequest
        }
        
        return "FFEA8B35C6A"
    })
    
    api.get("users", handler: { (request) -> ResponseRepresentable in
        
//        let user = try VGUser
        
        return "FFEA8B35C6A"
    })
    
    api.get("sensor", "\(MeasurementType.integrated).json", handler: { (request) -> ResponseRepresentable in
        
        return try JSON(node: [
            "\(MeasurementType.airHumidity)"        :   75.8,
            "\(MeasurementType.airTemperature)"     :   25.4,
            "\(MeasurementType.soilHumidity)"       :   82.2,
            "\(MeasurementType.soilTemperature)"    :   22.8,
            "\(MeasurementType.lightIntensity)"     :   18.2,
            "\(MeasurementType.co2Concentration)"   :   673.6
            ])
    })
}

drop.resource("posts", PostController())

drop.run()
