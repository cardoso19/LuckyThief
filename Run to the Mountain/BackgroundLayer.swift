//
//  BackgroundLayer.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 06/06/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

class BackgroundLayer: SKNode {

    //MARK: - Variables
    var size: CGSize!
    
    var velocityFront: CGFloat = 0
    var velocityNv: CGFloat = 0
    var velocityArvore: CGFloat = 0
    var velocityMontanha: CGFloat = 0
    
    var layers: [ParallaxNode] = []
    
    //MARK: - Init
    init(size: CGSize) {
        super.init()
        
        self.size = size
        
        velocityFront = 400
        // 90
        velocityNv = 35
        // 80
        velocityArvore = 30
        // 40
        velocityMontanha = 10
        #if os(tvOS)
            velocityFront *= 2
            velocityNv *= 2
            velocityArvore *= 2
            velocityMontanha *= 2
        #endif
        
        Status.sharedInstance.velocidadeChao = velocityFront
        
        goToMenu()
        
    }
    
    //MARK: - Coder
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Game Stats
    func startGame() {
        
        startMoviment()
        
    }
    
    func restartGame() {
        
        removeAllChildren()
        
        createParallax()
        
        startMoviment()
        
    }
    
    func goToMenu() {
        removeAllChildren()
        
        createParallax()
    }
    
    func startMoviment() {
        
        for obj in layers {
            obj.startVelocity()
        }
        
    }
    
    //MARK: - Parallax
    func createParallax() {
        
        layers = []
        
        var chaoTextureName = parallaxTextureNameChao
        var casteloTextureName = parallaxTextureNameCastelo
        var arbustoTextureName = parallaxTextureNameArbusto
        var chaoArvoresTextureName = parallaxTextureNameChaoArvores
        var arvoresTextureName = parallaxTextureNameArvores
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            chaoTextureName += iPadAppendName
            casteloTextureName += iPadAppendName
            arbustoTextureName += iPadAppendName
            chaoArvoresTextureName += iPadAppendName
            arvoresTextureName += iPadAppendName
        }
        
        let sizeNode = CGSize(width: (size.height * 1/4) * 0.8888888889, height: size.height * 1/4)
        let positionNode = CGPoint(x: size.width, y: 0)
        
        let chao = ParallaxNode(texture: nil, color: .clear, texturesSize: sizeNode, numNodes: 12, zPosition: parallaxZpositionChao, initialPosition: positionNode, velocity: velocityFront, isParallax: true, screenSize: size, textureName: chaoTextureName)
        chao.name = "Chao"
        
        layers.append(chao)
        addChild(chao)
        
        var texture = SKTexture(imageNamed: casteloTextureName)
        texture.filteringMode = .nearest
        
        let castelo = ParallaxNode(texture: texture, color: .clear, texturesSize: size, numNodes: 1, zPosition: parallaxZpositionCastelo, initialPosition: CGPoint.zero, velocity: velocityArvore - 5, isParallax: false, screenSize: size, textureName: "")
        castelo.name = "Castelo"
        
        layers.append(castelo)
        addChild(castelo)
        
        texture = SKTexture(imageNamed: arbustoTextureName)
        texture.filteringMode = .nearest
        
        let arbusto = ParallaxNode(texture: texture, color: .clear, texturesSize: size, numNodes: 1, zPosition: parallaxZpositionArbusto, initialPosition: positionNode, velocity: velocityFront, isParallax: true, screenSize: size, textureName: arbustoTextureName)
        arbusto.name = "Arbusto"
        
        layers.append(arbusto)
        addChild(arbusto)
        
        texture = SKTexture(imageNamed: chaoArvoresTextureName)
        texture.filteringMode = .nearest
        
        let chaoArvores = ParallaxNode(texture: texture, color: .clear, texturesSize: size, numNodes: 1, zPosition: parallaxZpositionArvores - 10, initialPosition: CGPoint.zero, velocity: 0.0, isParallax: false, screenSize: size, textureName: chaoArvoresTextureName)
        chaoArvores.name = "Chao Arvores"
        
