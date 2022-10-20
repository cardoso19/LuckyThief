//
//  ObjectCreator.swift
//  LuckyThief
//
//  Created by Matheus Cardoso Kuhn on 02.10.22.
//  Copyright © 2022 Warrior Iena. All rights reserved.
//

import SpriteKit

final class ObjectCreator {
    // MARK: - Variables
    private var screenSize: CGSize = .zero
    private var objSize: CGSize = .zero
    private var playerPosition: CGPoint = .zero
    private var spawnPosition: CGPoint = .zero
    private weak var arrowPool: ArrowPool?

    // MARK: - Init
    init(screenSize: CGSize, arrowPool: ArrowPool) {
        self.screenSize = screenSize
        objSize = CGSize(width: screenSize.height * 1/3, height: screenSize.height * 1/3)
        playerPosition = CGPoint(x: screenSize.width * 1/8, y: screenSize.height * 1/3)
        spawnPosition = CGPoint(x: screenSize.width + objSize.width * 1/8, y: screenSize.height * 1/3)
        self.arrowPool = arrowPool
    }

    // MARK: - Creation
    func createPlayer() -> Player {
        let life = 100
        let attack = 10
        let player = Player(size: objSize, life: life, attack: attack)
        player.position = playerPosition
        return player
    }

    func createKnight() -> Knight {
        let life = 20
        let attack = 10
        let knight = Knight(size: objSize, life: life, attack: attack)
        knight.position = spawnPosition
        return knight
    }

    func createArcherKnight() -> ArcherKnight {
        let life = 10
        let attack = 15
        let archerKnight = ArcherKnight(size: objSize, life: life, attack: attack, sceneWidth: screenSize.width)
        archerKnight.position = spawnPosition
        return archerKnight
    }

    func createArrow() -> Arrow {
        let arrowSize = CGSize(width: objSize.width / 15, height: objSize.height / 4)
        return Arrow(size: arrowSize)
    }
}
