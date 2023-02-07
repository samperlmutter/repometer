//
//  WorkoutActiveView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/4/23.
//

import SwiftUI

struct WorkoutActiveView: View {
    @Environment(\.scenePhase) private var scenePhase
    let workout: Workout
    let resetTime = 2 // should be user preference eventually
    @State private var set = 1
    @State private var rep = 1
    @State private var holdTime: Int32 = 0
    @State private var playing = true // false in DEBUG
    @State private var betweenReps = true // false in DEBUG
    @State private var releaseTime = 0
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    var body: some View {
        VStack {
            Button(action: {
                playing = !playing
            }, label: {
                Image(systemName: playing ? "pause.fill" : "play.fill")
            })
            .font(.title2)
            Text(betweenReps ? "Release for" : "Hold for")
                .font(.subheadline)
            Text("\(betweenReps ? releaseTime : Int(holdTime))")
                .font(.title)
            Spacer()
            HStack {
                Text("Set \(set)/\(workout.numSets)")
                Spacer()
                Text("Rep \(rep)/\(workout.numReps)")
            }
            .padding([.top, .horizontal])
        }
        .navigationTitle(workout.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            workout.numReps = 3 // DEBUG
            holdTime = workout.holdTime
            releaseTime = resetTime
        }
        .onReceive(timer) { _ in
            if betweenReps {
                decrementReleaseTime()
            } else {
                decrementHoldTime()
            }
        }
    }
    
    func decrementHoldTime() {
        if playing {
            holdTime -= 1
        }
        if holdTime < 0 {
            holdTime = workout.holdTime
            endOfRep()
        }
    }

    func endOfRep() {
        if rep == workout.numReps {
            endOfSet()
        } else {
            rep += 1
            betweenReps = true
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
        playing = false
        WKInterfaceDevice.current().play(.retry)
    }

    func decrementReleaseTime() {
        releaseTime -= 1
        if releaseTime < 0 {
            releaseTime = resetTime
            betweenReps = false
            WKInterfaceDevice.current().play(.success)
        }
    }
}

struct WorkoutActiveView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            WorkoutActiveView(workout: Workout.example())
//                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 8 (41mm)"))
            WorkoutActiveView(workout: Workout.example())
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 8 (45mm)"))
        }
    }
}
