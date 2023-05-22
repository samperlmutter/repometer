//
//  CoreWorkoutData.swift
//  Repometer
//
//  Created by Sam Perlmutter on 5/16/23.
//

import Foundation
import CoreData
import Combine

final class CoreWorkoutData : NSObject, ObservableObject {
    static let shared = CoreWorkoutData()
    
    @Published var workouts: [Workout] = []
    private var moc: NSManagedObjectContext
    
    private var cancellable: Set<AnyCancellable> = []
    
    override private init() {
        self.moc = DataController.shared.container.viewContext
        
        super.init()

        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        do {
            workouts = try moc.fetch(fetchRequest)
        } catch {
            print("Failed to fetch workouts: \(error.localizedDescription)")
        }
        
        Connectivity.shared.workouts = workouts
    }
    
    public func addWorkout(_ id: UUID, _ name: String, _ desc: String, _ holdTime: Int32, _ numReps: Int32, _ numSets: Int32) {
        let workout = Workout(context: moc)
        workout.id = id
        workout.name = name
        workout.desc = desc
        workout.holdTime = holdTime
        workout.numReps = numReps
        workout.numSets = numSets
        
        workouts.append(workout)
        
        if moc.hasChanges {
            try? moc.save()
        }
        
        Connectivity.shared.send(.add(workout))
    }
    
    // TODO:
    public func updateWorkout(_ workout: Workout) {
        
        if moc.hasChanges {
            try? moc.save()
        }
    }
    
    public func deleteWorkout(_ workout: Workout) {
        moc.delete(workout)
        
        if moc.hasChanges {
            try? moc.save()
        }
        
        workouts.removeAll { $0 == workout }
        Connectivity.shared.send(.delete(workout))
    }
}
