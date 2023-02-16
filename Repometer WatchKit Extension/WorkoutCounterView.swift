//
//  WorkoutCounterView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/4/23.
//

import SwiftUI

struct WorkoutCounterView: View {
    let workout: Workout
    @EnvironmentObject var workoutManager: WorkoutManager
    let resetTime = 2 // should be user preference eventually
    @State private var set = 1
    @State private var rep = 1
    @State private var holdTime = 0
    @State private var isPaused = false
    @State private var holding = false
    @State private var releaseTime = 0
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    var body: some View {
        TimelineView(.periodic(from: workoutManager.builder?.startDate ?? Date(), by: 1)) { _ in
            VStack {
                Button(action: {
                    if isPaused {
                        resumeWorkout()
                    } else {
                        pauseWorkout()
                    }
                }, label: {
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                })
                .font(.title2)
                Text(holding ? "Hold for" : "Release for")
                    .font(.subheadline)
                Text("\(holding ? Int(holdTime) : releaseTime)")
                    .font(.title)
                Spacer()
                HStack {
                    Text("Set \(set)/\(workout.numSets)")
                    Spacer()
                    Text("Rep \(rep)/\(workout.numReps)")
                }
                .padding([.top, .horizontal])
            }
        }
        .onAppear {
            workoutManager.startWorkout()
            holdTime = Int(workout.holdTime)
            releaseTime = resetTime
        }
        .onReceive(timer) { _ in
            if !isPaused {
                if holding {
                    decrementHoldTime()
                } else {
                    decrementReleaseTime()
                }
            }
        }
        .onDisappear() {
            workoutManager.endWorkout()
        }
    }
    
    func decrementHoldTime() {
        if holding {
            holdTime -= 1
        }
        if holdTime < 0 {
            holdTime = Int(workout.holdTime)
            endOfRep()
        }
    }

    func endOfRep() {
        if rep == workout.numReps {
            endOfSet()
        } else {
            rep += 1
            holding = false
            WKInterfaceDevice.current().play(.stop)
        }
    }

    func endOfSet() {
        if set == workout.numSets {
            holdTime = 0
        } else {
            set += 1
            rep = 1
        }
        pauseWorkout()
        WKInterfaceDevice.current().play(.retry)
    }

    func decrementReleaseTime() {
        releaseTime -= 1
        if releaseTime < 0 {
            releaseTime = resetTime
            holding = true
            WKInterfaceDevice.current().play(.success)
        }
    }
    
    func pauseWorkout() {
        isPaused = true
        workoutManager.pause()
    }
    
    func resumeWorkout() {
        isPaused = false
        workoutManager.resume()
    }
}

struct WorkoutCounterView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCounterView(workout: Workout.example())
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 8 (45mm)"))
    }
}
