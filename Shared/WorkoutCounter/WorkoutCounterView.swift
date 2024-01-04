//
//  WorkoutCounterView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/4/23.
//

import SwiftUI

struct WorkoutCounterView: View {
    #if os(watchOS)
    @EnvironmentObject var workoutManager: WorkoutManager
    #endif
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var counterVM: WorkoutCounterViewModel

    private let timer = Timer.publish(every: 0.0625, on: .main, in: .default).autoconnect()
    private let withActiveAnimation: (ScenePhase, () -> Void) -> Void = { scenePhase, animate in
        if scenePhase == .active {
            withAnimation {
                animate()
            }
        } else {
            animate()
        }
    }

    public func pauseWorkout() {
        withAnimation {
            counterVM.isPaused = true
        }

        #if os(watchOS)
        workoutManager.pause()
        #endif
    }

    public func resumeWorkout() {
        withAnimation {
            counterVM.isPaused = false
        }

        #if os(watchOS)
        workoutManager.resume()
        #endif
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.0625)) { _ in
            GeometryReader { g in
                ProgressCounter(value: $counterVM.time,
                                total: counterVM.countDownType.rawValue,
                                primaryColor: .bluePrimary,
                                secondaryColor: .blueSecondary,
                                textColor: .orangePrimary)
                    .overlay {
                        Text(counterVM.countDownType.toString)
                            .font(.system(size: min(g.size.width, g.size.height) * 0.15, weight: .bold))
                            .foregroundStyle(.orangePrimary)
                            .position(x: g.size.width / 2, y: g.size.height / 4)

                        ProgressCounter(value: $counterVM.currentSet,
                                        total: Int(counterVM.workout.numSets),
                                        primaryColor: .orangePrimary,
                                        secondaryColor: .orangeSecondary,
                                        textColor: Color.primary)
                            .frame(width: g.size.width * 0.2, height: g.size.height * 0.2)
                            .overlay(alignment: .bottom) {
                                Text("Set")
                                    .font(.system(size: min(g.size.width, g.size.height) * 0.07))
                                    .offset(x: 0, y: min(g.size.width, g.size.height) * 0.08)
                            }
                            .padding(.leading, 10)
                            .position(x: g.size.width * 0.22, y: g.size.height / 2)

                        ProgressCounter(value: $counterVM.currentRep,
                                        total: Int(counterVM.workout.numReps),
                                        primaryColor: .orangePrimary,
                                        secondaryColor: .orangeSecondary,
                                        textColor: Color.primary)
                            .frame(width: g.size.width * 0.2, height: g.size.height * 0.2)
                            .overlay(alignment: .bottom) {
                                Text("Rep")
                                    .font(.system(size: min(g.size.width, g.size.height) * 0.07))
                                    .offset(x: 0, y: min(g.size.width, g.size.height) * 0.08)
                            }
                            .padding(.trailing, 10)
                            .position(x: g.size.width * 0.78, y: g.size.height / 2)
                    }
            }
            .scaledToFit()
        }
        .onReceive(timer) { _ in
            withActiveAnimation(scenePhase) {
                counterVM.tick()
            }
        }
        .onChange(of: counterVM.countDownType) {
            #if os(watchOS)
            switch counterVM.countDownType {
            case .hold:
                WKInterfaceDevice.current().play(.success)
            case .release:
                WKInterfaceDevice.current().play(.stop)
            case .ready, .done:
                WKInterfaceDevice.current().play(.retry)
            }
            #endif
        }
    }
}

struct WorkoutCounterView_Previews: PreviewProvider {
    static var previews: some View {
        #if os(watchOS)
        let workoutManager = WorkoutManager()
        WorkoutCounterView(counterVM: WorkoutCounterViewModel(Workout.example()))
            .environmentObject(workoutManager)
        #else
        WorkoutCounterView(counterVM: WorkoutCounterViewModel(Workout.example()))
        #endif
    }
}
