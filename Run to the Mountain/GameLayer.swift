//
//  GameLayer.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 06/06/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

class GameLayer: SKNode {

    //MARK: - Variables
    var firstPress: CGPoint?
    
    var player: Player!
    
    var objSize: CGSize!
    
    var ground: SKSpriteNode!
    
    var horseTextures: [SKTexture]!
    var knightTextures: [SKTexture]!
    var archerKnightTextures: [SKTexture]!
    var playerTextures: [SKTexture]!
    
    var size: CGSize!
    
    //MARK: - Init
    init(size: CGSize) {
        super.init()
        
        self.size = size
        
        objSize = CGSize(width: size.height * 1/6, height: size.height * 1/6)
        
        createInitialCenary()
        
    }
    
    //MARK: - Coder
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Initial Menu
    func createInitialCenary() {
        loadAllTextures()
    }
    
    //MARK: - Game Stats
    func startGame() {
        
        createPlayer()
        createEnemyWave()
        createGround()
        
        let actionScoring = Status.sharedInstance.startScoring()
        run(actionScoring, withKey: actionScoreName)
        
    }
    
    func restartGame() {
        removeAllChildren()
        removeAllActions()
        
        startGame()
    }
    
    func goToMenu() {
        removeAllChildren()
        removeAllActions()
        
        createInitialCenary()
    }
    
    //MARK:- Collision
    func didBeginContact(contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let collision = contact.bodyA.categoryBitMask |
            contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.player | PhysicsCategory.enemy {
            
            var inimigo: Enemy!
            
            if bodyA.node?.name == knightName {
                
                inimigo = bodyA.node as! Enemy
                
            }
            else if bodyB.node?.name == knightName {
                
                inimigo = bodyB.node as! Enemy
                
            }
            
            if inimigo != nil {
                inimigo.attack(player: player)
            }
            
        } else if collision == PhysicsCategory.enemy | PhysicsCategory.playerArrow {
            
            var inimigo: Enemy!
            var flecha: Arrow!
            
            if bodyA.node?.name == arrowName {
                if bodyB.node != nil {
                    inimigo = bodyB.node as! Enemy
                }
                if bodyA.node != nil {
                    flecha = bodyA.node as! Arrow
                }
            }
            else if  bodyB.node?.name == arrowName {
                if bodyA.node != nil {
                    inimigo = bodyA.node as! Enemy
                }
                if bodyB.node != nil {
                    flecha = bodyB.node as! Arrow
                }
            }
            
            if inimigo != nil {
                
                if flecha.ativa {
                    
                    flecha.ativa = false
                    
                    let vivo = inimigo.damage(hitDamage: flecha.damage)
                    
                    if vivo == 1 {
                        
                        let enemiesAlive = Status.sharedInstance.decreaseEnemiesAlive(enemiesDead: 1)
                        
                        if enemiesAlive == 0 {
                            let wait = SKAction.wait(forDuration: 1)
                            
                            let perform = SKAction.perform(#selector(createEnemyWave), onTarget: self)
                            
                            let sequence = SKAction.sequence([wait, perform])
                            
                            run(sequence)
                        }
                        
                    }
                    
                }
                
            }
            
            if flecha != nil {
                flecha.removeFromParent()
            }
            
        }
        else if collision == PhysicsCategory.player | PhysicsCategory.enemyArrow {
            
            var flecha: Arrow!
            
            if bodyA.node?.name == arrowName {
                flecha = bodyA.node as! Arrow
            }
            else {
                flecha = bodyB.node as! Arrow
            }
            
            if flecha.ativa {
                
                flecha.ativa = false
                
                player.reciveDamage(hitDamage: flecha.damage)
                
                flecha.removeFromParent()
            }
            
        }
        else if collision == PhysicsCategory.playerArrow | PhysicsCategory.ground || collision == PhysicsCategory.enemyArrow | PhysicsCategory.ground {
            
            var flecha: Arrow!
            
            if bodyA.node?.name == arrowName {
                flecha = bodyA.node as! Arrow
            }
            else if bodyB.node?.name == arrowName {
                flecha = bodyB.node as! Arrow
            }
            
            if flecha != nil {
                flecha.groundContact()
            }
            
        }
        
    }
    
    //MARK: - Creates
    func createPlayer() {
        
        let jogador = Player(texture: nil, color: .clear, size: objSize, mass: 0,textures: [horseTextureName: horseTextures, playerTextureName: playerTextures])
        jogador.position = CGPoint(x: size.width * 1/8, y: size.height * 1/3)
        
        player = jogador
        
        addChild(jogador)
        
    }
    
    func createKnight() {
        
        let inimigo = Knight(texture: nil, color: .clear, size: objSize, sceneSize: size, mass: 100000,textures: [horseTextureName: horseTextures, knightTextureName: knightTextures])
        
        
        addChild(inimigo)
        
    }
    
    func createArcherKnight() {
        
        let inimigo = ArcherKnight(texture: nil, color: .clear, size: objSize, sceneSize: size, mass: 100000, textures: [horseTextureName: horseTextures, archerKnightTextureName: archerKnightTextures])
        
        addChild(inimigo)
        
    }
    
    func createGround() {
        
        ground = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: size.width * 2, height: size.height * 1/8))
        ground.position = CGPoint(x: 0, y: ground.size.height * 1/2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        
        ground.physicsBody?.affectedByGravity = false
        
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.none
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.playerArrow | PhysicsCategory.player
        
        addChild(ground)
        
        
    }
    
