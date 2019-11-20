//
//  GameScene.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 16/05/16.
//  Copyright (c) 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

class GameMountainScene: SKScene {
    
    //MARK: - Variables
    var gameLayerNode: GameLayer!
    var hudLayerNode: HudLayer!
    var backgroundLayerNode: BackgroundLayer!
    
    //MARK: - Game Stats
    func restartTheGame() {
        Status.shared.gamePaused = false
        gameLayerNode.isPaused = !gameLayerNode.isPaused
        backgroundLayerNode.isPaused = !backgroundLayerNode.isPaused
        physicsWorld.speed = 1.0
        
        Status.shared.restartGame()
        
        backgroundLayerNode.restartGame()
        hudLayerNode.restartGame()
        gameLayerNode.restartGame()
        
    }
    
    func startGame() {
        gameLayerNode.startGame()
        hudLayerNode.startGame()
        backgroundLayerNode.startGame()
    }
    
    func pauseGame() {
        gameLayerNode.isPaused = !gameLayerNode.isPaused
        backgroundLayerNode.isPaused = !backgroundLayerNode.isPaused
        physicsWorld.speed = (gameLayerNode.isPaused == true ? 0.0 : 1.0)
        
        if gameLayerNode.isPaused {
            Status.shared.gamePaused = true
            hudLayerNode.pause()
        }
        else {
            Status.shared.gamePaused = false
            hudLayerNode.resume()
        }
    }
    
    func endGame() {
        Status.shared.gamePaused = false
        gameLayerNode.isPaused = !gameLayerNode.isPaused
        backgroundLayerNode.isPaused = !backgroundLayerNode.isPaused
        physicsWorld.speed = (gameLayerNode.isPaused == true ? 0.0 : 1.0)
        
        hudLayerNode.endGame()
    }
    
    func goToMenu() {
        Status.shared.gamePaused = false
        physicsWorld.speed = 1.0
        gameLayerNode.isPaused = !gameLayerNode.isPaused
        backgroundLayerNode.isPaused = !backgroundLayerNode.isPaused
        
        Status.shared.restartGame()
        
        backgroundLayerNode.goToMenu()
        gameLayerNode.goToMenu()
        hudLayerNode.goToMenu()
    }
    
    func goToCredits() {
        hudLayerNode.goToCredits()
    }
    
    func backToMenuInitial() {
        hudLayerNode.backToMenuInitial()
    }
    
    //MARK: - Game Verification
    @discardableResult
    func gameActionReceptor(action: GameAction) -> Int {
        if(action == .resumeTheGame) {
            Status.shared.statusJogo = .transition
            pauseGame()
            Status.shared.statusJogo = .onGame
        }
        else if(action == .pauseTheGame) {
            Status.shared.statusJogo = .transition
            pauseGame()
        }
        else if(action == .restartGame) {
            restartTheGame()
            Status.shared.statusJogo = .onGame
        }
        else if(action == .endGame) {
            endGame()
            Status.shared.statusJogo = .onEndGameMenu
        }
        else if(action == .startGame) {
            startGame()
            Status.shared.statusJogo = .onGame
        }
        else if(action == .goToMenu) {
            goToMenu()
            Status.shared.statusJogo = .onInitialMenu
        }
        else if(action == .goToCredits) {
            
            goToCredits()
            Status.shared.statusJogo = .onCreditsMenu
        }
        else if(action == .goToInitialMenu) {
            backToMenuInitial()
            Status.shared.statusJogo = .onInitialMenu
        }
        else if(action == .quitGame) {
            return 1
        }
        return 0
    }
    
    //MARK: - Life Cycle
    override func didMove(to view: SKView) {
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x: size.width * 1/2, y: size.height * 1/2)
        camera.xScale = 0.25
        camera.yScale = 0.25
        
        self.camera = camera
        
        physicsWorld.contactDelegate = self
        #if os(iOS)
        view.isMultipleTouchEnabled = false
        view.isExclusiveTouch = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            physicsWorld.gravity = CGVector(dx: 0, dy: -15)
        }
            
        #elseif os(tvOS)
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        #endif
        
        Status.shared.gamescene = self
        
        backgroundLayerNode = BackgroundLayer(size: self.size)
        Status.shared.backgroundLayerNode = backgroundLayerNode
        addChild(backgroundLayerNode)
        
        hudLayerNode = HudLayer(size: self.size)
        Status.shared.hudLayerNode = hudLayerNode
        addChild(hudLayerNode)
        
        hudLayerNode.added()
        
        gameLayerNode = GameLayer(size: self.size)
        Status.shared.gameLayerNode = gameLayerNode
        addChild(gameLayerNode)
        
    }
    
    //MARK: - Touchs
    #if os(tvOS)
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        let action = hudLayerNode.press(presses, withEvent: event)
        
        let num = gameActionReceptor(action)
        if num == 1 {
            super.pressesBegan(presses, withEvent: event)
        }
    }
    #endif
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
    
        #if os(iOS)
        let action = hudLayerNode.touch(touches: touches, withEvent: event, paused: gameLayerNode.isPaused)
            
        gameActionReceptor(action: action)
            
        #endif
        if Status.shared.statusJogo == .onGame {
            gameLayerNode.touchesBegan(touches, with: event)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if Status.shared.statusJogo == .onGame {
            gameLayerNode.touchesEnded(touches, with: event)
        }
        
    }
   
   //MARK: - Update
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if Status.shared.gamePaused == true {
            gameLayerNode.isPaused = true
            backgroundLayerNode.isPaused = true
        }
        
        gameLayerNode.update(currentTime: currentTime)
        
        backgroundLayerNode.update(currentTime: currentTime)
        
    }
    
    
}

// MARK: - SKPhysicsContactDelegate
extension GameMountainScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        gameLayerNode.didBegin(contact)
    }
}
