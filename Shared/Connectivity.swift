//
//  Connectivity.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/1/23.
//

import Foundation
import WatchConnectivity

public enum WorkoutUpdate: Codable {
    case delete(_ workout: Workout)
    case update(_ workout: Workout)
    case add(_ workout: Workout)
    case sync(_ workouts: [Workout])
}

class Connectivity: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = Connectivity()
    @Published var workouts: [Workout] = []

    override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    #if os(iOS)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        Task { @MainActor in
            if activationState == .activated {
                if session.isWatchAppInstalled {
                    self.workouts = CoreWorkoutData.shared.workouts
                    // TODO: beep
                }
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }

    #else
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // TODO: buzz
    }
    #endif

    func send(_ updateType: WorkoutUpdate) {
        let session = WCSession.default

        if session.activationState == .activated {
            do {
                let jsonWorkoutUpdate = String(data: try JSONEncoder().encode(updateType), encoding: .utf8)!
                try session.updateApplicationContext(["workoutData": jsonWorkoutUpdate])
            } catch {
                print("failed sending")
            }
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        Task { @MainActor in
            print("received: \(applicationContext["workoutData"] ?? "no data??")")
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = DataController.shared.container.viewContext
            do {
                let workout = try decoder.decode(WorkoutUpdate.self, from: Data((applicationContext["workoutData"] as! String).utf8))
                switch (workout) {
                case let .add(workout):
                    self.workouts.append(workout)
                case let .sync(workouts):
                    self.workouts = workouts
                case let .delete(workout):
                    self.workouts.removeAll { $0 == workout }
                default:
                    break
                }
            } catch {
                print("error decoding workout")
            }
        }
    }
}
