//
//  CGFloat+Calculations.swift
//  LuckyThief
//
//  Created by Matheus Cardoso Kuhn on 01.10.22.
//  Copyright © 2022 Warrior Iena. All rights reserved.
//

import Foundation

extension CGFloat {
    static func calculateZRotation(impulse: CGVector) -> CGFloat {
        atan2(impulse.dy, impulse.dx) + .pi/2
    }
}
