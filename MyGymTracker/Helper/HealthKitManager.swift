//
//  HealthKitManager.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 16/02/23.
//

import Foundation
import HealthKit


class HealthKitManager {

    func setUpHealthRequest(healthStore: HKHealthStore,
                            readSteps: @escaping () -> Void)
    {
        if HKHealthStore.isHealthDataAvailable(), let stepCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount), let caloriesBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) {
            healthStore.requestAuthorization(toShare: [stepCount, caloriesBurned], read: [stepCount, caloriesBurned]) { success, error in
                if success {
                    readSteps()
                } else if error != nil {
                    // handle your error here
                    print("not wiorkunbg")
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
}
