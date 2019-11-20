//
//  Player.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 16/05/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

class Player: Character {
    
    // MARK: - Variables
    private var lifeLabel: SKLabelNode!
    
    //MARK: - Init
    init(size: CGSize, totalLife: Float, life: Float, attack: Float, attackSpeed: Float, movimentSpeed: CGVector) {
        let horseTextures = AnimatableLiveObject.createTextures(name: horseTextureName, range: 0...14)
        let playerTextures = AnimatableLiveObject.createTextures(name: playerTextureName, range: 0...14)
        let animatableTextures = [AnimatableTexture(zPosition: playerZposition,
                                                    textures: horseTextures),
                                  AnimatableTexture(zPosition: playerZposition + 50,
                                                    textures: playerTextures)]
        super.init(size: size,
                   totalLife: totalLife,
                   life: life,
                   attack: attack,
                   attackSpeed: attackSpeed,
                   movimentSpeed: movimentSpeed,
                   mass: 0,
                   textures: animatableTextures)
        generalConfigs()
        configPhysics()
        setLifeLabel(visible: true)
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
    func collisionWith(object: Collidable, collisionType: UInt32) {
        if collisionType == PhysicsCategory.player | PhysicsCategory.enemy {
            let enemy = object as? Enemy
            let attackDamage: Float = Float(enemy?.attackDamage ?? 0)
            
            receiveLifePoints(-attackDamage)
        }
    }
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
                          color: .clear,
                          size: CGSize(width: size.width / 2, height: size.height / 2),
                          char: CharType.Player)
        arrow.position = CGPoint(x: self.position.x, y: self.position.y)
        
        gameLayer.addChild(arrow)
        
        arrow.physicsBody?.applyImpulse(velocity)
        arrow.zRotation = atan2(velocity.dy, velocity.dx) + CGFloat(Double.pi/2)
    }
}
