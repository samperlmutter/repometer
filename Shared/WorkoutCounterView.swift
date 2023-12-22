//
//  WorkoutCounterView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/4/23.
//

import SwiftUI

struct WorkoutCounterView: View {
    let workout: Workout
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var counterVM: WorkoutCounterViewModel

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

    #if os(watchOS)
    @EnvironmentObject var workoutManager: WorkoutManager
    func pauseWorkout() {
        withAnimation {
            counterVM.isPaused = true
        }
        workoutManager.pause()
    }

    func resumeWorkout() {
        withAnimation {
            counterVM.isPaused = false
        }
        workoutManager.resume()
    }
    #else
    func pauseWorkout() {
        withAnimation {
            counterVM.isPaused = true
        }
    }

    func resumeWorkout() {
        withAnimation {
            counterVM.isPaused = false
        }
    }
    #endif
    
    init(workout: Workout) {
        self.workout = workout
        self.counterVM = WorkoutCounterViewModel(workout)
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { _ in

            ProgressCounter(value: $counterVM.time,
                            total: counterVM.countDownType.rawValue,
                            primaryColor: Color("bluePrimaryColor"),
                            secondaryColor: Color("blueSecondaryColor"),
                            textColor: Color("orangePrimaryColor"))
            .overlay {
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

                    Text(counterVM.countDownType.toString)
                        .font(.system(size: min(g.size.width, g.size.height) * 0.15, weight: .bold))
                        .foregroundStyle(Color("orangePrimaryColor"))
                        .position(x: g.size.width / 2, y: g.size.height / 4)

                    ZStack {
                        ProgressCounter(value: $counterVM.currentSet,
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
                        ProgressCounter(value: $counterVM.currentRep,
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
                        counterVM.isPaused ? resumeWorkout() : pauseWorkout()
                    } label: {
                        Image(systemName: "playpause")
                            .font(.system(size: min(g.size.width, g.size.height) * 0.12))
                            .foregroundColor(!counterVM.isPaused ? .green : .yellow)
                            .hidden()
                    }
                    .clipShape(Circle())
                    .tint(counterVM.isPaused ? .green : .yellow)
                    .frame(width: g.size.width * 0.17, height: g.size.height * 0.17)
                    .position(x: g.size.width / 2, y: g.size.height * 0.78)
                    .overlay {
                        let pos = CGPoint(x: g.size.width / 2, y: g.size.height * 0.78)
                        PlayPauseIcon(center: pos, isPaused: $counterVM.isPaused)
                    }
                }
                .scaledToFit()
            }
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
        WorkoutCounterView(workout: Workout.example())
            .environmentObject(workoutManager)
        #else
        WorkoutCounterView(workout: Workout.example())
        #endif
    }
}
