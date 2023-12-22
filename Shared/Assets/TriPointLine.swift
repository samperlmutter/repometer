//
//  PauseVector.swift
//  Repometer
//
//  Created by Sam Perlmutter on 12/19/23.
//

import Foundation
import SwiftUI

typealias AnimatablePoint = AnimatablePair<Double, Double>
typealias AnimatableTriple = AnimatablePair<AnimatablePair<AnimatablePoint, AnimatablePoint>, AnimatablePoint>

struct TriPointLine: Shape {
    var p1: CGPoint
    var p2: CGPoint
    var p3: CGPoint

    init(p1: CGPoint, p2: CGPoint, p3: CGPoint) {
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
    }

    var animatableData: AnimatableTriple {
        get {
            AnimatableTriple(AnimatablePair(AnimatablePoint(p1.x, p1.y), AnimatablePoint(p2.x, p2.y)),
                                            AnimatablePoint(p3.x, p3.y))
        }

        set {
            p1 = CGPoint(x: newValue.first.first.first, y: newValue.first.first.second)
            p2 = CGPoint(x: newValue.first.second.first, y: newValue.first.second.second)
            p3 = CGPoint(x: newValue.second.first, y: newValue.second.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: p1.x, y: p1.y))
            path.addLine(to: CGPoint(x: p2.x, y: p2.y))
            path.addLine(to: CGPoint(x: p3.x, y: p3.y))
        }
    }
}
