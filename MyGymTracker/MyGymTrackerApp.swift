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
            TabView {
                HomeView()
                    .tabItem {
                        Label("Tracker", systemImage: "bolt")
                    }

                GymActivityView()
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                
                UserProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
            }
            .environment(\.managedObjectContext, dataController.foodContext)
            .environment(\.exerciseManagedObjectContext, dataController.exerciseContext)
            .environmentObject(HealthKitViewModel())
        }
    }
}
