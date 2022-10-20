//
//  WaveCreator.swift
//  LuckyThief
//
//  Created by Matheus Cardoso Kuhn on 03.10.22.
//  Copyright © 2022 Warrior Iena. All rights reserved.
//

import SpriteKit

final class WaveCreator {
    // MARK: - Variables
    private var npcCreator: NPCCreator
    private(set) var waveCount: Int = 0
    private(set) var enemies: [Enemy] = []

    // MARK: - Init
    private init(npcCreator: NPCCreator) {
        self.npcCreator = npcCreator
    }

    // MARK: - Waves
    func createNextWave() {
        enemies = []
        let knightCount = waveCount + 2
        let archerKnightCount = waveCount + 1

        let wait = SKAction.wait(forDuration: 0.25)
        let createKnightAction = SKAction.run {
            let knight = NPCCreator.shared.createKnight()
            self.enemies.append(knight)
            self.addChild(knight)
        }
        let sequenceKnight = SKAction.sequence([wait, createKnightAction])
        let repeatCountKnight = SKAction.repeat(sequenceKnight, count: knightCount)

        if archerKnightCount > 0 {
            let createArcherKnightAction = SKAction.run {
                let archerKnight = self.createArcherKnight()
                self.enemies.append(archerKnight)
                self.addChild(archerKnight)
            }
            let sequenceArcherKnight = SKAction.sequence([wait, createArcherKnightAction])
            let repeatCountArcherKnight = SKAction.repeat(sequenceArcherKnight, count: archerKnightCount)
            let sequenceFinal = SKAction.sequence([repeatCountKnight, repeatCountArcherKnight])
            run(sequenceFinal)
        } else {
            run(repeatCountKnight)
        }

        Status.shared.setEnemiesAlive(createdEnemies: knightCount + archerKnightCount)
        Status.shared.increaseWaveCount()
    }

    func resetWaveCount() {
        waveCount = 0
        removeAllActions()
    }
}
