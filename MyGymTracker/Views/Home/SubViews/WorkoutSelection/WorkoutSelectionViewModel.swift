//
//  WorkoutSelectionViewMode.swift
//  MyGymTracker
//
//  Created by Vaibhav on 13/04/23.
//

import Foundation
import SwiftUI

class WorkoutSelectionViewModel: ObservableObject {
    @Published var availableWorkouts: [Exercise] = []
    private var apiClient: NetworkingHandler
    
    init(apiClient: NetworkingHandler) {
        self.apiClient = apiClient
    }

    func fetchWorkouts() async {
        do {
            let workouts = try await apiClient.fetchWorkouts()
            DispatchQueue.main.async {
                self.availableWorkouts = workouts
            }
        } catch {
            print("Error fetching workouts: \(error)")
        }
    }
}
