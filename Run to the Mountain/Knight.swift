//
//  Knight.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 23/05/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

class Knight: Enemy {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize, sceneSize: CGSize, mass: CGFloat, textures: [String: [SKTexture]]) {
        super.init(texture: texture, color: color, size: size, sceneSize: sceneSize, mass: mass, textures: textures)
        
        name = knightName
        
        #if os(iOS)
        enemyVelocity = CGVector(dx: -120, dy: 0)
        #elseif os(tvOS)
        enemyVelocity = CGVector(dx: -200, dy: 0)
        #endif
        
        life = 20
    }
    
    //MARK: - Create
    override func createPerson() {
        
        person = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: size.width, height: size.height))
        person.position = CGPoint(x: 0, y: 0)
        person.zPosition = playerZposition + 50
        
        let animate = SKAction.animate(with: textures[knightTextureName]!, timePerFrame: 0.025)
        
        let forever = SKAction.repeatForever(animate)
        
        self.addChild(person)
        
        person.run(forever)
        
    }
    
    //MARK: - Attack
    override func attack(player: Player) {
        super.attack(player: player)
        
        attackedPlayer()
    }
    
    func attackedPlayer() {
        onPlayer = true
        
        let wait = SKAction.wait(forDuration: 3)
        let block = SKAction.run {
            
            self.onPlayer = false
            
        }
        
        let sequence = SKAction.sequence([wait, block])
        
        run(sequence)
    }
        
    //MARK: - Search For The Player
    override func searchPlayer() {
        
        if !isPaused {
            if !onPlayer {
                physicsBody?.velocity = enemyVelocity
            }
            else {
                physicsBody?.velocity = CGVector(dx: -enemyVelocity.dx * 6/10, dy: 0)
            }
            
            cavalo.physicsBody?.velocity = (physicsBody?.velocity)!
        }
        
    }
   
    //MARK: - Coder
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
