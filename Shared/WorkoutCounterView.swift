//
//  WorkoutCounterView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/4/23.
//

import SwiftUI

enum CountDown: Int {
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

struct WorkoutCounterView: View {
    let workout: Workout
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var time = CountDown.ready.rawValue
    @State private var isPaused = true
    @State private var currentSet = 0
    @State private var currentRep = 0
    @State private var countDownType = CountDown.ready

    private let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    private let withActiveAnimation: (ScenePhase, () -> Void) -> Void = { scenePhase, animate in
        if scenePhase == .active {
            withAnimation {
                animate()
            }
        } else {
            animate()
        }
    }

    var body: some View {
        TimelineView(.periodic(from: workoutManager.builder?.startDate ?? Date(), by: 1)) { _ in
            GeometryReader { g in
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15))
                        .foregroundColor(.pink)
                }
                .clipShape(Circle())
                .tint(.red)
                .frame(width: 25, height: 25)
                .position(x: 20, y: 10)

                ProgressCounter(value: $time,
                                total: countDownType.rawValue,
                                primaryColor: Color("bluePrimaryColor"),
                                secondaryColor: Color("blueSecondaryColor"),
                                textColor: Color("orangePrimaryColor"))
                .overlay {
                    Text(countDownType.toString)
                        .font(.system(size: min(g.size.width, g.size.height) * 0.15, weight: .bold))
                        .foregroundStyle(Color("orangePrimaryColor"))
                        .position(x: g.size.width / 2, y: g.size.height / 4)

                    ZStack {
                        ProgressCounter(value: $currentSet,
                                        total: Int(workout.numSets),
                                        primaryColor: Color("orangePrimaryColor"),
                                        secondaryColor: Color("orangeSecondaryColor"),
                                        textColor: Color.white)
                            .frame(width: g.size.width * 0.2, height: g.size.height * 0.2)

                        Text("Set")
                            .font(.system(size: min(g.size.width, g.size.height) * 0.07))
                            .padding(.top, 45)
                    }
                    .padding(.leading, 10)
                    .position(x: g.size.width / 4, y: g.size.height / 2)

                    ZStack {
                        ProgressCounter(value: $currentRep,
                                        total: Int(workout.numReps),
                                        primaryColor: Color("orangePrimaryColor"),
                                        secondaryColor: Color("orangeSecondaryColor"),
                                        textColor: Color.white)
                            .frame(width: g.size.width * 0.2, height: g.size.height * 0.2)
                        
                        Text("Rep")
                            .font(.system(size: min(g.size.width, g.size.height) * 0.07))
                            .padding(.top, 45)
                    }
                    .padding(.trailing, 10)
                    .position(x: g.size.width * 0.75, y: g.size.height / 2)

                    Button {
                        isPaused ? resumeWorkout() : pauseWorkout()
                    } label: {
                        Image(systemName: "playpause")
                            .font(.system(size: min(g.size.width, g.size.height) * 0.12))
                            .foregroundColor(!isPaused ? .green : .yellow)
                            .hidden()
                    }
                    .clipShape(Circle())
                    .tint(isPaused ? .green : .yellow)
                    .frame(width: g.size.width * 0.17, height: g.size.height * 0.17)
                    .position(x: g.size.width / 2, y: g.size.height * 0.78)
                    .overlay {
                        let pos = CGPoint(x: g.size.width / 2, y: g.size.height * 0.78)
                        PlayPauseIcon(center: pos, isPaused: $isPaused)
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            if !isPaused {
                withActiveAnimation(scenePhase) {
                    time -= 1
                }
            }

            if time < 0 {
                switch countDownType {
                case .hold:
                    WKInterfaceDevice.current().play(.stop)
                    countDownType = .release
                    withActiveAnimation(scenePhase) {
                        currentRep += 1
                    }
                case .release:
                    WKInterfaceDevice.current().play(.success)
                    countDownType = .hold
                case .ready:
                    WKInterfaceDevice.current().play(.success)
                    countDownType = .hold
                        withActiveAnimation(scenePhase) {
                            currentSet += 1
                            currentRep = 0
                        }
                case .done:
                    break
                }

                if currentRep == workout.numReps {
                    WKInterfaceDevice.current().play(.retry)
                    countDownType = currentSet == workout.numSets ? .done : .ready
                    pauseWorkout()
                }

                time = countDownType.rawValue
            }
        }
    }

    func pauseWorkout() {
        withAnimation {
            isPaused = true
        }
        workoutManager.pause()
    }

    func resumeWorkout() {
        withAnimation {
            isPaused = false
        }
        workoutManager.resume()
    }
}

struct WorkoutCounterView_Previews: PreviewProvider {
    static var previews: some View {
        let workoutManager = WorkoutManager()
        WorkoutCounterView(workout: Workout.example())
            .environmentObject(workoutManager)
    }
}
