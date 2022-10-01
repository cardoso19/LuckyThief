//
//  TextureCache.swift
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

final class TextureCache {

    // MARK: - Variables
    static let shared = TextureCache()
    private var animationCache: [String: AnimationTextures]
    private var textureCache: [String: SKTexture]
    
    // MARK: - Init
    private init() {
        animationCache = [:]
        textureCache = [:]
    }

    // MARK: - Fetcher
    func fetchTexture(name: String) -> SKTexture {
        let texture = SKTexture(imageNamed: name)
        texture.filteringMode = .nearest
        textureCache[name] = texture
        return texture
    }

    func fetchTextures(name: String, numberOfFrames: Int, zPosition: CGFloat) -> AnimationTextures {
        if let animationTextures = animationCache[name] {
            return animationTextures
        } else {
            let animationTextures = AnimationTextures(zPosition: zPosition,
                                                      textures: createTextures(name: name, range: 0...numberOfFrames))
            animationCache[name] = animationTextures
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
