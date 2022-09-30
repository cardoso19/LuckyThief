//
//  ArcherKnight.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 23/05/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import UIKit
import SpriteKit

final class ArcherKnight: LiveObject {

    // MARK: - Variables
    var sceneWidth: CGFloat
    var shooting = false
#if os(iOS)
    var movementSpeed = CGVector(dx: -80, dy: 0)
#elseif os(tvOS)
    var movementSpeed = CGVector(dx: -140, dy: 0)
#endif

#if os(iOS)
//if UIDevice.current.userInterfaceIdiom == .pad {
//    private let arrowImpulseVector = CGVector(dx: -32.5, dy: 32.5)
//} else {
    private let arrowImpulseVector = CGVector(dx: -10, dy: 10)
//}
#elseif os(tvOS)
    private let arrowImpulseVector = CGVector(dx: -100, dy: 100)
#endif

    // MARK: - Init
    init(size: CGSize, life: Int, attack: Int, sceneWidth: CGFloat) {
        let horseTextures = AnimationCache.shared.fetchTextures(name: horseTextureName,
                                                                numberOfFrames: 14,
                                                                zPosition: playerZposition)
        let knightTextures = AnimationCache.shared.fetchTextures(name: archerKnightTextureName,
                                                                 numberOfFrames: 14,
                                                                 zPosition: playerZposition + 50)
        self.sceneWidth = sceneWidth
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
        name = archerKnightName
        zPosition = playerZposition
    }

    override func theObjectIsDead() {
        Status.shared.removeOneEnemy()
        super.theObjectIsDead()
    }
}

// MARK: - ArcherAbility
extension ArcherKnight: ArcherAbility {
    var arrowTexture: SKTexture {
        let texture = SKTexture(imageNamed: arrowTextureName)
        texture.filteringMode = .nearest
        return texture
    }

    func shootArrow(with velocity: CGVector) {
        guard let gameLayer = self.parent else { return }

        let arrow = Arrow(texture: arrowTexture,
                          size: CGSize(width: size.width / 15, height: size.height / 4),
                          damage: enemyArrowDamage)
        arrow.position = CGPoint(x: self.position.x, y: self.position.y)

        arrow.physicsBody?.categoryBitMask = PhysicsCategory.enemyArrow
        arrow.physicsBody?.collisionBitMask = PhysicsCategory.playerArrow
        arrow.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.ground

        gameLayer.addChild(arrow)

        arrow.physicsBody?.applyImpulse(velocity)
        arrow.zRotation = atan2(velocity.dy, velocity.dx) + CGFloat(Double.pi/2)
    }
}

// MARK: - Enemy
extension ArcherKnight: Enemy {
    func searchForPlayer() {
        guard !isPaused else {
            return
        }
        if position.x >= sceneWidth * 3/4 {
            physicsBody?.velocity = movementSpeed
        } else {
            guard !shooting else {
                return
            }
            shooting = true
            physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            let wait = SKAction.wait(forDuration: 1)
            let shootAction = SKAction.run {
                self.shootArrow(with: self.arrowImpulseVector)
            }
            let sequence = SKAction.sequence([wait, shootAction])
            let forever = SKAction.repeatForever(sequence)
            run(forever)
        }
    }
}
