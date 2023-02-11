//
//  RepometerApp.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

@main
struct RepometerApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            WorkoutsView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
