//
//  GroundNode.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso Kuhn on 29.09.22.
//  Copyright © 2022 Warrior Iena. All rights reserved.
//

import SpriteKit

final class GroundNode: SKSpriteNode {

    // MARK: - Init
    init(screenSize: CGSize) {
        super.init(texture: nil, color: .clear, size: CGSize(width: screenSize.width * 2, height: screenSize.height * 1/8))
        self.position = CGPoint(x: 0, y: size.height * 1/2)

        physicsBody = SKPhysicsBody(rectangleOf: size)

        physicsBody?.affectedByGravity = false

        physicsBody?.categoryBitMask = PhysicsCategory.ground
        physicsBody?.collisionBitMask = PhysicsCategory.none
        physicsBody?.contactTestBitMask = PhysicsCategory.playerArrow | PhysicsCategory.player
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Collidable
extension GroundNode: Collidable {
    func collisionWith(object: Collidable, collisionType: UInt32) {}
}
