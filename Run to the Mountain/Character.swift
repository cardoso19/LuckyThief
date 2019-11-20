//
//  Character.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso Kuhn on 20/11/19.
//  Copyright © 2019 Warrior Iena. All rights reserved.
//

import SpriteKit

class Character: AnimatableLiveObject {
    
    // MARK: - Life Cycle
    init(size: CGSize, totalLife: Float, life: Float, attack: Float, attackSpeed: Float, movimentSpeed: CGVector, mass: CGFloat, textures: [AnimatableTexture]) {
        
        let physicsBody = SKPhysicsBody(circleOfRadius: size.width * 1/2,
                                        center: CGPoint(x: 0, y: -size.height * 1/4))
        let fixedSize = CGSize(width: size.width * 2, height: size.height * 2)
        
        super.init(size: fixedSize,
                   physicsBody: physicsBody,
                   totalLife: totalLife,
                   life: life,
                   attack: attack,
                   attackSpeed: attackSpeed,
                   movimentSpeed: movimentSpeed,
                   mass: mass,
                   affectedByGravity: false,
                   allowsRotation: false,
                   isDynamic: false,
                   textures: textures)
    }
    
    // MARK: - Texture
    static func createHorseTextures() -> [SKTexture] {
        var horseTextures: [SKTexture] = []
        
        for index in 0...14 {
            let texture = SKTexture(imageNamed: horseTextureName + "\(index)")
            texture.filteringMode = .nearest
            horseTextures.append(texture)
        }
        return horseTextures
    }
}
