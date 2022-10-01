//
//  Knight.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 23/05/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

final class Knight: LiveObject {
    // MARK: - Variables
#if os(iOS)
    private let movementSpeed = CGVector(dx: -120, dy: 0)
#elseif os(tvOS)
    private let movementSpeed = CGVector(dx: -200, dy: 0)
#endif
    private var onPlayer = false
    
    // MARK: - Init
    init(size: CGSize, life: Int, attack: Int) {
        let horseTextures = TextureCache.shared.fetchTextures(name: horseTextureName,
                                                              numberOfFrames: 14,
                                                              zPosition: playerZposition)
        let knightTextures = TextureCache.shared.fetchTextures(name: knightTextureName,
                                                               numberOfFrames: 14,
                                                               zPosition: playerZposition + 50)
        super.init(textures: [horseTextures, knightTextures],
                   size: size,
                   life: life,
                   attack: attack,
                   mass: 100000,
                   affectedByGravity: false,
                   allowsRotation: false,
                   isDynamic: true)
        configPhysics()
        generalConfigs()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configPhysics() {
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        physicsBody?.collisionBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.playerArrow | PhysicsCategory.player
    }

    private func generalConfigs() {
        name = knightName
        zPosition = playerZposition
    }
    
    //MARK: - Attack
    func attackedPlayer() {
        onPlayer = true
        
        let wait = SKAction.wait(forDuration: 3)
        let block = SKAction.run {
            self.onPlayer = false
        }
        
        let sequence = SKAction.sequence([wait, block])
        run(sequence)
    }

    override func theObjectIsDead() {
        Status.shared.removeOneEnemy()
        super.theObjectIsDead()
    }
}

// MARK: - Collidable
extension Knight: Collidable {
    func collisionWith(object: Collidable, collisionType: UInt32) {
        guard let aliveObject = object as? Alive else { return }
        aliveObject.remove(lifePoints: attack)
        attackedPlayer()
    }
}

// MARK: - Enemy
extension Knight: Enemy {
    func searchForPlayer() {
        guard !isPaused else {
            return
        }
        let velocity: CGVector
        if !onPlayer {
            velocity = movementSpeed
        } else {
            velocity = CGVector(dx: -movementSpeed.dx * 6/10, dy: 0)
        }
        physicsBody?.velocity = velocity
    }
}
