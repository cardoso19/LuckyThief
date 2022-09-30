//
//  AnimationCache.swift
//  LuckyThief
//
//  Created by Matheus Cardoso Kuhn on 30.09.22.
//  Copyright © 2022 Warrior Iena. All rights reserved.
//

import SpriteKit

struct AnimationTextures {
    let zPosition: CGFloat
    let textures: [SKTexture]
}

final class AnimationCache {

    // MARK: - Variables
    static let shared = AnimationCache()
    private var cache: [String: AnimationTextures]
    
    // MARK: - Init
    private init() {
        cache = [:]
    }

    // MARK: - Animation
    func fetchTextures(name: String, numberOfFrames: Int, zPosition: CGFloat) -> AnimationTextures {
        if let animationTextures = cache[name] {
            return animationTextures
        } else {
            let animationTextures = AnimationTextures(zPosition: zPosition,
                                                      textures: createTextures(name: name, range: 0...numberOfFrames))
            cache[name] = animationTextures
            return animationTextures
        }
    }

    private func createTextures(name: String, range: ClosedRange<Int>) -> [SKTexture] {
        var textures: [SKTexture] = []
        range.forEach { index in
            let texture = SKTexture(imageNamed: name + "\(index)")
            texture.filteringMode = .nearest
            textures.append(texture)
        }
        return textures
    }
}
