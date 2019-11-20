//
//  LiveObject.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso Kuhn on 20/11/19.
//  Copyright © 2019 Warrior Iena. All rights reserved.
//

import SpriteKit

class LiveObject: SKSpriteNode {
    
    // MARK: - Variable
    private var totalLife: Float
    private var life: Float
    private var attack: Float
    private var attackSpeed: Float
    private var movimentSpeed: CGVector
    
    // MARK: - Life Cycle
    init(texture: SKTexture?, size: CGSize, physicsBody: SKPhysicsBody, totalLife: Float, life: Float, attack: Float, attackSpeed: Float, movimentSpeed: CGVector, mass: CGFloat, affectedByGravity: Bool, allowsRotation: Bool, isDynamic: Bool) {
        self.totalLife = totalLife
        self.life = life
        self.attack = attack
        self.attackSpeed = attackSpeed
        self.movimentSpeed = movimentSpeed
        super.init(texture: texture, color: .clear, size: size)
        definePhysicsBody(physicsBody)
        configPhysicsBody(mass: mass,
                          affectedByGravity: affectedByGravity,
                          allowsRotation: allowsRotation,
                          isDynamic: isDynamic)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Physics
    private func definePhysicsBody(_ physicsBody: SKPhysicsBody) {
        self.physicsBody = physicsBody
    }
    
    private func configPhysicsBody(mass: CGFloat, affectedByGravity: Bool, allowsRotation: Bool, isDynamic: Bool) {
        physicsBody?.affectedByGravity = affectedByGravity
        physicsBody?.mass = mass
        
        physicsBody?.allowsRotation = allowsRotation
        physicsBody?.isDynamic = isDynamic
    }
    
    // MARK: - Definitions
    public func receiveLifePoints(_ lifePoints: Float) {
        life += lifePoints
    }
    
    public func receiveAttackPoints(_ attackPoints: Float) {
        attack += attackPoints
    }
    
    public func receiveMovimentSpeedPoints(_ movimentSpeedPoints: CGVector) {
        movimentSpeed.dx += movimentSpeedPoints.dx
        movimentSpeed.dy += movimentSpeedPoints.dy
    }
    
    public func receiveAttackSpeedPoints(_ attackSpeedPoints: Float) {
        attackSpeed += attackSpeedPoints
    }
}
