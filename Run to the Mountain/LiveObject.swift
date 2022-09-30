//
//  LiveObject.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso Kuhn on 20/11/19.
//  Copyright © 2019 Warrior Iena. All rights reserved.
//

import SpriteKit

open class LiveObject: SKSpriteNode {
    
    // MARK: - Variables
    private(set) var life: Int
    private(set) var attack: Int

    private lazy var lifeLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "DisposableDroid BB")
        label.horizontalAlignmentMode = .center
        label.fontSize = 12
        #if os(tvOS)
        label.fontSize = 40
        #endif
        label.fontColor = .white
        label.position = CGPoint(x: 0, y: size.height * 1/2)
        label.zPosition = zPosition + 1
        return label
    }()
    
    // MARK: - Init
    init(textures: [AnimationTextures], size: CGSize, life: Int, attack: Int, mass: CGFloat, affectedByGravity: Bool, allowsRotation: Bool, isDynamic: Bool) {
        self.life = life
        self.attack = attack
        super.init(texture: nil, color: .clear, size: size)
        configPhysicsBody(mass: mass,
                          affectedByGravity: affectedByGravity,
                          allowsRotation: allowsRotation,
                          isDynamic: isDynamic)
        setupViewHierarchy()
        animateTextures(textures)
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configPhysicsBody(mass: CGFloat, affectedByGravity: Bool, allowsRotation: Bool, isDynamic: Bool) {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width * 1/2, center: CGPoint(x: 0, y: -size.height * 1/4))
        physicsBody?.affectedByGravity = affectedByGravity
        physicsBody?.mass = mass
        physicsBody?.allowsRotation = allowsRotation
        physicsBody?.isDynamic = isDynamic
    }

    private func setupViewHierarchy() {
        addChild(lifeLabel)
    }
    
    private func setLifeLabel(value: Int) {
        lifeLabel.text = String(format: "%d", value)
    }

    public func theObjectIsDead() {
        removeFromParent()
    }

    // MARK: - Animation
    private func animateTextures(_ textures: [AnimationTextures]) {
        textures.forEach { animation in
            let skin = SKSpriteNode(texture: nil, color: .clear, size: size)
            skin.zPosition = animation.zPosition

            let animationAction = SKAction.animate(with: animation.textures, timePerFrame: 0.025)
            let foreverAction = SKAction.repeatForever(animationAction)

            self.addChild(skin)
            skin.run(foreverAction)
        }
    }
}

// MARK: - Alive
extension LiveObject: Alive {
    public func add(lifePoints: Int) {
        life += lifePoints
        setLifeLabel(value: life)
        guard life <= 0 else {
            return
        }
        theObjectIsDead()
    }
}
