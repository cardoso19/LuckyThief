//
//  Player.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 16/05/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var life = 100
    
    var lifeLabel: SKLabelNode!
    
    var cavalo: SKSpriteNode!
    var person: SKSpriteNode!
    
    var arrowTexture: SKTexture!
    
    var physicsSize: CGSize!
    
    var textures: [String: [SKTexture]]!
    
    //MARK: - Init
    init(texture: SKTexture?, color: UIColor, size: CGSize, mass: CGFloat, textures: [String: [SKTexture]]) {
        super.init(texture: texture, color: color, size: CGSize(width: size.width * 2, height: size.height * 2))
        
        self.textures = textures
        
        physicsSize = size
        
        arrowTexture = SKTexture(imageNamed: arrowTextureName)
        arrowTexture.filteringMode = .Nearest
        
        name = playerName
        
        zPosition = playerZposition
        
//        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width, height: size.height * 8/10))
        physicsBody = SKPhysicsBody(circleOfRadius: physicsSize.width * 1/2, center: CGPoint(x: 0, y: -physicsSize.height * 1/4))
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = mass
        
        physicsBody?.categoryBitMask = PhysicsCategory.player
        physicsBody?.collisionBitMask = PhysicsCategory.none
        physicsBody?.contactTestBitMask = PhysicsCategory.enemyArrow
        
        physicsBody?.allowsRotation = false
        physicsBody?.dynamic = false
        
        createHorse()
        createPerson()
        
        lifeConstructor()
        
    }
    
    //MARK: - Life Label
    func lifeConstructor() {
        
        lifeLabel = SKLabelNode(fontNamed: "DisposableDroid BB")
        lifeLabel.text = "100%"
        lifeLabel.horizontalAlignmentMode = .Center
        lifeLabel.fontSize = 12
        #if os(tvOS)
        lifeLabel.fontSize = 40
        #endif
        lifeLabel.fontColor = UIColor.whiteColor()
        lifeLabel.position = CGPoint(x: 0, y: physicsSize.height * 1/2)
        lifeLabel.zPosition = zPosition + 1
        
        addChild(lifeLabel)
        
    }
    
    //MARK: - Damage
    func reciveDamage(hitDamage: Int) {
        
        life -= hitDamage
        
        if life < 0 {
            lifeLabel.text = "0%"
        }
        else {
            lifeLabel.text = "\(life)%"
        }
        
        print("Player Life: \(life)")
        
        Status.sharedInstance.updateLifeOnHud(life)
        
    }
    
    //MARK: - Shoot
    func shoot(velocity: CGVector) {
        
        if let gameLayer = self.parent {
            
            let arrow = Arrow(texture: arrowTexture, color: UIColor.clearColor(), size: CGSize(width: physicsSize.width * 1/10, height: physicsSize.height * 1/2), char: CharType.Player)
            arrow.position = CGPoint(x: self.position.x, y: self.position.y)
            
            gameLayer.addChild(arrow)
            
            arrow.physicsBody?.applyImpulse(velocity)
            arrow.zRotation = atan2(velocity.dy, velocity.dx) + CGFloat(M_PI_2)
            
        }
        
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
        
        person = SKSpriteNode(texture: nil, color: UIColor.clearColor(), size: CGSize(width: size.width, height: size.height))
        person.position = CGPoint(x: 0, y: 0)
        person.zPosition = playerZposition + 50
        
        let animate = SKAction.animateWithTextures(textures[playerTextureName]!, timePerFrame: 0.025)
        
        let forever = SKAction.repeatActionForever(animate)
        
        self.addChild(person)
        
        person.runAction(forever)
        
    }
    
    //MARK: - Coder
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
