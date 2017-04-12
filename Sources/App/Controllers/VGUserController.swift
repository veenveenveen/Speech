//
//  ApiController.swift
//  Speech
//
//  Created by viwii on 2017/4/2.
//
//

import Foundation
import Vapor
import HTTP
import VaporPostgreSQL


extension Request {
    
    func vguser() throws -> VGUser {
        guard let json = json else { throw Abort.badRequest }
        return try VGUser(node: json)
    }
    
    /// client: HTTPBody = JSONSerialization.data(_:)
    /// parse it;
    
    func jsonObject() throws -> [String:String] {
        guard let bytes = body.bytes else {
            throw Abort.custom(status: .badRequest, message: "no bytes")
        }
        let data = Data(bytes: bytes)
        
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        
        guard let res = json as? [String:String] else {
            throw Abort.custom(status: .badRequest, message: "not [String:String]")
        }
        return res
    }
    
    var vgusername: String? {
        do {
            let obj = try jsonObject()
            return obj["username"]
        } catch {
            return nil
        }
    }
    
    var vgpassword: String? {
        do {
            let obj = try jsonObject()
            return obj["password"]
        } catch {
            return nil
        }
    }
    
    var vgemail: String? {
        do {
            let obj = try jsonObject()
            return obj["email"]
        } catch {
            return nil
        }
    }
    
    var vgdeviceid: String? {
        do {
            let obj = try jsonObject()
            return obj["deviceid"]
        } catch {
            return nil
        }
    }
}



final class VGUserController: ResourceRepresentable {
    
    // MARK: - Restful methods
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try VGUser.all().makeNode().converted(to: JSON.self)
    }
    
    func show(request: Request, vguser: VGUser) throws -> ResponseRepresentable {
        return vguser
    }
    
    func delete(request: Request, vguser: VGUser) throws -> ResponseRepresentable {
        let json = try vguser.makeJSON()
        try vguser.delete()
        return json
    }
    
    /// The only updatable property is `password`.
    func update(request: Request, vguser: VGUser) throws -> ResponseRepresentable {
        let new = try request.vguser()
        var user = vguser
        user.password = new.password
        try user.save()
        return user
    }
    
    /// Not allowed
    func create(request: Request) throws -> ResponseRepresentable {
        var user = try request.vguser()
        try user.save()
        return user
    }
    
    /// Not allowed
    func replace(request: Request, vguser: VGUser) throws -> ResponseRepresentable {
        try vguser.delete()
        return try create(request: request)
    }
    
    /// Not allowed
    func clear(request: Request) throws -> ResponseRepresentable {
        try VGUser.query().delete()
        return JSON([])
    }
    
    func makeResource() -> Resource<VGUser> {
        return Resource(
            index: index,
            store: nil/*create*/,
            show: show,
            replace: nil/*replace*/,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}


extension VGUserController {
    
    func add(usersGroupedRoutes drop: Droplet) {
        let group = drop.grouped("users")
        group.post("login", handler: login)
        group.post("register", handler: register)
        group.post("findPassword", handler: findPassword)
        group.get("usersview", handler: indexView)
    }
    
    
    // MARK: - Basic api

    /// 应该使用的登录注册方法

    func register(request: Request) throws -> ResponseRepresentable {
        guard
            let username = request.vgusername,
            let password = request.vgpassword,
            let deviceid = request.vgdeviceid else {
                throw Abort.custom(status: .badRequest, message: "Invalid register info")
        }
        let email = request.vgemail ?? ""
        var user = VGUser(username: username, password: password, deviceid: deviceid, email: email)
        try user.save()
        return try user.makeJSON()
    }
    
    func login(request: Request) throws -> ResponseRepresentable {
        guard
            let username = request.vgusername,
            let password = request.vgpassword else {
                throw Abort.custom(status: .badRequest, message: "Invalid login info")
        }
        let user = try VGUser.query().filter("username", username).filter("password", password).all()
        
        guard let u = user.first else {
            throw Abort.badRequest
        }
        return try u.makeJSON()
    }
    
    func findPassword(request: Request) throws -> ResponseRepresentable {
        guard
            let username = request.vgusername,
            let deviceid = request.vgdeviceid else {
                throw Abort.custom(status: .badRequest, message: "Invalid Finding info")
        }
        let user = try VGUser.query().filter("username", username).filter("deviceid", deviceid).all()
        
        guard let u = user.first else {
            throw Abort.badRequest
        }
        return try u.makeJSON()
    }
    
    // MARK: - Views api
    
    func indexView(request: Request) throws -> ResponseRepresentable {
        let allusers = try VGUser.all().makeNode()
        let parameters = try Node(node: [
                "users":allusers
            ])
        return try drop.view.make("vguser", parameters)
    }
}
