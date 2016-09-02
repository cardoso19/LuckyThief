//
//  ParallaxNode.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 30/05/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import SpriteKit

class ParallaxNode: SKSpriteNode {
    
    var numNodes: Int!
    
    var fila: [SKSpriteNode] = []
    
    var velocity: CGFloat!
    
    var isParallax = true
    
    var screenSize: CGSize!
    var textureSize: CGSize!
    
    var initialPosition: CGPoint!
    
    var arrayTextures: [SKTexture] = []
    var textureName: String!
    
    init(texture: SKTexture?, color: UIColor, texturesSize: CGSize, numNodes: Int, zPosition: CGFloat,  initialPosition: CGPoint, velocity: CGFloat, isParallax: Bool, screenSize: CGSize, textureName: String) {
        
        self.velocity = velocity
        
        self.isParallax = isParallax
        
        self.screenSize = screenSize
        
        self.initialPosition = initialPosition
        
        self.textureSize = texturesSize
        
        self.textureName = textureName
        
        self.numNodes = numNodes - 1
        
        super.init(texture: nil, color: UIColor.clearColor(), size: screenSize)
        
        position = CGPointZero
        
        loadTexture()
        
        if isParallax {
            if numNodes > 1 {
                for index in 0...self.numNodes {
                    let parallaxNode = SKSpriteNode(texture: arrayTextures[index], color: UIColor.clearColor(), size: texturesSize)
                    
                    parallaxNode.anchorPoint = CGPointZero
                    
                    if index != 0 {
                        let passado = fila[index - 1]
                        
                        parallaxNode.position = CGPoint(x: passado.position.x - texturesSize.width, y: initialPosition.y)
                    }
                    else {
                        parallaxNode.position = initialPosition
                    }
                    
                    parallaxNode.name = "\(index)"
                    
                    fila.append(parallaxNode)
                    addChild(parallaxNode)
                    
                }
            }
            else {
                for index in 0...3 {
                    
                    let parallaxNode = SKSpriteNode(texture: texture, color: UIColor.clearColor(), size: texturesSize)
                    
                    parallaxNode.anchorPoint = CGPointZero
                    
                    if index != 0 {
                        let passado = fila[index - 1]
                        
                        parallaxNode.position = CGPoint(x: passado.position.x - screenSize.width, y: initialPosition.y)
                    }
                    else {
                        parallaxNode.position = initialPosition
                    }
                    
                    parallaxNode.name = "\(index)"
                    
                    fila.append(parallaxNode)
                    addChild(parallaxNode)
                    
                }
            }
        }
        else {
            let parallaxNode = SKSpriteNode(texture: texture, color: UIColor.clearColor(), size: texturesSize)
            
            parallaxNode.anchorPoint = CGPointZero
            
            parallaxNode.position = initialPosition
            
            parallaxNode.name = "Not Parallax"
            
//            fila.append(parallaxNode)
            addChild(parallaxNode)
        }
        
        
        self.zPosition = zPosition
        
        anchorPoint = CGPointZero
        
        if velocity > 0 {
            let perform = SKAction.performSelector(#selector(update), onTarget: self)
            let wait = SKAction.waitForDuration(0.1)
            
            let sequence = SKAction.sequence([perform, wait])
            
            let forever = SKAction.repeatActionForever(sequence)
            
            runAction(forever)
        }
        
    }
    
    func loadTexture() {
        if numNodes > 1 {
            for index in 0...numNodes {
                let texture = SKTexture(imageNamed: "\(textureName)\(index)")
                texture.filteringMode = .Nearest
                arrayTextures.append(texture)
            }
        }
    }
    
    func getPilha() -> [SKSpriteNode]{
        let primeiro = fila[0]
        let ultimo = fila[fila.count - 1]
        
        return [primeiro, ultimo]
    }
    
    func ordenaPilha() {
        
        let primeiro = fila[0]
        
        for (index, _) in fila.enumerate() {
            if (index + 1) != fila.count {
                fila[index] = fila[index + 1]
            }
        }
        fila[fila.count - 1] = primeiro
        
        if numNodes > 1 {
            let num = Int(arc4random() % UInt32(numNodes))
            
            fila[fila.count - 1].texture = arrayTextures[num]
        }
    }
    
    func startVelocity() {
        
        if isParallax {
            
            let move = SKAction.moveBy(CGVector(dx: velocity, dy: 0), duration: 1.0)
            let forever = SKAction.repeatActionForever(move)
            
            for node in fila {
                node.runAction(forever)
            }
        }
        else if velocity > 0{
            let move = SKAction.moveBy(CGVector(dx: velocity, dy: 0), duration: 1.0)
            let notForever = SKAction.repeatActionForever(move)
            
            runAction(notForever)
        }
    }
    
    func stopVelocity() {
        
        removeAllActions()
        if isParallax {
            for node in fila {
                node.removeAllActions()
            }
        }
    }
    
    func selfDestruction() {
        removeAllActions()
        removeFromParent()
    }
    
    func update() {
        
        if isParallax {
            let nodes = getPilha()
            
            let primeiro = nodes[0]
            let ultimo = nodes[1]
            
            if numNodes > 1 {
                if primeiro.position.x >= screenSize.width {
                    ordenaPilha()
                    primeiro.position.x = -textureSize.width + ultimo.position.x + 2
                }
            }
            else {
                if primeiro.position.x >= screenSize.width {
                    ordenaPilha()
                    primeiro.position.x = -screenSize.width + ultimo.position.x + 2
                }
            }
        }
        else if velocity > 0 {
            if position.x >= size.width {
                selfDestruction()
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
