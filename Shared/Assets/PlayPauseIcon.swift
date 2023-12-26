//
//  PlayPauseIcon.swift
//  Repometer
//
//  Created by Sam Perlmutter on 12/19/23.
//

import Foundation
import SwiftUI

struct PlayPauseIcon: View {
    let center: CGPoint
    @Binding var isPaused: Bool

    @State private var p1: CGPoint
    @State private var p2: CGPoint
    @State private var p3: CGPoint
    @State private var p4: CGPoint
    @State private var p5: CGPoint
    @State private var p6: CGPoint

    private let pausePoints: [[CGPoint]]
    private let playPoints: [[CGPoint]]
    #if os(watchOS)
    private let s = 0.8
    #else
    private let s = 3.2
    #endif

    init(center: CGPoint, isPaused: Binding<Bool>) {
        self.center = center
        _isPaused = isPaused
        pausePoints = [
            [
                CGPoint(x: center.x - (3 * s), y: center.y - (7 * s)),
                CGPoint(x: center.x - (3 * s), y: center.y),
                CGPoint(x: center.x - (3 * s), y: center.y + (7 * s)),
            ],
            [
                CGPoint(x: center.x + (3 * s), y: center.y - (7 * s)),
                CGPoint(x: center.x + (3 * s), y: center.y),
                CGPoint(x: center.x + (3 * s), y: center.y + (7 * s)),
            ]
        ]
        playPoints = [
            [
                CGPoint(x: center.x - (5 * s), y: center.y - (7 * s)),
                CGPoint(x: center.x - (5 * s), y: center.y),
                CGPoint(x: center.x - (5 * s), y: center.y + (7 * s)),
            ],
            [
                CGPoint(x: center.x - (5 * s), y: center.y - (7 * s)),
                CGPoint(x: center.x + (7 * s), y: center.y),
                CGPoint(x: center.x - (5 * s), y: center.y + (7 * s)),
            ]
        ]

        self.p1 = isPaused.wrappedValue ? playPoints[0][0] : pausePoints[0][0]
        self.p2 = isPaused.wrappedValue ? playPoints[0][1] : pausePoints[0][1]
        self.p3 = isPaused.wrappedValue ? playPoints[0][2] : pausePoints[0][2]
        self.p4 = isPaused.wrappedValue ? playPoints[1][0] : pausePoints[1][0]
        self.p5 = isPaused.wrappedValue ? playPoints[1][1] : pausePoints[1][1]
        self.p6 = isPaused.wrappedValue ? playPoints[1][2] : pausePoints[1][2]
    }

    var body: some View {
        ZStack {
            TriPointLine(p1: p1, p2: p2, p3: p3)
                .stroke(isPaused ? .green : .yellow, style: StrokeStyle(lineWidth: (1.5 * s), lineCap: .round, lineJoin: .round))
            TriPointLine(p1: p4, p2: p5, p3: p6)
                .stroke(isPaused ? .green : .yellow, style: StrokeStyle(lineWidth: (1.5 * s), lineCap: .round, lineJoin: .round))
        }.onChange(of: isPaused) {
            withAnimation {
                p1 = isPaused ? playPoints[0][0] : pausePoints[0][0]
                p2 = isPaused ? playPoints[0][1] : pausePoints[0][1]
                p3 = isPaused ? playPoints[0][2] : pausePoints[0][2]
                p4 = isPaused ? playPoints[1][0] : pausePoints[1][0]
                p5 = isPaused ? playPoints[1][1] : pausePoints[1][1]
                p6 = isPaused ? playPoints[1][2] : pausePoints[1][2]
            }
        }
    }
}

struct PlayPauseIcon_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPaused = false
        PlayPauseIcon(center: CGPoint(x: 200, y: 200), isPaused: $isPaused)
    }
}
