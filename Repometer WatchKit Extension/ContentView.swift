//
//  ContentView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    var body: some View {
        Text("hi \(connectivityManager.data)")
//        List (model.workoutData) { workout in
//            Text(workout.name).font(.headline)
//        }
//        Button("Buzz", action: {
//            WKInterfaceDevice.current().play(WKHapticType.click)
//        })
//            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
