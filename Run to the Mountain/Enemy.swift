//
//  Enemy.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 19/05/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {

    var sceneSize: CGSize!
    
    #if os(iOS)
    var enemyVelocity = CGVector(dx: -80, dy: 0)
    #elseif os(tvOS)
    var enemyVelocity = CGVector(dx: -140, dy: 0)
    #endif
    
    var life = 10
    
    var attackDamage = 10
    
    var onPlayer = false
    
    var cavalo: SKSpriteNode!
    var person: SKSpriteNode!
    
    var physicsSize: CGSize!
    
    var textures: [String: [SKTexture]]!
    
    //MARK: - Init
    init(texture: SKTexture?, color: UIColor, size: CGSize, sceneSize: CGSize, mass: CGFloat, textures: [String: [SKTexture]]) {
        super.init(texture: texture, color: color, size: CGSize(width: size.width * 2, height: size.height * 2))
        
        self.sceneSize = sceneSize
        
        self.textures = textures
        
        physicsSize = size
        
        zPosition = playerZposition
        
        name = enemyName
        
//        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width, height: size.height * 8/10))
        physicsBody = SKPhysicsBody(circleOfRadius: physicsSize.width * 1/2, center: CGPoint(x: 0, y: -physicsSize.height * 1/4))
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = mass
        physicsBody?.allowsRotation = false
        
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        physicsBody?.collisionBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.playerArrow | PhysicsCategory.player
        
        physicsBody?.dynamic = true
        
        createHorse()
        createPerson()
        spawPosition()
        
    }
    
    //MARK: - Damage
    func damage(hitDamage: Int) -> Int{
        
        life -= hitDamage
        
        if life <= 0 {
            
            selfDestruction()
            return 1
        }
        
        return 0
            
    }
    
    func selfDestruction() {
        
        removeFromParent()
        
    }
    
    func attack(player: Player) {
        
        player.reciveDamage(self.attackDamage)
        
    }
    
    //MARK: - Create
    func createHorse() {
        
        cavalo = SKSpriteNode(texture: nil, color: UIColor.clearColor(), size: CGSize(width: size.width, height: size.height))
        cavalo.position = CGPoint(x: 0, y: 0)
        cavalo.zPosition = playerZposition
        
        let animate = SKAction.animateWithTextures(textures[horseTextureName]!, timePerFrame: 0.025)
        
        let forever = SKAction.repeatActionForever(animate)
        
        self.addChild(cavalo)
        
        cavalo.runAction(forever)
        
    }
    
    func createPerson() {
        
        
        
    }
    
    //MARK: - Search For The Player
    func searchPlayer() {
        
        if !paused {
            if !onPlayer {
                physicsBody?.velocity = enemyVelocity
            }
            else {
                physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }
            
            cavalo.physicsBody?.velocity = (physicsBody?.velocity)!
        }
        
    }
    
    //MARK: - Spaw Position
    func spawPosition() {
        
        
        let position = CGPoint(x: sceneSize.width + size.width * 1/8, y: sceneSize.height * 1/3)
        
        self.position = position
        
    }
    
    //MARK: - Update
    func update() {
        
        searchPlayer()
        
    }
    
    //MARK: - Coder
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
