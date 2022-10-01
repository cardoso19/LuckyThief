//
//  ArcherAbility.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso Kuhn on 20/11/19.
//  Copyright © 2019 Warrior Iena. All rights reserved.
//

import SpriteKit

protocol ArcherAbility: SKSpriteNode {
    var arrowType: ArrowType { get }
    var attack: Int { get }
    func shootArrow(with velocity: CGVector)
}

extension ArcherAbility {
    func shootArrow(with velocity: CGVector) {
        guard let gameLayer = self.parent else { return }
        let arrow = ArrowPool.shared.getArrow()
        arrow.position = position
        gameLayer.addChild(arrow)
        arrow.setType(arrowType, damage: attack)
        arrow.prepareForShooting(impulse: velocity)
    }
}
