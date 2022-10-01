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
    var firedArrows: [Arrow: Int] = [:]
    private var arrowSize: CGSize!
    static let shared = ArrowPool()

    // MARK: - Init
    private init() {}

    // MARK: - Pool
    func createArrows(size: CGSize) {
        arrowSize = size
        (0...15).forEach { _ in avaialbleArrows.append(Arrow(size: size)) }
    }

    func getArrow() -> Arrow {
        let arrow: Arrow
        if avaialbleArrows.isEmpty {
            arrow = Arrow(size: arrowSize)
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
