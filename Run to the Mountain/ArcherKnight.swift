//
//  ArcherKnight.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 23/05/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

class ArcherKnight: Enemy {

    var arrowTexture: SKTexture!
    var shooting = false
    
    var velocity: CGVector!
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize, sceneSize: CGSize, mass: CGFloat, textures: [String: [SKTexture]]) {
        super.init(texture: texture, color: color, size: size, sceneSize: sceneSize, mass: mass, textures: textures)

        life = 10
        
        let playerPosition = CGPoint(x: size.width * 1/8, y: size.height / 3)
        let archerFinalPosition = CGPoint(x: sceneSize.width * 3/4, y: size.height / 3)
        
        let xFinal = playerPosition.x - archerFinalPosition.x
        
        velocity = CGVector(dx: xFinal, dy: 0)
        
        arrowTexture = SKTexture(imageNamed: arrowTextureName)
        arrowTexture.filteringMode = .Nearest
        
        name = archerKnightName
        
        physicsBody?.contactTestBitMask = PhysicsCategory.playerArrow
        
    }
    
    //MARK: - Search For The Player
    override func searchPlayer() {
        
        if !paused {
            if position.x >= sceneSize.width * 3/4 {
                physicsBody?.velocity = enemyVelocity
            }
            else {
                physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                
                if !shooting {
                    
                    shooting = true
                    
                    let wait = SKAction.waitForDuration(1)
                    
                    let perform = SKAction.performSelector(#selector(shoot), onTarget: self)
                    
                    let sequence = SKAction.sequence([wait, perform])
                    
                    let forever = SKAction.repeatActionForever(sequence)
                    
                    runAction(forever)
                    
                }
                
            }
            
            cavalo.physicsBody?.velocity = (physicsBody?.velocity)!
        }
        
    }
    
    //MARK: - Shoot
    func shoot() {
        
        let arrow = Arrow(texture: arrowTexture, color: UIColor.clearColor(), size: CGSize(width: physicsSize.width * 1/10, height: physicsSize.height * 1/2), char: CharType.Enemy)
        arrow.position = CGPoint(x: self.position.x, y: self.position.y)
        
        let gameLayer = self.parent
        
        gameLayer!.addChild(arrow)
        
        #if os(iOS)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            arrow.physicsBody?.applyImpulse(CGVector(dx: -32.5, dy: 32.5))
        }
        else {
            arrow.physicsBody?.applyImpulse(CGVector(dx: -5, dy: 5))
        }
        arrow.zRotation = atan2(velocity.dy, velocity.dx) + CGFloat(M_PI_2)
        #elseif os(tvOS)
        arrow.physicsBody?.applyImpulse(CGVector(dx: -100, dy: 100))
        arrow.zRotation = atan2(velocity.dy, velocity.dx) + CGFloat(M_PI_2)
        #endif
    }
    
    //MARK: - Create
    override func createPerson() {
        
        person = SKSpriteNode(texture: nil, color: UIColor.clearColor(), size: CGSize(width: size.width, height: size.height))
        person.position = CGPoint(x: 0, y: 0)
        person.zPosition = playerZposition + 50
        
        let animate = SKAction.animateWithTextures(textures[archerKnightTextureName]!, timePerFrame: 0.025)
        
        let forever = SKAction.repeatActionForever(animate)
        
        self.addChild(person)
        
        person.runAction(forever)
        
    }
    
    //MARK: - Coder
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
