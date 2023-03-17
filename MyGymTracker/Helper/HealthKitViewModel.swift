//
//  HealthKitViewModel.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 16/02/23.
//

import Foundation
import HealthKit
import MapKit
import CoreLocation

@MainActor class HealthKitViewModel: ObservableObject {
    private var healthStore = HKHealthStore()
    private var healthKitManager: HealthKitManager
    @Published var userStepCount = "0"
    @Published var userActiveCaloriesBurned = ""
    @Published var isAuthorized = false
    @Published var workouts: [HKWorkout]?
    @Published var workoutLocations: [HKWorkout: [CLLocation]] = [:]

    

    init() {
        self.healthKitManager = HealthKitManager()
    }

    func location(workout: HKWorkout)  {

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

    func readWorkouts() async {
        let healthStore = HKHealthStore()
        let workouts = await healthKitManager.readWorkouts(healthStore: healthStore)
        DispatchQueue.main.async {
            self.workouts = workouts
        }
        var workoutLocations: [HKWorkout: [CLLocation]] = [:]
        if let workouts = workouts {
            for workout in workouts {
                let locations = await healthKitManager.getWorkoutRouteLocations(healthStore: healthStore, workout: workout)
                workoutLocations[workout] = locations
            }
        } else {
            print("Failed to fetch workouts")
        }
        self.workoutLocations = workoutLocations
        print(workoutLocations)
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

    func createPolyline(from locations: [CLLocation]) -> MKPolyline {
        let coordinates = locations.map { $0.coordinate }
        
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }

    func addRoutesToMap(for workouts: [HKWorkout: [CLLocation]], on mapView: MKMapView) {
        for (_, locations) in workouts {
            let polyline = createPolyline(from: locations)
            mapView.addOverlay(polyline)
        }
    }
}
