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
/// 代表一个登录用户
///
class VGUser: Model {
    
    // MARK: - Properties
    
    let username: String
    
    let password: String
    
    let deviceID: String
    
    /// This property details whether or not the instance was retrieved from the database 
    /// and should not be interacted with directly.
    var isExisted: Bool = false
    
    init(username: String, password: String, deviceID: String) {
        self.username = username
        self.password = password
        self.deviceID = deviceID
    }
    
    
    // MARK: - Model
    
    /**
     The entity's primary identifier.
     This is the same value used for
     `find(:_)`.
     */
    var id: Node?

    
    /**
     Initialize the convertible with a node within a context.
     
     Context is an empty protocol to which any type can conform.
     This allows flexibility. for objects that might require access
     to a context outside of the node ecosystem
     */
    required init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        username = try node.extract("username")
        password = try node.extract("password")
        deviceID = try node.extract("deviceID")
    }
    
    /**
     Turn the convertible into a node
     
     - throws: if convertible can not create a Node
     - returns: a node if possible
     */
    func makeNode(context: Context) throws -> Node {
        return try Node(node: ["id":id,"username":username,"password":password,"deviceID":deviceID])
    }
    
    /**
     The revert method should undo any actions
     caused by the prepare method.
     
     If this is impossible, the `PreparationError.revertImpossible`
     error should be thrown.
     */
    static func revert(_ database: Database) throws {
        try database.delete("speech")
    }
    
    /**
     The prepare method should call any methods
     it needs on the database to prepare.
     */
    static func prepare(_ database: Database) throws {
        try database.create("speech", closure: { (speech: Schema.Creator) in
            
            speech.id()
            speech.string("username")
            speech.string("password")
            speech.string("deviceID")
            
        })
    }
}


