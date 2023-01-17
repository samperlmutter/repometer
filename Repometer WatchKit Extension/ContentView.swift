//
//  ContentView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var workouts: FetchedResults<Workout>
    @StateObject var connectivity = Connectivity()
    @State private var showingAlert = false
    var body: some View {
//        List {
//            ForEach(workouts) { workout in
//                NavigationLink {
//                    WorkoutView(workout: workout)
//                } label: {
//                    Text(workout.name ?? "Unknown")
//                            .font(.headline)
//                }
//            }
//            .onDelete { i in
//                moc.delete(workouts[i.first!])
//                try? moc.save()
//            }
//        }
        Text(connectivity.receivedText)
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
