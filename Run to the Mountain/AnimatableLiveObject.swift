//
//  AnimatableLiveObject.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso Kuhn on 20/11/19.
//  Copyright © 2019 Warrior Iena. All rights reserved.
//

import SpriteKit

struct AnimatableTexture {
    let zPosition: CGFloat
    let textures: [SKTexture]
}

class AnimatableLiveObject: LiveObject {
    // MARK: - Variables
    private let textures: [AnimatableTexture]
    
    // MARK: - Life Cycle
    init(size: CGSize, physicsBody: SKPhysicsBody, totalLife: Float, life: Float, attack: Float, attackSpeed: Float, movimentSpeed: CGVector, mass: CGFloat, affectedByGravity: Bool, allowsRotation: Bool, isDynamic: Bool, textures: [AnimatableTexture]) {
        self.textures = textures
        super.init(texture: nil,
                   size: size,
                   physicsBody: physicsBody,
                   totalLife: totalLife,
                   life: life,
                   attack: attack,
                   attackSpeed: attackSpeed,
                   movimentSpeed: movimentSpeed,
                   mass: mass,
                   affectedByGravity: affectedByGravity,
                   allowsRotation: allowsRotation,
                   isDynamic: isDynamic)
    }
    
    // MARK: - Animation
    private func animateTextures(_ textures: [AnimatableTexture]) {
        for texture in textures {
            let skin = SKSpriteNode(texture: nil, color: .clear, size: size)
            skin.zPosition = texture.zPosition
            
            let animationAction = SKAction.animate(with: texture.textures, timePerFrame: 0.025)
            let foreverAction = SKAction.repeatForever(animationAction)
            
            self.addChild(skin)
            skin.run(foreverAction)
        }
    }
    
    static func createTextures(name: String, range: ClosedRange<Int>) -> [SKTexture] {
        var textures: [SKTexture] = []
        
        for index in range {
            let texture = SKTexture(imageNamed: name + "\(index)")
            texture.filteringMode = .nearest
            textures.append(texture)
        }
        return textures
    }
}
