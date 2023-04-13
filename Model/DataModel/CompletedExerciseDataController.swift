//
//  CompletedExerciseDataController.swift
//  MyGymTracker
//
//  Created by Vaibhav on 08/04/23.
//

import Foundation
import CoreData

class CompletedExerciseDataController: ObservableObject {
    let container  = NSPersistentContainer(name: "CompletedExerciseModel")

    init() {
        container.loadPersistentStores() { (desc, error) in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
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

    func addExercise(exercise: Exercise, context: NSManagedObjectContext) {
        let newExercise = CompletedExercise(context: context)
                    newExercise.name = exercise.name
                    newExercise.force = exercise.force
                    newExercise.level = exercise.level
                    newExercise.mechanic = exercise.mechanic
                    newExercise.equipment = exercise.equipment
                    newExercise.primaryMuscles = exercise.primaryMuscles as NSObject
                    newExercise.secondaryMuscles = exercise.secondaryMuscles as NSObject
                    newExercise.instructions = exercise.instructions as NSObject
                    newExercise.category = exercise.category
                    newExercise.date = Date()
   
        save(context: context)
    }
}
