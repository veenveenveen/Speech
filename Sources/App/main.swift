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

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.group("api") { api in
    
    /// postgresql version
    api.get("version") { _ in
        
        guard let db = drop.database?.driver as? PostgreSQLDriver else {
            throw Abort.badRequest
        }
        
        let version = try db.raw("SELECT version()")
        
        return try JSON(node: version)
    }
    
    /// request body: {"username":username,"password":password,"deviceID":deviceID}
    api.post("login", handler: { (request) -> ResponseRepresentable in
        
        guard
            let username = request.data["username"]?.string,
            let password = request.data["password"]?.string else {
                throw Abort.badRequest
        }
        
        return "FFEA8B35C6A"
    })
    
    /// request body: {"username":username,"password":password,"deviceID":deviceID}
    api.post("register", handler: { (request) -> ResponseRepresentable in
        
        var user = try VGUser(node: request.json)
        
        print(user)
        
        try user.save()
        
        print(user)

        return try user.makeJSON()
    })
    
    /// /users
    api.get("users", handler: { (request) -> ResponseRepresentable in
        
        let users = try VGUser.all().makeNode()
        
        return try JSON(node: ["users":users])
    })
    
    /// /user/1
    api.get("user", Int.self, handler: { request, id -> ResponseRepresentable in
        
        guard let user = try VGUser.find( id ) else {
            throw Abort.badRequest
        }
        
        
        return try user.makeJSON()
    })
    
    /// request body: {"id":1}
    api.post("deleteuser", Int.self, handler: { (request, id) -> ResponseRepresentable in
        
        guard let user = try VGUser.find(id) else {
            throw Abort.badRequest
        }
        
        let json = try user.makeJSON()
        
        try user.delete()
        
        return json
    })
    
    
    api.post("deleteusers", handler: { (request) -> ResponseRepresentable in
        
        let users = try VGUser.all()
        
        var count = 0
        users.forEach({ (user) in
            do {
                try user.delete()
                count += 1
            } catch {
                print("Fail to delete user \(user.id ?? "xx", user.username)")
                return
            }
            
        })
        
        return "deleted \(count) of all \(users.count)  users"
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
