//
//  Arrow.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 01/06/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

enum ArrowType {
    case player
    case enemy
}

final class Arrow: SKSpriteNode {

    //MARK: - Variables
    private var damage: Int = 0
    private(set) var isActive: Bool = true
    
    //MARK: - Init
    init(size: CGSize) {
        let arrowTexture = TextureCache.shared.fetchTexture(name: arrowTextureName)
        super.init(texture: arrowTexture, color: .clear, size: size)
        configPhysics(size: size)
        setupDefault()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configPhysics(size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
        physicsBody?.contactTestBitMask = PhysicsCategory.ground
    }
    
    // MARK: - State
    func setType(_ type: ArrowType, damage: Int) {
        setupDefault()
        self.damage = damage
        setCollisionType(type)
    }

    func prepareForShooting(impulse: CGVector) {
        setRemoverTimer()
        zRotation = CGFloat.calculateZRotation(impulse: impulse)
        physicsBody?.applyImpulse(impulse)
    }

    func updateRotation() {
        guard isActive, let physicsBody = physicsBody else {
            return
        }
        zRotation = CGFloat.calculateZRotation(impulse: physicsBody.velocity)
    }

    private func setCollisionType(_ type: ArrowType) {
        switch type {
        case .player:
            physicsBody?.categoryBitMask = PhysicsCategory.playerArrow
            physicsBody?.collisionBitMask = PhysicsCategory.enemyArrow
            physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.ground
        case .enemy:
            physicsBody?.categoryBitMask = PhysicsCategory.enemyArrow
            physicsBody?.collisionBitMask = PhysicsCategory.playerArrow
            physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.ground
        }
    }

    private func setupDefault() {
        isActive = true
        physicsBody?.isDynamic = true
        name = arrowName
        texture = TextureCache.shared.fetchTexture(name: arrowTextureName)
        removeAllActions()
    }

    private func setupToGroundContact() {
        isActive = false
        physicsBody?.isDynamic = false
        name = arrowDesativadaName
        texture = TextureCache.shared.fetchTexture(name: arrowGroundTextureName)
        let xVel = Status.shared.velocidadeChao
        let move = SKAction.move(by: CGVector(dx: xVel, dy: 0), duration: 1.0)
        let forever = SKAction.repeatForever(move)
        removeAllActions()
        run(forever)
        setRemoverTimer()
    }

    func setRemoverTimer() {
        let wait = SKAction.wait(forDuration: 5)
        let block = SKAction.run {
            self.removeFromParent()
            ArrowPool.shared.putArrowBack(arrow: self)
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
            setupToGroundContact()
        } else if let aliveObject = object as? Alive {
            aliveObject.remove(lifePoints: damage)
            removeFromParent()
            ArrowPool.shared.putArrowBack(arrow: self)
        }
    }
}
