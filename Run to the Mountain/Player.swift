//
//  Player.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 16/05/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

class Player: Character {
    
    var life = 100
    
    var lifeLabel: SKLabelNode!
    
    //MARK: - Init
    init(size: CGSize, totalLife: Float, life: Float, attack: Float, attackSpeed: Float, movimentSpeed: CGVector) {
        let animatableTextures = [AnimatableTexture(zPosition: playerZposition, textures: Character.createHorseTextures()),
                                  AnimatableTexture(zPosition: playerZposition + 50, textures: Player.createPlayerTextures())]
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
        lifeConstructor(originalSize: size)
    }
    
    private static func createPlayerTextures() -> [SKTexture] {
        var playerTextures: [SKTexture] = []
        
        for index in 0...14 {
            let texture = SKTexture(imageNamed: playerTextureName + "\(index)")
            texture.filteringMode = .nearest
            playerTextures.append(texture)
        }
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
    
    // MARK: - Physics
    override
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, mass: CGFloat, textures: [String: [SKTexture]]) {
        super.init(texture: texture, color: color, size: CGSize(width: size.width * 2, height: size.height * 2))
        
        self.textures = textures
        
        physicsSize = size
        
        arrowTexture = SKTexture(imageNamed: arrowTextureName)
        arrowTexture.filteringMode = .nearest
        
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
        physicsBody?.isDynamic = false
        
        createHorse()
        createPerson()
        
        lifeConstructor()
        
    }
    
    //MARK: - Life Label
    func lifeConstructor(originalSize: CGSize) {
        
        lifeLabel = SKLabelNode(fontNamed: "DisposableDroid BB")
        lifeLabel.text = "100%"
        lifeLabel.horizontalAlignmentMode = .center
        lifeLabel.fontSize = 12
        #if os(tvOS)
        lifeLabel.fontSize = 40
        #endif
        lifeLabel.fontColor = .white
        lifeLabel.position = CGPoint(x: 0, y: originalSize.height * 1/2)
        lifeLabel.zPosition = zPosition + 1
        
        addChild(lifeLabel)
        
    }
    
    //MARK: - Damage
    func receiveDamage(_ damage: Int) {
        
        life -= damage
        
        if life <= 0 {
            lifeLabel.text = "0%"
        }
        else {
            lifeLabel.text = "\(life)%"
        }
        
        print("Player Life: \(life)")
        
        Status.sharedInstance.updateLifeOnHud(currentLife: life)
        
    }
}

// MARK: - Collidable
extension Player: Collidable {
    func collisionWith(object: Collidable, collisionType: UInt32) {
        if collisionType == PhysicsCategory.player | PhysicsCategory.enemy {
            let enemy = object as? Enemy
            let attackDamage: Int = enemy?.attackDamage ?? 0
            
            receiveDamage(attackDamage)
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
    
    func shootArrow(at velocity: CGVector) {
        if let gameLayer = self.parent {
            
            let arrow = Arrow(texture: arrowTexture, color: .clear, size: CGSize(width: size.width / 2, height: size.height / 2), char: CharType.Player)
            arrow.position = CGPoint(x: self.position.x, y: self.position.y)
            
            gameLayer.addChild(arrow)
            
            arrow.physicsBody?.applyImpulse(velocity)
            arrow.zRotation = atan2(velocity.dy, velocity.dx) + CGFloat(Double.pi/2)
        }
    }
}
