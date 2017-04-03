//
//  ApiController.swift
//  Speech
//
//  Created by viwii on 2017/4/2.
//
//

import Vapor
import HTTP
import VaporPostgreSQL

final class VGUserController: ResourceRepresentable {
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try VGUser.all().makeNode().converted(to: JSON.self)
    }
    
    /// Create a User with request body: {"username":username,"password":password,"deviceID":deviceID}
    func create(request: Request) throws -> ResponseRepresentable {
        var user = try request.vguser()
        try user.save()
        return user
    }
    
    /// A specific User /user/1
    func show(request: Request, vguser: VGUser) throws -> ResponseRepresentable {
        return vguser
    }
    
    func delete(request: Request, vguser: VGUser) throws -> ResponseRepresentable {
        let json = try vguser.makeJSON()
        try vguser.delete()
        return json
    }
    
    /// Not allowed
    func clear(request: Request) throws -> ResponseRepresentable {
        try VGUser.query().delete()
        return JSON([])
    }
    
    /// The only updatable property is `password`.
    func update(request: Request, vguser: VGUser) throws -> ResponseRepresentable {
        let new = try request.vguser()
        var user = vguser
        user.password = new.password
        try user.save()
        return user
    }
    
    /// Unnecessary
    func replace(request: Request, vguser: VGUser) throws -> ResponseRepresentable {
        try vguser.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<VGUser> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func vguser() throws -> VGUser {
        guard let json = json else { throw Abort.badRequest }
        return try VGUser(node: json)
    }
}