        addChild(chaoArvores)
        
        createArvores()

        createNuvens()
        
        createMontanhas()
        
        texture = SKTexture(imageNamed: parallaxTextureNameCeu)
        texture.filteringMode = .nearest
        
        let ceu = ParallaxNode(texture: texture, color: .clear, texturesSize: size, numNodes: 1, zPosition: parallaxZpositionCeu, initialPosition: CGPoint.zero, velocity: 0.0, isParallax: false, screenSize: size, textureName: parallaxTextureNameCeu)
        ceu.name = "Ceu"
        
        addChild(ceu)
    }
    
    //MARK: - Parallax Creates
    func createArvores() {
        
        var arvVelocity = velocityArvore
        var texture: SKTexture!
        
        for index in 0...2 {
            
            texture = SKTexture(imageNamed: "\(parallaxTextureNameArvores)\(index)")
            texture.filteringMode = .nearest
            
            let arvore = ParallaxNode(texture: texture, color: .clear, texturesSize: size, numNodes: 1, zPosition: parallaxZpositionArvores - CGFloat(index), initialPosition: CGPoint.zero, velocity: arvVelocity, isParallax: true, screenSize: size, textureName: parallaxTextureNameArvores)
            arvore.name = "Arvore \(index)"
            
            #if os(iOS)
            arvVelocity -= 1
            #elseif os(tvOS)
            arvVelocity -= 2
            #endif
            
            layers.append(arvore)
            addChild(arvore)
        }
        
    }
    
    func createMontanhas() {
        
        let montanhasTextureName = parallaxTextureNameMontanha
        
        var monVelocity = velocityMontanha
        var texture: SKTexture!
        
        for index in 0...2 {
            
            texture = SKTexture(imageNamed: "\(montanhasTextureName)\(index)")
            texture.filteringMode = .nearest
            
            let montanha = ParallaxNode(texture: texture, color: .clear, texturesSize: size, numNodes: 1, zPosition: parallaxZpositionMontanhas - CGFloat(index), initialPosition: CGPoint.zero, velocity: monVelocity, isParallax: true, screenSize: size, textureName: parallaxTextureNameArvores)
            montanha.name = "Montanha \(index)"
            
            layers.append(montanha)
            addChild(montanha)
            
            #if os(iOS)
                //15-30
            monVelocity -= 5
            #elseif os(tvOS)
            monVelocity -= 10
            #endif
        }
        
    }
 
    func createNuvens() {
        
        var numVelocity = velocityNv
        var texture: SKTexture!
        
        let multiplier = size.height * 1/16
        
        let textureSize = CGSize(width: multiplier * 3, height: multiplier)
        let width = size.width
        let height = size.height * 5/8
        
        for index in 0...1  {
            
            let x = CGFloat(arc4random() % UInt32(width)) - (width * 1/2)
            let y = CGFloat(arc4random() % UInt32(height * 1/3)) + height
            
            let position = CGPoint(x: x, y: y)
            
            texture = SKTexture(imageNamed: "\(parallaxTextureNameNuvens)0")
            texture.filteringMode = .nearest
            
            let nuvem = ParallaxNode(texture: texture, color: .clear, texturesSize: textureSize, numNodes: 1, zPosition: parallaxZpositionNuvens + CGFloat(index), initialPosition: position, velocity: numVelocity, isParallax: true, screenSize: size, textureName: parallaxTextureNameNuvens)
            nuvem.name = "Nuvem \(index)"
            
            #if os(iOS)
                // 2.5-5
                numVelocity += 1
            #elseif os(tvOS)
                numVelocity += 2
            #endif
            
            addChild(nuvem)
            nuvem.startVelocity()
        }
        
    }
    
    //MARK: - Update
    func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
}
