//
//  Exercise.swift
//  MyGymTracker
//
//  Created by Vaibhav on 08/04/23.
//

import Foundation

struct Exercise: Codable, Identifiable {
    var id = UUID()
    let name: String
    let force: String
    let level: String
    let mechanic: String
    let equipment: String
    let primaryMuscles: [String]
    let secondaryMuscles: [String]
    let instructions: [String]
    let category: String
}
