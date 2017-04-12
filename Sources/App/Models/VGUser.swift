//
//  SUser.swift
//  SpeechApp
//
//  Created by viwii on 2017/4/2.
//
//

import Vapor
import Fluent

/// `Type` define
/// 用户
///
struct VGUser: Model {
    
    // MARK: - Properties
    
    let username: String
    
    var password: String
    
    var email: String
    
    let deviceid: String
    
    
    init(username: String, password: String, deviceid: String, email: String) {
        self.id = nil
        self.exists = false
        self.username = username
        self.password = password
        self.email = email
        self.deviceid = deviceid
    }
    
    
    // MARK: - Model
    
    /**
     The entity's primary identifier.
     This is the same value used for
     `find(:_)`.
     */
    var id: Node?

    var exists: Bool = false
    
    // NodeInitializable
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        username = try node.extract("username")
        password = try node.extract("password")
        email = try node.extract("email")
        deviceid = try node.extract("deviceid")
    }
    
    
    // NodeRepresentable
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id":id,
            "username":username,
            "password":password,
            "email":email,
            "deviceid":deviceid
            ])
    }
    
    
    // Preparation

    static func revert(_ database: Database) throws {
        try database.delete("vgusers")
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("vgusers", closure: { (u: Schema.Creator) in
            
            u.id()
            u.string("username")
            u.string("password")
            u.string("email")
            u.string("deviceid")
            
        })
    }
}


