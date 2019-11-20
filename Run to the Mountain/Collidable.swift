//
//  Collidable.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso Kuhn on 19/11/19.
//  Copyright © 2019 Warrior Iena. All rights reserved.
//

import SpriteKit

protocol Collidable: SKNode {
    func collisionWith(object: Collidable, collisionType: UInt32)
}
