//
//  HudLayer.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 06/06/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

class HudLayer: SKNode, UIGestureRecognizerDelegate{

    //MARK: - Variables
    let pathTopScore = String(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]) + "/topScore.plist"
    
    var lifeLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var topScoreLabel: SKLabelNode!
    
    var textLabel: SKLabelNode!
    
    var score: SKLabelNode!
    var highScore: SKLabelNode!
    
    var size: CGSize!
    
    var pauseButton: SKSpriteNode!
    
    // Menu Pause
    var continueButton: SKSpriteNode!
    var restartButton: SKSpriteNode!
    var menuButton: SKSpriteNode!
    
    var backgroundMenu: SKSpriteNode!
    var blurBackground: SKSpriteNode!
    
    // Menu Initial
    var playButton: SKSpriteNode!
    var creditsButton: SKSpriteNode!
    
    var logoSprite: SKSpriteNode!
    
    // Focus
    var arrayBotoes: [SKSpriteNode] = []
    var currentIndex: Int = 0
    
    var selection: SKSpriteNode!
    
    @objc func swipedRight(sender:UISwipeGestureRecognizer){
        nextFocus()
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        previousFocus()
    }
    
    //MARK: - Init
    init(size: CGSize) {
        super.init()
        
        self.size = size
        
        #if os(tvOS)
        if selection == nil {
            
            let texture = SKTexture(imageNamed: "selection")
            texture.filteringMode = .Nearest
            
            selection = SKSpriteNode(texture: texture, color: UIColor.clearColor(), size: CGSizeZero)
        }
        #endif
        
        createMenuInitial()
        
    }
    
    func added() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = .right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeLeft.direction = .left
        
