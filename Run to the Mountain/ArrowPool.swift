//
//  ArrowPool.swift
//  LuckyThief
//
//  Created by Matheus Cardoso Kuhn on 01.10.22.
//  Copyright © 2022 Warrior Iena. All rights reserved.
//

import Foundation

final class ArrowPool {
    // MARK: - Variables
    private var avaialbleArrows: [Arrow] = []
    private(set) var firedArrows: [Arrow: Int] = [:]
    private var objectCreator: ObjectCreator

    // MARK: - Init
    init(objectCreator: ObjectCreator) {
        self.objectCreator = objectCreator
        createInitialArrows()
    }

    // MARK: - Pool
    func createInitialArrows() {
        (0...15).forEach { _ in avaialbleArrows.append(objectCreator.createArrow()) }
    }

    func getArrow() -> Arrow {
        let arrow: Arrow
        if avaialbleArrows.isEmpty {
            arrow = objectCreator.createArrow()
        } else {
            arrow = avaialbleArrows.removeFirst()
            arrow.removeFromParent()
        }
        firedArrows[arrow] = 1
        return arrow
    }

    func putArrowBack(arrow: Arrow) {
        firedArrows.removeValue(forKey: arrow)
        avaialbleArrows.append(arrow)
    }
}
