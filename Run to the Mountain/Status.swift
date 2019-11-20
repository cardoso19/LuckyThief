//
//  Status.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 06/06/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import Foundation
import SpriteKit

class Status {
    static let sharedInstance = Status()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    //MARK: - Variables
    private var enemiesAlive = 0
    private var waveCount = 1
    private var score = 0
    
    var gameLayerNode: GameLayer!
    var hudLayerNode: HudLayer!
    var backgroundLayerNode: BackgroundLayer!
    
    var velocidadeChao: CGFloat = 0.0
    
    var statusJogo: GameState = .onInitialMenu
    var gamePaused: Bool = false
    
    var gamescene: GameMountainScene!
    
    //MARK: - Score
    func addScore(addScore: Int) {
        
        score += addScore
        hudLayerNode.scoreLabel.text = "\(score) m"
        
    }
    
    func startScoring() -> SKAction{
        
        let wait = SKAction.wait(forDuration: 0.25)
        
        let block = SKAction.run { 
            
            self.addScore(addScore: 1)
            
        }
        
        let sequence = SKAction.sequence([wait, block])
        
        let forever = SKAction.repeatForever(sequence)
        
        return forever
        
    }
    
    func stopScoring() {
        
        gameLayerNode.removeAction(forKey: actionScoreName)
        
    }
    
    func resetScore() {
        
        score = 0
        hudLayerNode.scoreLabel.text = "\(score) m"
        
    }
    
    func getScore() -> Int {
        return score
    }
    
    //MARK: - Wave Count
    func currentWave() -> Int {
        
        return waveCount
        
    }
        
    func increaseWaveCount() {
        
        waveCount += 1
        
    }
    
    func resetWaveCount() {
        
        waveCount = 1
        
    }
    
    //MARK: - Enemies Alive
    func currentEnemiesAlive() -> Int {
        
        return enemiesAlive
        
    }
    
    func setEnemiesAlive(createdEnemies: Int) {
        
        enemiesAlive = createdEnemies
        
    }
    
    func decreaseEnemiesAlive(enemiesDead: Int) -> Int {
        
        enemiesAlive -= enemiesDead
        
        return enemiesAlive
        
    }
    
    func resetEnemiesAlive() {
        
        enemiesAlive = 0
        
    }
    
    //MARK: - Life
    func updateLifeOnHud(currentLife: Int) {
        
        if currentLife <= 0 {
            
            gamescene.gameActionReceptor(action: .endGame)
            
        }
        
    }
    
    //MARK: - Restart
    func restartGame() {
        
        resetScore()
        resetWaveCount()
        resetEnemiesAlive()
        
    }
    
}
