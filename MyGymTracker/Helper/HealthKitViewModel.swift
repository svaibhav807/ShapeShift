//
//  HealthKitViewModel.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 16/02/23.
//

import Foundation
import HealthKit


class HealthKitViewModel: ObservableObject {
    private var healthStore = HKHealthStore()
    private var healthKitManager: HealthKitManager
    @Published var userStepCount = ""
    @Published var userActiveCaloriesBurned = ""
    @Published var isAuthorized = false

    init() {
        self.healthKitManager = HealthKitManager()
    }

    func healthRequest() {
        healthKitManager.setUpHealthRequest(healthStore: healthStore) {
            self.changeAuthorizationStatus()
            self.readStepsTakenToday()
            self.readCaloriesBurnedToday()
        }
    }

    func readStepsTakenToday() {
        healthKitManager.readStepCount(forToday: Date(), healthStore: healthStore) { step in
            if step != 0.0 {
                DispatchQueue.main.async {
                    self.userStepCount = String(format: "%.0f", step)
                }
            }
        }
    }

    func readCaloriesBurnedToday() {
        healthKitManager.readCaloriesBurned(forToday: Date(), healthStore: healthStore) { calories in
            if let calories = calories {
                DispatchQueue.main.async {
                    self.userActiveCaloriesBurned = String(format: "%.0f", calories)
                }
            }
        }
    }

    func changeAuthorizationStatus() {
        guard let stepQtyType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        let status = self.healthStore.authorizationStatus(for: stepQtyType)

        DispatchQueue.main.async {
            switch status {
            case .notDetermined:
                self.isAuthorized = false
            case .sharingDenied:
                self.isAuthorized = false
            case .sharingAuthorized:
                self.isAuthorized = true
            @unknown default:
                self.isAuthorized = false
            }
        }
    }
}
