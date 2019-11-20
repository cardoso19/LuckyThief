//
//  Arrow.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 01/06/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

class Arrow: SKSpriteNode {

    //MARK: - Variavies
    var ativa: Bool = true
    
    var damage: Int = 0
    
    var textureOnGround: SKTexture!
    
    //MARK: - Init
    init(texture: SKTexture?, color: UIColor, size: CGSize, char: Int) {
        super.init(texture: texture, color: color, size: size)
        
        textureOnGround = SKTexture(imageNamed: arrowGroundTextureName)
        textureOnGround.filteringMode = .nearest
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
     
        selfDestruction()
        
        if char == CharType.Player {
            playerArrow()
        }
        else if char == CharType.Enemy {
            enemyArrow()
        }
        physicsBody?.contactTestBitMask = PhysicsCategory.ground
        
        name = arrowName
        
    }
    
    //MARK: - Launcher
    func enemyArrow() {
        physicsBody?.categoryBitMask = PhysicsCategory.enemyArrow
        physicsBody?.collisionBitMask = PhysicsCategory.playerArrow
        
        damage = enemyArrowDamage
    }
    
    func playerArrow() {
        physicsBody?.categoryBitMask = PhysicsCategory.playerArrow
        physicsBody?.collisionBitMask = PhysicsCategory.enemyArrow
        
        damage = playerArrowDamage
    }
    
    //MARK: - Ground Contact
    func groundContact() {
        
        texture = textureOnGround
        
        ativa = false
        
        physicsBody?.isDynamic = false
        
        let xVel = Status.sharedInstance.velocidadeChao
        
        name = arrowDesativadaName
        
        let move = SKAction.move(by: CGVector(dx: xVel, dy: 0), duration: 1.0)
        let forever = SKAction.repeatForever(move)
        
        removeAllActions()
        run(forever)
        selfDestruction()
        
    }
    
    //MARK: - Sel Destruction
    func selfDestruction() {
        
        let wait = SKAction.wait(forDuration: 5)
        
        let block = SKAction.run {
            self.removeFromParent()
        }
        
        let sequence = SKAction.sequence([wait, block])
        run(sequence)
        
    }
    
    //MARK: - Coder
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Collidable
extension Arrow: Collidable {
    func collisionWith(object: Collidable, collisionType: UInt32) {
        
    }
}
