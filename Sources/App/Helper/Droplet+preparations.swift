//
//  Droplet+preparations.swift
//  Speech
//
//  Created by viwii on 2017/4/4.
//
//

import Vapor
import Fluent


extension Droplet {
    
    func append(preparations: [Preparation.Type]) {
        var tmp = self.preparations
        tmp.append(contentsOf: preparations)
        self.preparations = tmp
    }
}