//        let scene = parent as! GameMountainScene
//        scene.view!.addGestureRecognizer(swipeRight)
//        scene.view!.addGestureRecognizer(swipeLeft)
    }
    
    //MARK: - Coder
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Focus
    func previousFocus() {
        #if os(tvOS)
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = arrayBotoes.count - 1
        }
        
        currentFocus()
        #endif
    }
    
    func currentFocus() {
        #if os(tvOS)
        let button = arrayBotoes[currentIndex]
        
        selection.size = CGSize(width: button.size.width + 20, height: button.size.height + 20)
        selection.zPosition = button.zPosition - 1
        
        let moveAction = SKAction.moveTo(button.position, duration: 0.2)
        
        selection.runAction(moveAction)
        
        if selection.parent == nil {
            addChild(selection)
        }
        #endif
    }
    
    func nextFocus() {
        #if os(tvOS)
        currentIndex += 1
        if currentIndex >= arrayBotoes.count {
            currentIndex = 0
        }
        
        currentFocus()
        #endif
    }
    
    func resetFocus() {
        #if os(tvOS)
        currentIndex = 0
        arrayBotoes = []
        selection.removeFromParent()
        #endif
    }
    
    //MARK: - Menu
    func createMenuGame() {
        
        if scoreLabel == nil {
            scoreLabel = SKLabelNode(fontNamed: "DisposableDroid BB")
            #if os(tvOS)
                scoreLabel.fontSize = 80
            #endif
            scoreLabel.position = CGPoint(x: size.width * 1/2, y: size.height * 9/10)
            scoreLabel.fontColor = UIColor.black
        }
        scoreLabel.text = "0 m"
        
        if scoreLabel.parent == nil {
            addChild(scoreLabel)
        }
        
        let texture = SKTexture(imageNamed: buttonPauseTextureName)
        texture.filteringMode = .nearest
        
        #if os(iOS)
        if pauseButton == nil {
            pauseButton = SKSpriteNode(texture: texture, color: .clear, size: CGSize(width: (size.width * 1/15) * 1.82, height: size.width * 1/15))
            pauseButton.position = CGPoint(x: size.width * 9/10, y: size.height * 9/10)
            pauseButton.name = pauseButtonName
        }
        
        if pauseButton.parent == nil {
            addChild(pauseButton)
        }
        #endif
        
    }
    
    func createMenuInitial() {
        
        var texture: SKTexture!
        
        if logoSprite == nil {
            
            texture = SKTexture(imageNamed: logoTextureName)
            texture.filteringMode = .nearest
            
            logoSprite = SKSpriteNode(texture: texture, color: .clear, size: size)
            logoSprite.position = CGPoint(x: size.width * 1/2, y: size.height * 1/2)
            logoSprite.name = "Sprite Logo"
        }
        
        if self.logoSprite.parent == nil {
            self.addChild(self.logoSprite)
        }
        
        if playButton == nil {
            
            texture = SKTexture(imageNamed: playButtonTextureName)
            texture.filteringMode = .nearest
            
            playButton = SKSpriteNode(texture: texture, color: .clear, size: CGSize(width: (size.width * 1/15) * 2.36, height: size.width * 1/15))
            playButton.position = CGPoint(x: size.width * 4/10, y: size.height * 1.5/10)
            playButton.name = playButtonName
        }
        
        arrayBotoes.append(playButton)
        if self.playButton.parent == nil {
            self.addChild(self.playButton)
        }
        
        if creditsButton == nil {
            
            texture = SKTexture(imageNamed: creditsButtonTextureName)
            texture.filteringMode = .nearest
            
            creditsButton = SKSpriteNode(texture: texture, color: .clear, size: CGSize(width: (size.width * 1/15) * 2.36, height: size.width * 1/15))
            creditsButton.position = CGPoint(x: size.width * 2/10, y: size.height * 1.5/10)
            creditsButton.name = creditsButtonName
        }
        
        arrayBotoes.append(creditsButton)
        if self.creditsButton.parent == nil {
            self.addChild(self.creditsButton)
        }
        
        #if os(tvOS)
        currentFocus()
        #endif
        
    }
    
    func createEndGameMenu() {
        
        var texture: SKTexture!
        
        if blurBackground == nil {
            texture = SKTexture(imageNamed: blurBackgroundTextureName)
            texture.filteringMode = .nearest
            
            blurBackground = SKSpriteNode(texture: texture, color: .clear, size: size)
            blurBackground.position = CGPoint(x: size.width * 1/2, y: size.height * 1/2)
            blurBackground.zPosition = 990
        }
        
        if self.blurBackground.parent == nil {
            self.addChild(self.blurBackground)
        }
        
        if backgroundMenu == nil {
            
            backgroundMenu = SKSpriteNode(texture: nil, color: .clear, size: size)
            backgroundMenu.position = CGPoint(x: size.width * 1/2, y: size.height * 1/2)
            backgroundMenu.zPosition = 1000
        }
        
        if self.backgroundMenu.parent == nil {
            self.addChild(self.backgroundMenu)
        }
        
        var textureArray: [SKTexture] = []
        
        for index in 1...8 {
            texture = SKTexture(imageNamed: "\(backgroundPauseMenuTextureName)\(index)")
            texture.filteringMode = .nearest
            
            textureArray.append(texture)
        }
        
        let animation = SKAction.animate(with: textureArray, timePerFrame: 0.03)
        let block = SKAction.run {
            
            if self.textLabel == nil {
                self.textLabel = SKLabelNode(fontNamed: "DisposableDroid BB")
                self.textLabel.horizontalAlignmentMode = .center
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.textLabel.fontSize = 52
                }
                else {
                    self.textLabel.fontSize = 32
                }
                #if os(tvOS)
                self.textLabel.fontSize = 80
                #endif
                self.textLabel.fontColor = .white
                self.textLabel.position = CGPoint(x: self.size.width * 1/2, y: self.size.height * 8/10)
                self.textLabel.zPosition = self.backgroundMenu.zPosition + 10
            }
            
            self.textLabel.text = "Game Over"
            
            if self.textLabel.parent == nil {
                self.addChild(self.textLabel)
            }
            
            if self.score == nil {
                self.score = SKLabelNode(fontNamed: "DisposableDroid BB")
                self.score.horizontalAlignmentMode = .center
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.score.fontSize = 38
                }
                else {
                    self.score.fontSize = 24
                }
                #if os(tvOS)
                    self.score.fontSize = 65
                #endif
                self.score.fontColor = .white
                self.score.position = CGPoint(x: self.size.width * 1/2, y: self.size.height * 6.5/10)
                self.score.zPosition = self.backgroundMenu.zPosition + 10
            }
            
            self.score.text = "Score: \(Status.sharedInstance.getScore()) m"
            
            if self.score.parent == nil {
                self.addChild(self.score)
            }
            
            if self.topScoreLabel == nil {
                self.topScoreLabel = SKLabelNode(fontNamed: "DisposableDroid BB")
                self.topScoreLabel.horizontalAlignmentMode = .center
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.topScoreLabel.fontSize = 38
                }
                else {
                    self.topScoreLabel.fontSize = 24
                }
                #if os(tvOS)
                    self.topScoreLabel.fontSize = 65
                #endif
                self.topScoreLabel.fontColor = .white
                self.topScoreLabel.position = CGPoint(x: self.size.width * 1/2, y: self.size.height * 6/10)
                self.topScoreLabel.zPosition = self.backgroundMenu.zPosition + 10
            }
            
            self.topScoreLabel.text = "Top Score: \(Status.sharedInstance.getScore()) m"
            
            if self.topScoreLabel.parent == nil {
                self.addChild(self.topScoreLabel)
            }
            
            if self.menuButton == nil {
                texture = SKTexture(imageNamed: buttonMenuTextureName)
                texture.filteringMode = .nearest
                
                self.menuButton = SKSpriteNode(texture: texture, color: .clear, size: CGSize(width: self.size.width * 1/12, height: self.size.width * 1/12))
                self.menuButton.position = CGPoint(x: self.size.width * 5.75/10, y: self.size.height * 4/10)
                self.menuButton.name = restartButtonName
                self.menuButton.zPosition = self.backgroundMenu.zPosition + 10
            }
            self.arrayBotoes.append(self.menuButton)
            if self.menuButton.parent == nil {
                self.addChild(self.menuButton)
            }
            
            if self.restartButton == nil {
                texture = SKTexture(imageNamed: buttonRestartTextureName)
                texture.filteringMode = .nearest
                
                self.restartButton = SKSpriteNode(texture: texture, color: .clear, size: CGSize(width: self.size.width * 1/12, height: self.size.width * 1/12))
                self.restartButton.position = CGPoint(x: self.size.width * 4.25/10, y: self.size.height * 4/10)
                self.restartButton.name = restartButtonName
                self.restartButton.zPosition = self.backgroundMenu.zPosition + 10
            }
            
            self.arrayBotoes.append(self.restartButton)
            if self.restartButton.parent == nil {
                self.addChild(self.restartButton)
            }
        
            #if os(tvOS)
            self.currentFocus()
            #endif
        }
        
        let sequence = SKAction.sequence([animation, block])
        
        backgroundMenu.run(sequence)
        
    }
    
    func createPauseMenu() {

        var texture: SKTexture!
        
        if blurBackground == nil {
            texture = SKTexture(imageNamed: blurBackgroundTextureName)
            texture.filteringMode = .nearest
            
            blurBackground = SKSpriteNode(texture: texture, color: .clear, size: size)
            blurBackground.position = CGPoint(x: size.width * 1/2, y: size.height * 1/2)
            blurBackground.zPosition = 990
        }
        
        if self.blurBackground.parent == nil {
            self.addChild(self.blurBackground)
        }
        
        if backgroundMenu == nil {
            
            backgroundMenu = SKSpriteNode(texture: nil, color: .clear, size: size)
            backgroundMenu.position = CGPoint(x: size.width * 1/2, y: size.height * 1/2)
            backgroundMenu.zPosition = 1000
        }
        
        if self.backgroundMenu.parent == nil {
            self.addChild(self.backgroundMenu)
        }
        
        var textureArray: [SKTexture] = []
        
        for index in 1...8 {
            texture = SKTexture(imageNamed: "\(backgroundPauseMenuTextureName)\(index)")
            texture.filteringMode = .nearest
            
            textureArray.append(texture)
        }
        
        let animation = SKAction.animate(with: textureArray, timePerFrame: 0.03)
        let block = SKAction.run {
            
            if self.textLabel == nil {
                self.textLabel = SKLabelNode(fontNamed: "DisposableDroid BB")
                self.textLabel.horizontalAlignmentMode = .center
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.textLabel.fontSize = 52
                }
                else {
                    self.textLabel.fontSize = 32
                }
                #if os(tvOS)
                self.textLabel.fontSize = 80
                #endif
                self.textLabel.fontColor = .white
                self.textLabel.position = CGPoint(x: self.size.width * 1/2, y: self.size.height * 8/10)
                self.textLabel.zPosition = self.backgroundMenu.zPosition + 10
            }
            
            self.textLabel.text = "Paused"
            
            if self.textLabel.parent == nil {
                self.addChild(self.textLabel)
            }
            
            if self.continueButton == nil {
                texture = SKTexture(imageNamed: buttonContinueTextureName)
                texture.filteringMode = .nearest
                
                self.continueButton = SKSpriteNode(texture: texture, color: .clear, size: CGSize(width: self.size.width * 1/12, height: self.size.width * 1/12))
                self.continueButton.position = CGPoint(x: self.size.width * 1/2, y: self.size.height * 6/10)
                self.continueButton.name = continueButtonName
                self.continueButton.zPosition = self.backgroundMenu.zPosition + 10
            }
            
            self.arrayBotoes.append(self.continueButton)
            if self.continueButton.parent == nil {
                self.addChild(self.continueButton)
            }
            
            if self.menuButton == nil {
                texture = SKTexture(imageNamed: buttonMenuTextureName)
                texture.filteringMode = .nearest
                
                self.menuButton = SKSpriteNode(texture: texture, color: .clear, size: CGSize(width: self.size.width * 1/12, height: self.size.width * 1/12))
                self.menuButton.position = CGPoint(x: self.size.width * 5.75/10, y: self.size.height * 4/10)
                self.menuButton.name = restartButtonName
                self.menuButton.zPosition = self.backgroundMenu.zPosition + 10
            }
            
            self.arrayBotoes.append(self.menuButton)
            if self.menuButton.parent == nil {
                self.addChild(self.menuButton)
            }
            
            if self.restartButton == nil {
                texture = SKTexture(imageNamed: buttonRestartTextureName)
                texture.filteringMode = .nearest
                
                self.restartButton = SKSpriteNode(texture: texture, color: .clear, size: CGSize(width: self.size.width * 1/12, height: self.size.width * 1/12))
                self.restartButton.position = CGPoint(x: self.size.width * 4.25/10, y: self.size.height * 4/10)
                self.restartButton.name = restartButtonName
                self.restartButton.zPosition = self.backgroundMenu.zPosition + 10
            }
            
            self.arrayBotoes.append(self.restartButton)
            if self.restartButton.parent == nil {
                self.addChild(self.restartButton)
            }
            
            #if os(tvOS)
            self.currentFocus()
            #endif
            Status.sharedInstance.statusJogo = .onPauseMenu
        }
        
        let sequence = SKAction.sequence([animation, block])
        
        backgroundMenu.run(sequence)
    
    }
    
    func createCreditsMenu() {
        
        var texture: SKTexture!
        
        if blurBackground == nil {
            texture = SKTexture(imageNamed: blurBackgroundTextureName)
            texture.filteringMode = .nearest
            
            blurBackground = SKSpriteNode(texture: texture, color: .clear, size: size)
            blurBackground.position = CGPoint(x: size.width * 1/2, y: size.height * 1/2)
            blurBackground.zPosition = 990
        }
        
        if blurBackground.parent == nil {
            addChild(blurBackground)
        }
        
        if backgroundMenu == nil {
            
            backgroundMenu = SKSpriteNode(texture: nil, color: .clear, size: size)
            backgroundMenu.position = CGPoint(x: size.width * 1/2, y: size.height * 1/2)
            backgroundMenu.zPosition = 1000
        }
        
        if backgroundMenu.parent == nil {
            addChild(backgroundMenu)
        }
        
        var textureArray: [SKTexture] = []
        
        for index in 1...8 {
            texture = SKTexture(imageNamed: "\(backgroundCreditsMenuTextureName)\(index)")
            texture.filteringMode = .nearest
            
            textureArray.append(texture)
        }
        
        let animation = SKAction.animate(with: textureArray, timePerFrame: 0.03)
        
        backgroundMenu.run(animation)
        
    }
    
    //MARK: - Remove
    func removeMenuGame() {
        scoreLabel.removeFromParent()
        #if os(iOS)
        pauseButton.removeFromParent()
        #endif
    }
    
    func removeMenuEndGame() {
        blurBackground.removeFromParent()
        backgroundMenu.removeFromParent()
        restartButton.removeFromParent()
        menuButton.removeFromParent()
        textLabel.removeFromParent()
        score.removeFromParent()
        topScoreLabel.removeFromParent()
    }
    
    func removeMenuPause() {
        blurBackground.removeFromParent()
        backgroundMenu.removeFromParent()
        continueButton.removeFromParent()
        restartButton.removeFromParent()
        menuButton.removeFromParent()
        textLabel.removeFromParent()
    }
    
    func removeMenuCredits() {
        blurBackground.removeFromParent()
        backgroundMenu.removeFromParent()
    }
    
    func removeMenuInitial() {
        creditsButton.removeFromParent()
        playButton.removeFromParent()
        logoSprite.removeFromParent()
    }
    
    //MARK: - Game States
    func restartGame() {
        
        resetFocus()
        
        if Status.sharedInstance.statusJogo == .onEndGameMenu {
            removeMenuEndGame()
        }
        else {
            removeMenuPause()
        }
    }
    
    func resume() {
        resetFocus()
        removeMenuPause()
    }
    
    func pause() {
        createPauseMenu()
    }
    
    func goToMenu() {
        resetFocus()
        
        if Status.sharedInstance.statusJogo == .onEndGameMenu {
            removeMenuEndGame()
        }
        else {
            removeMenuPause()
        }
        removeMenuGame()
        
        createMenuInitial()
    }
    
    func goToCredits() {
        createCreditsMenu()
    }
    
    func backToMenuInitial() {
        removeMenuCredits()
    }
    
    func startGame() {
        resetFocus()
        
        removeMenuInitial()
        
        createMenuGame()
    }
    
    func endGame() {
        resetFocus()
        
        createEndGameMenu()
    }
    
    //MARK: - Touchs
    func touch(touches: Set<UITouch>, withEvent event: UIEvent?, paused: Bool) -> GameAction {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)
    
            #if os(tvOS)
    
            #elseif os(iOS)
            if Status.sharedInstance.statusJogo == .onGame {
                if (pauseButtonName == scene?.atPoint(location).name) {
                    createPauseMenu()
                    
                    return .pauseTheGame // Retorna um valor para pausar o jogo.
                }
            }
            else if Status.sharedInstance.statusJogo == .onEndGameMenu {
                if(restartButton == scene?.atPoint(location)) {
                    
                    return .restartGame // Retorna um valor para reiniciar o jogo.
                }
                else if(menuButton == scene?.atPoint(location)) {
                    
                    return .goToMenu // Retorna um valor para voltar para o menu principal do jogo.
                }
            }
            else if Status.sharedInstance.statusJogo == .onPauseMenu {
                if (continueButton == scene?.atPoint(location)) {
                    removeMenuPause()
                    
                    return .resumeTheGame // Retorna um valor para despausar o jogo.
                }
                else if(restartButton == scene?.atPoint(location)) {
                    
                    return .restartGame // Retorna um valor para reiniciar o jogo.
                }
                else if(menuButton == scene?.atPoint(location)) {
                    
                    return .goToMenu // Retorna um valor para voltar para o menu principal do jogo.
                }
            }
            else if Status.sharedInstance.statusJogo == .onCreditsMenu{
                return  .goToInitialMenu
            }
            else if Status.sharedInstance.statusJogo == .onInitialMenu{
                if(playButton == scene?.atPoint(location)) {
                    
                    return .startGame // Retorna um valor para iniciar o jogo.
                }
                else if(creditsButton == scene?.atPoint(location)) {
                    
                    return .goToCredits // Retorna um valor para inicia o menu de creditos
                }
            }
            #endif
        }
        
        return .nothing
    }
    //MARK: - Presses
    func press(presses: Set<UIPress>, withEvent event: UIPressesEvent?) -> GameAction {
        for press in presses {
            if Status.sharedInstance.statusJogo == .onInitialMenu {
                if press.type == .menu {
                    return .quitGame
                }
                else if press.type == .select {
                    let button = arrayBotoes[currentIndex]
                    
                    if button == playButton {
                        return .startGame
                    }
                    else if button == creditsButton {
                        return .goToCredits
                    }
                }
                else if press.type == .rightArrow {
                    nextFocus()
                }
                else if press.type == .leftArrow {
                    previousFocus()
                }
            }
            else if Status.sharedInstance.statusJogo == .onGame {
                if press.type == .menu {
                    return .pauseTheGame
                }
            }
            else if Status.sharedInstance.statusJogo == .onPauseMenu {
                if press.type == .menu {
                    return .resumeTheGame
                }
                else if press.type == .select {
                    let button = arrayBotoes[currentIndex]
                    
                    if button == continueButton {
                        return .resumeTheGame
                    }
                    else if button == restartButton {
                        return .restartGame
                    }
                    else if button == menuButton {
                        return .goToMenu
                    }
                }
                else if press.type == .rightArrow {
                    nextFocus()
                }
                else if press.type == .leftArrow {
                    previousFocus()
                }
            }
            else if Status.sharedInstance.statusJogo == .onEndGameMenu {
                if press.type == .menu {
                    return .goToMenu
                }
                else if press.type == .select {
                    let button = arrayBotoes[currentIndex]
                    
                    if button == restartButton {
                        return .restartGame
                    }
                    else if button == menuButton {
                        return .goToMenu
                    }
                }
                else if press.type == .rightArrow {
                    nextFocus()
                }
                else if press.type == .leftArrow {
                    previousFocus()
                }
            }
            else if Status.sharedInstance.statusJogo == .onCreditsMenu {
                if press.type == .menu {
                    return .goToInitialMenu
                }
                else if press.type == .select {
                    return .goToInitialMenu
                }
            }
        }
        
        return .nothing
    }
    
}
