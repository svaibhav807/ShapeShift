//
//  DataController.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 09/01/23.
//

import Foundation
import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentContainer

    
    var foodContext: NSManagedObjectContext {
        let context = container.viewContext
              context.name = "FoodContext"
              context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
              return context
       }

       var exerciseContext: NSManagedObjectContext {
           let context = container.viewContext
                context.name = "ExerciseContext"
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                return context
       }
    
    init() {
        // Load FoodModel
        container = NSPersistentContainer(name: "HealthModel")

        container.loadPersistentStores() { (desc, error) in
            if let error = error {
                print("Failed to load the FoodModel data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("LOG: Data saved.")
        } catch {
            print("LOG: The data couldnt be saved.")
        }
    }

    func addFood(name: String, calories: Double, context: NSManagedObjectContext) {
        let food = Food(context: context)
        food.id = UUID()
        food.date = Date()
        food.name = name
        food.calories = calories
        save(context: context)
    }

    func editFood(food: Food, name: String, calories: Double, context: NSManagedObjectContext) {
        food.date = Date()
        food.name = name
        food.calories = calories
        save(context: context)
    }
    
    func addExercise(exercise: Exercise, context: NSManagedObjectContext) {
        let newExercise = CompletedExercise(context: context)
                    newExercise.name = exercise.name
                    newExercise.force = exercise.force
                    newExercise.level = exercise.level
                    newExercise.mechanic = exercise.mechanic
                    newExercise.equipment = exercise.equipment
                    newExercise.primaryMuscles = exercise.primaryMuscles as [String]
                    newExercise.secondaryMuscles = exercise.secondaryMuscles as [String]
                    newExercise.instructions = exercise.instructions as NSObject
                    newExercise.category = exercise.category
                    newExercise.date = Date()
   
        save(context: context)
    }
    
    func deleteCompletedExercise(completedExercise: CompletedExercise, context: NSManagedObjectContext) {
           context.delete(completedExercise)
           save(context: context)
       }
    
}


struct ExerciseManagedObjectContext: EnvironmentKey {
    static let defaultValue = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
}

extension EnvironmentValues {
    var exerciseManagedObjectContext: NSManagedObjectContext {
        get { self[ExerciseManagedObjectContext.self] }
        set { self[ExerciseManagedObjectContext.self] = newValue }
    }
}
