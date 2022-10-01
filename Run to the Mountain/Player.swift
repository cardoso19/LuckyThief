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
        let horseTextures = TextureCache.shared.fetchTextures(name: horseTextureName,
                                                              numberOfFrames: 14,
                                                              zPosition: playerZposition)
        let playerTextures = TextureCache.shared.fetchTextures(name: playerTextureName,
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
    var arrowType: ArrowType {
        .player
    }
}