    func createEnemyWave() {
        
        let waveCount = Status.sharedInstance.currentWave()
        
        let knightCount = Int(waveCount * 2/3) + Int(round(2/3))
        
        let archerKnightCount = Int(waveCount * 1/3) + Int(round(1/3))
        
        let wait = SKAction.wait(forDuration: 0.25)
        
        let performK = SKAction.perform(#selector(createKnight), onTarget: self)
        
        let sequenceK = SKAction.sequence([wait, performK])
        
        let repeatCountK = SKAction.repeat(sequenceK, count: knightCount)
        
        if archerKnightCount > 0 {
            let performAK = SKAction.perform(#selector(createArcherKnight), onTarget: self)
            
            let sequenceAK = SKAction.sequence([wait, performAK])
            
            let repeatCountAK = SKAction.repeat(sequenceAK, count: archerKnightCount)
            
            let sequenceFinal = SKAction.sequence([repeatCountK, repeatCountAK])
            
            run(sequenceFinal)
        }
        else {
            run(repeatCountK)
        }
        
        Status.sharedInstance.setEnemiesAlive(createdEnemies: knightCount + archerKnightCount)
        
        print("Enemies Created: \(knightCount + archerKnightCount)")
        print("Enemies Alive: \(Status.sharedInstance.currentEnemiesAlive())")
        
        Status.sharedInstance.increaseWaveCount()
        
    }
    
    //MARK: - Load Textures
    func loadAllTextures() {
        
        loadHorseTexture()
        
        loadKnightTexture()
        
        loadArcherKnightTexture()
        
        loadPlayerTexture()
        
    }
    
    func loadHorseTexture() {
        
        horseTextures = []
        
        for index in 0...14 {
            
            let texture = SKTexture(imageNamed: horseTextureName + "\(index)")
            texture.filteringMode = .nearest
            
            horseTextures.append(texture)
            
        }
        
    }
    
    func loadKnightTexture() {
        
        knightTextures = []
        
        for index in 0...14 {
            
            let texture = SKTexture(imageNamed: knightTextureName + "\(index)")
            texture.filteringMode = .nearest
            
            knightTextures.append(texture)
            
        }
        
    }
    
    func loadArcherKnightTexture() {
        
        archerKnightTextures = []
        
        for index in 0...14 {
            
            let texture = SKTexture(imageNamed: archerKnightTextureName + "\(index)")
            texture.filteringMode = .nearest
            
            archerKnightTextures.append(texture)
            
        }
        
    }
    
    func loadPlayerTexture() {
        
        playerTextures = []
        
        for index in 0...14 {
            
            let texture = SKTexture(imageNamed: playerTextureName + "\(index)")
            texture.filteringMode = .nearest
            
            playerTextures.append(texture)
            
        }
        
    }
    
    //MARK: - Touchs
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)

            if Status.sharedInstance.statusJogo == GameState.OnGame {
                firstPress = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if Status.sharedInstance.statusJogo == GameState.OnGame {
            for touch in touches {
                if firstPress != nil && player != nil {
                    #if os(iOS)
                        
                        var divisor: CGFloat = 0
                        
                    if UIDevice.current.userInterfaceIdiom == .pad {
                            divisor = 12
                        }
                        else {
                            divisor = 25
                        }
                        
                    let location = touch.location(in: self)
                        
                        let xVel = (firstPress!.x - location.x) / divisor
                        let yVel = (firstPress!.y - location.y) / divisor
                        
                        let velocity = CGVector(dx: xVel, dy: yVel)
                        
                    player.shoot(velocity: velocity)
                        
                    #elseif os(tvOS)
                        
                        let location = touch.locationInNode(self)
                        
                        let xVel = (firstPress!.x - location.x) / 8
                        let yVel = (firstPress!.y - location.y) / 6
                        
                        let velocity = CGVector(dx: xVel, dy: yVel)
                        
                        player.shoot(velocity)
                        
                    #endif
                    
                    firstPress = nil
                }
            }
        }
        
    }
    
    //MARK: - Update
    func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if Status.sharedInstance.statusJogo == GameState.OnGame {
            enumerateChildNodes(withName: knightName) { (node, _) in
                
                let inimigo = node as! Knight
                inimigo.update()
                
            }
            
            enumerateChildNodes(withName: archerKnightName) { (node, _) in
                
                let inimigo = node as! ArcherKnight
                inimigo.update()
                
            }
            
            enumerateChildNodes(withName: arrowName) { (node, _) in
                
                let angle = atan2(node.physicsBody!.velocity.dy, node.physicsBody!.velocity.dx) + CGFloat(Double.pi/2)
                node.zRotation = angle
                
            }
        }
        
    }
    
}
