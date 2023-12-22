//
//  Workout+CoreDataClass.swift
//  Repometer
//
//  Created by Sam Perlmutter on 1/25/23.
//
//

import Foundation
import CoreData

public class Workout: NSManagedObject, Codable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, desc, holdTime, numReps, numSets
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var desc: String?
    @NSManaged public var holdTime: Int32
    @NSManaged public var numReps: Int32
    @NSManaged public var numSets: Int32
    
    public required convenience init(from decoder: Decoder) throws {
        guard let managaedObjectContext = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Workout", in: managaedObjectContext) else {
            fatalError("Failed to decode Workout")
        }
        
        self.init(entity: entity, insertInto: managaedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.desc = try container.decode(String.self, forKey: .desc)
        self.holdTime = try container.decode(Int32.self, forKey: .holdTime)
        self.numReps = try container.decode(Int32.self, forKey: .numReps)
        self.numSets = try container.decode(Int32.self, forKey: .numSets)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(desc, forKey: .desc)
        try container.encode(holdTime, forKey: .holdTime)
        try container.encode(numReps, forKey: .numReps)
        try container.encode(numSets, forKey: .numSets)
    }

    #if DEBUG
        public static func example() -> Workout {
            let context = DataController.shared.container.viewContext

            let workouts = [
                createWorkout(context: context, name: "Anterior Pelvic Tilt Correction", desc: "Lie on your back with knees bent and feet flat on the floor. Tighten your abdominal muscles and push your lower back into the floor. Hold for a few seconds, then relax. Repeat.", holdTime: 10, numReps: 5, numSets: 3),
                createWorkout(context: context, name: "Bridge", desc: "Lie on your back with knees bent and feet flat. Lift your hips off the floor by pushing through your heels, forming a straight line from knees to shoulders. Hold the position, then slowly lower back down.", holdTime: 7, numReps: 8, numSets: 2),
                createWorkout(context: context, name: "Leg Raise", desc: "Lie flat on your back with legs straight. Slowly raise your legs to a 90-degree angle, keeping them straight. Lower them back down without touching the floor. Repeat.", holdTime: 5, numReps: 10, numSets: 3),
                createWorkout(context: context, name: "Shoulder Blade Squeeze", desc: "Sit or stand with your back straight. Squeeze your shoulder blades together as if trying to hold a pencil between them. Hold the squeeze, then release. Repeat.", holdTime: 6, numReps: 12, numSets: 2),
                createWorkout(context: context, name: "Knee Extension", desc: "Sit on a chair with your feet flat on the floor. Extend one leg out in front of you until it is straight. Hold the position, then slowly lower your foot back to the floor. Alternate legs.", holdTime: 8, numReps: 6, numSets: 3)
            ]

            return workouts.randomElement() ?? workouts.first!
        }

        private static func createWorkout(context: NSManagedObjectContext, name: String, desc: String, holdTime: Int32, numReps: Int32, numSets: Int32) -> Workout {
            let workout = Workout(context: context)
            workout.id = UUID()
            workout.name = name
            workout.desc = desc
            workout.holdTime = holdTime
            workout.numReps = numReps
            workout.numSets = numSets
            return workout
        }
    #endif
}

public enum WorkoutUpdate: Codable {
    case delete(_ workoutId: UUID)
    case update(_ workout: Workout)
    case add(_ workout: Workout)
    case sync(_ workouts: [Workout])
    case syncCheck(_ workoutIds: [UUID])
}

extension Workout : Identifiable {}

extension Array where Element == Workout {
    func updateWorkouts(update: WorkoutUpdate) {
        
    }
}


public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
