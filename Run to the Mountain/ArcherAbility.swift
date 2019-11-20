//
//  ArcherAbility.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso Kuhn on 20/11/19.
//  Copyright © 2019 Warrior Iena. All rights reserved.
//

import SpriteKit

protocol ArcherAbility: SKNode {
    var arrowTexture: SKTexture { get }
    func shootArrow(at velocity: CGVector)
}
