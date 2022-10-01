//
//  GameLayer.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 06/06/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

final class GameLayer: SKNode {

    //MARK: - Variables
    private var touchStartPoint: CGPoint?
    private var player: Player!
    private let size: CGSize
    private var objSize: CGSize
    private lazy var spawnPosition = CGPoint(x: size.width + objSize.width * 1/8, y: size.height * 1/3)
    private var enemies: [Enemy] = []
    
    //MARK: - Init
    init(size: CGSize) {
        self.size = size
        self.objSize = CGSize(width: size.height * 1/3, height: size.height * 1/3)
        super.init()
        ArrowPool.shared.createArrows(size: CGSize(width: objSize.width / 15, height: objSize.height / 4))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Game States
    func startGame() {
        createPlayer()
        createEnemyWave()
        addChild(GroundNode(screenSize: size))
        
        let actionScoring = Status.shared.startScoring()
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
    }
    
    // MARK: - Collision
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        guard let collidableA = contact.bodyA.node as? Collidable,
              let collidableB = contact.bodyB.node as? Collidable else {
                return
        }
        collidableA.collisionWith(object: collidableB, collisionType: collision)
        collidableB.collisionWith(object: collidableA, collisionType: collision)
    }
    
    //MARK: - Creator
    func createPlayer() {
        let player = Player(size: objSize, life: 100, attack: playerArrowDamage)
        player.position = CGPoint(x: size.width * 1/8, y: size.height * 1/3)
        self.player = player
        addChild(player)
    }
    
    func createKnight() -> Knight {
        let knight = Knight(size: objSize, life: 20, attack: 10)
        knight.position = spawnPosition
        return knight
    }
    
    func createArcherKnight() -> ArcherKnight {
        let archerKnight = ArcherKnight(size: objSize, life: 10, attack: 15, sceneWidth: size.width)
        archerKnight.position = spawnPosition
        return archerKnight
    }
    
    @objc func createEnemyWave() {
        enemies = []
        let waveCount = Status.shared.currentWave()
        let knightCount = Int(waveCount * 2/3) + Int(round(2/3))
        let archerKnightCount = Int(waveCount * 1/3) + Int(round(1/3))
        
        let wait = SKAction.wait(forDuration: 0.25)
        let createKnightAction = SKAction.run {
            let knight = self.createKnight()
            self.enemies.append(knight)
            self.addChild(knight)
        }
        let sequenceKnight = SKAction.sequence([wait, createKnightAction])
        let repeatCountKnight = SKAction.repeat(sequenceKnight, count: knightCount)
        
        if archerKnightCount > 0 {
            let createArcherKnightAction = SKAction.run {
                let archerKnight = self.createArcherKnight()
                self.enemies.append(archerKnight)
                self.addChild(archerKnight)
            }
            let sequenceArcherKnight = SKAction.sequence([wait, createArcherKnightAction])
            let repeatCountArcherKnight = SKAction.repeat(sequenceArcherKnight, count: archerKnightCount)
            let sequenceFinal = SKAction.sequence([repeatCountKnight, repeatCountArcherKnight])
            run(sequenceFinal)
        } else {
            run(repeatCountKnight)
        }
        
        Status.shared.setEnemiesAlive(createdEnemies: knightCount + archerKnightCount)
        Status.shared.increaseWaveCount()
        print("Enemies Alive: \(Status.shared.currentEnemiesAlive())")
        print("Wave: \(Status.shared.currentWave())")
    }
    
    //MARK: - Touchs
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard Status.shared.statusJogo == .onGame, let firstTouch = touches.first else {
            return
        }
        touchStartPoint = firstTouch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard Status.shared.statusJogo == .onGame && player != nil,
                let firstTouch = touches.first, let touchStartPoint = touchStartPoint else {
            return
        }
#if os(iOS)
            let divisorX: CGFloat
            let divisorY: CGFloat
            if UIDevice.current.userInterfaceIdiom == .pad {
                divisorX = 10
                divisorY = 10
            } else {
                divisorX = 25
                divisorY = 25
            }
#elseif os(tvOS)
            let divisorX: CGFloat = 8
            let divisorY: CGFloat = 6
#endif

            let location = firstTouch.location(in: self)

            let xVel = (touchStartPoint.x - location.x) / divisorX
            let yVel = (touchStartPoint.y - location.y) / divisorY

            let velocity = CGVector(dx: xVel, dy: yVel)

            player.shootArrow(with: velocity)
    }
    
    //MARK: - Update
    func update(currentTime: CFTimeInterval) {
        guard Status.shared.statusJogo == .onGame else {
            return
        }
        enemies.forEach { enemy in
            enemy.searchForPlayer()
        }

        ArrowPool.shared.firedArrows.keys.forEach { arrow in
            arrow.updateRotation()
        }
    }
}
