//
//  Arrow.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 01/06/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

final class Arrow: SKSpriteNode {

    //MARK: - Variables
    let damage: Int
    private(set) var isActive: Bool = true
    private var textureOnGround: SKTexture!
    
    //MARK: - Init
    init(texture: SKTexture?, size: CGSize, damage: Int) {
        self.damage = damage
        super.init(texture: texture, color: .clear, size: size)
        
        textureOnGround = SKTexture(imageNamed: arrowGroundTextureName)
        textureOnGround.filteringMode = .nearest
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
     
        selfDestruction()

        physicsBody?.contactTestBitMask = PhysicsCategory.ground
        
        name = arrowName
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Physics
    private func groundContact() {
        texture = textureOnGround
        
        isActive = false
        
        physicsBody?.isDynamic = false
        
        let xVel = Status.shared.velocidadeChao
        
        name = arrowDesativadaName
        
        let move = SKAction.move(by: CGVector(dx: xVel, dy: 0), duration: 1.0)
        let forever = SKAction.repeatForever(move)
        
        removeAllActions()
        run(forever)
        selfDestruction()
    }

    func selfDestruction() {
        let wait = SKAction.wait(forDuration: 5)
        
        let block = SKAction.run {
            self.removeFromParent()
        }
        
        let sequence = SKAction.sequence([wait, block])
        run(sequence)
    }
}

// MARK: - Collidable
extension Arrow: Collidable {
    func collisionWith(object: Collidable, collisionType: UInt32) {
        guard isActive else { return }
        if object is GroundNode {
            groundContact()
        } else if let aliveObject = object as? Alive {
            aliveObject.remove(lifePoints: damage)
            removeFromParent()
        }
    }
}
