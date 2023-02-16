//
//  MyGymTrackerApp.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 09/01/23.
//

import SwiftUI

@main
struct MyGymTrackerApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(HealthKitViewModel())
        }
    }
}
