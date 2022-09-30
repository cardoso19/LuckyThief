//
//  Player.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 16/05/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

final class Player: LiveObject {
    //MARK: - Init
    init(size: CGSize, life: Int, attack: Int) {
        let horseTextures = AnimationCache.shared.fetchTextures(name: horseTextureName,
                                                                numberOfFrames: 14,
                                                                zPosition: playerZposition)
        let playerTextures = AnimationCache.shared.fetchTextures(name: playerTextureName,
                                                                numberOfFrames: 14,
                                                                zPosition: playerZposition + 50)
        super.init(textures: [horseTextures, playerTextures],
                   size: size,
                   life: life,
                   attack: attack,
                   mass: 0,
                   affectedByGravity: false,
                   allowsRotation: false,
                   isDynamic: false)
        generalConfigs()
        configPhysics()
    }
    
    private func configPhysics() {
        physicsBody?.categoryBitMask = PhysicsCategory.player
        physicsBody?.collisionBitMask = PhysicsCategory.none
        physicsBody?.contactTestBitMask = PhysicsCategory.enemyArrow
    }
    
    private func generalConfigs() {
        name = playerName
        zPosition = playerZposition
    }
    
    // MARK: - Death
    override func theObjectIsDead() {
        Status.shared.thePlayerIsDead()
    }
}

// MARK: - Collidable
extension Player: Collidable {
    func collisionWith(object: Collidable, collisionType: UInt32) {}
}

// MARK: - ArcherAbility
extension Player: ArcherAbility {
    var arrowTexture: SKTexture {
        let texture = SKTexture(imageNamed: arrowTextureName)
        texture.filteringMode = .nearest
        return texture
    }
    
    func shootArrow(with velocity: CGVector) {
        guard let gameLayer = self.parent else { return }

        let arrow = Arrow(texture: arrowTexture,
                          size: CGSize(width: size.width / 15, height: size.height / 4),
                          damage: attack)
        arrow.position = CGPoint(x: self.position.x, y: self.position.y)

        arrow.physicsBody?.categoryBitMask = PhysicsCategory.playerArrow
        arrow.physicsBody?.collisionBitMask = PhysicsCategory.enemyArrow
        arrow.physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.ground
        
        gameLayer.addChild(arrow)
        
        arrow.physicsBody?.applyImpulse(velocity)
        arrow.zRotation = atan2(velocity.dy, velocity.dx) + CGFloat(Double.pi/2)
    }
}
