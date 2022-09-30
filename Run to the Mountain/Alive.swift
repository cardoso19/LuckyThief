//
//  Alive.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso Kuhn on 29.09.22.
//  Copyright © 2022 Warrior Iena. All rights reserved.
//

import Foundation

protocol Alive {
    func add(lifePoints: Int)
    func remove(lifePoints: Int)
}

extension Alive {
    func remove(lifePoints: Int) {
        add(lifePoints: -lifePoints)
    }
}
