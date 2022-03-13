//
//  Workout.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/16/22.
//

import Foundation

class Workout: NSObject, NSCoding {
    var name: String
    var desc: String
    var holdTime: Int
    var numReps: Int
    var numSets: Int

    init(name: String, desc: String, holdTime: Int, numReps: Int, numSets: Int) {
        self.name = name
        self.desc = desc
        self.holdTime = holdTime
        self.numReps = numReps
        self.numSets = numSets
    }

    required init?(coder decoder: NSCoder) {
        name = decoder.decodeObject(forKey: "name") as? String ?? ""
        desc = decoder.decodeObject(forKey: "desc") as? String ?? ""
        holdTime = decoder.decodeObject(forKey: "holdTime") as? Int ?? 0
        numReps = decoder.decodeObject(forKey: "numReps") as? Int ?? 0
        numSets = decoder.decodeObject(forKey: "numSets") as? Int ?? 0
    }

    func encode(with encoder: NSCoder) {
        encoder.encode(name, forKey: "name")
        encoder.encode(desc, forKey: "desc")
        encoder.encode(holdTime, forKey: "holdTime")
        encoder.encode(numReps, forKey: "numReps")
        encoder.encode(numSets, forKey: "numSets")
    }
}
