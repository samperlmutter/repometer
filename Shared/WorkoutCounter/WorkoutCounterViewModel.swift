//
//  WorkoutCounterViewModel.swift
//  Repometer
//
//  Created by Sam Perlmutter on 12/21/23.
//

import Foundation

public enum CountDown: Int {
    case hold = 5
    case release = 2
    case ready = 3
    case done = 1

    var toString: String {
        switch self {
        case .hold:
            return "Hold"
        case .release:
            return "Release"
        case .ready:
            return "Ready"
        case .done:
            return "Done!"
        }
    }
}

class WorkoutCounterViewModel: ObservableObject {
    let workout: Workout
    @Published var time: Double
    @Published var isPaused: Bool
    @Published var currentSet: Double
    @Published var currentRep: Double
    @Published var countDownType: CountDown
    @Published var showDescription: Bool
    
    init(_ workout: Workout) {
        self.workout = workout
        self.time = Double(CountDown.ready.rawValue)
        self.isPaused = true
        self.currentSet = 0.0
        self.currentRep = 0.0
        self.countDownType = CountDown.ready
        self.showDescription = false
    }

    public func tick() {
        if !isPaused {
            time -= 0.0625
        }

        if time < 0 {
            switch countDownType {
            case .hold:
                countDownType = .release
                currentRep += 1
            case .release:
                countDownType = .hold
            case .ready:
                countDownType = .hold
                currentSet += 1
                currentRep = 0
            case .done:
                break
            }

            if Int(currentRep) == workout.numReps {
                countDownType = Int(currentSet) == workout.numSets ? .done : .ready
                isPaused = true
            }

            time = Double(countDownType.rawValue)
        }
    }
}
