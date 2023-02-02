//
//  Connectivity.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/1/23.
//

import Foundation
import WatchConnectivity

class Connectivity: NSObject, ObservableObject, WCSessionDelegate {
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
                    // TODO: beep
                }
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {}

    #else
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // TODO: buzz
    }
    #endif

    func send(_ workout: Workout) {
        let session = WCSession.default

        if session.activationState == .activated {
            do {
                let jsonWorkout = String(data: try JSONEncoder().encode(workout), encoding: .utf8)!
                try session.updateApplicationContext(["workoutData": jsonWorkout])
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
                let workout = try decoder.decode(Workout.self, from: Data((applicationContext["workoutData"] as! String).utf8))
                self.workouts.append(workout)
            } catch {
                print("error decoding workout")
            }
        }
    }
}
