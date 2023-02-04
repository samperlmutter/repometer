//
//  Workout+CoreDataClass.swift
//  Repometer
//
//  Created by Sam Perlmutter on 1/25/23.
//
//

import Foundation
import CoreData

@objc(Workout)
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
        let example = Workout(context: DataController.shared.container.viewContext)
        example.id = UUID()
        example.name = "plank"
        example.desc = "do a plank"
        example.holdTime = 30
        example.numReps = 1
        example.numSets = 2
        
        return example
    }
    #endif
}

extension Workout : Identifiable {}


public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
