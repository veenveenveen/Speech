//
//  Airt.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

import Vapor

/// `Type` define
/// 监测数据：空气温度
///
struct Airt: Model {
    
    // MARK: - Properties
    
    /// 采样时间
    var time: Double
    /// 采样值
    var value: Double
    
    init(time: Double, value: Double) {
        self.id = nil
        self.exists = false
        self.time = time
        self.value = value
    }
    
    
    // MARK: - Model
    
    var id: Node?
    
    var exists: Bool = false
    
    // NodeInitializable
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        time = try node.extract("time")
        value = try node.extract("value")
    }
    
    
    // NodeRepresentable
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id":id,
            "time":time,
            "value":value
            ])
    }
    
    
    // Preparation
    
    static func revert(_ database: Database) throws {
        try database.delete("airts")
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("airts") {
            $0.id()
            $0.double("time")
            $0.double("value")
        }
    }
}
