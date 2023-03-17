//
//  HealthKitManager.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 16/02/23.
//

import Foundation
import HealthKit
import CoreLocation


class HealthKitManager {

    func setUpHealthRequest(healthStore: HKHealthStore,
                            readWorkoutsAndEnergyBurned: @escaping () -> Void)
    {
        let workoutType = HKObjectType.workoutType()
        let workoutRoute = HKSeriesType.workoutRoute()
        if HKHealthStore.isHealthDataAvailable(),
           let energyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        {
            healthStore.requestAuthorization(toShare: nil, read: [workoutType,workoutRoute, energyBurnedType]) { success, error in
                if success {
                    readWorkoutsAndEnergyBurned()
                } else if let error = error {
                    print("Error requesting authorization: \(error.localizedDescription)")
                }
            }
        }
    }


    func readStepCount(forToday: Date, healthStore: HKHealthStore, completion: @escaping (Double) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in

            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }

            completion(sum.doubleValue(for: HKUnit.count()))

        }

        healthStore.execute(query)
    }

    func readCaloriesBurned(forToday: Date, healthStore: HKHealthStore, completion: @escaping (Double?) -> Void) {
        guard let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: "2023-02-8")!
        let startOfDay = Calendar.current.startOfDay(for: date)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in

            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil)
                return
            }
            let activeCaloriesBurned = sum.doubleValue(for: HKUnit(from: .kilocalorie))
            completion(activeCaloriesBurned)
        }

        healthStore.execute(query)
    }

    func readWorkouts(healthStore: HKHealthStore) async -> [HKWorkout]? {
        let cycling = HKQuery.predicateForWorkouts(with: .cycling)

        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            healthStore.execute(HKSampleQuery(sampleType: .workoutType(), predicate: cycling, limit: HKObjectQueryNoLimit,sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)], resultsHandler: { query, samples, error in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkout] else {
            return nil
        }

        return workouts
    }

    func getWorkoutRouteLocations(healthStore: HKHealthStore, workout: HKWorkout) async -> [CLLocation]? {
        guard let workoutRoutes = await getWorkoutRoute(healthStore: healthStore, workout: workout) else {
            return nil
        }

        var allLocations: [CLLocation] = []

        for workoutRoute in workoutRoutes {
            let locations = await getLocationDataForRoute(healthStore: healthStore, givenRoute: workoutRoute)
            allLocations.append(contentsOf: locations)
        }

        return allLocations.isEmpty ? nil : allLocations
    }

    func getWorkoutRoute(healthStore: HKHealthStore, workout: HKWorkout) async -> [HKWorkoutRoute]? {
        let byWorkout = HKQuery.predicateForObjects(from: workout)

        let samples = try? await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            healthStore.execute(HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: byWorkout, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: { (query, samples, deletedObjects, anchor, error) in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    return
                }

                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkoutRoute] else {
            return nil
        }

        return workouts
    }

    func getLocationDataForRoute(healthStore: HKHealthStore, givenRoute: HKWorkoutRoute) async -> [CLLocation] {
        let locations = try? await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CLLocation], Error>) in
            var allLocations: [CLLocation] = []

            // Create the route query.
            let query = HKWorkoutRouteQuery(route: givenRoute) { (query, locationsOrNil, done, errorOrNil) in

                if let error = errorOrNil {
                    continuation.resume(throwing: error)
                    return
                }

                guard let currentLocationBatch = locationsOrNil else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                allLocations.append(contentsOf: currentLocationBatch)

                if done {
                    continuation.resume(returning: allLocations)
                }
            }

            healthStore.execute(query)
        }

        return locations ?? []
    }
}
