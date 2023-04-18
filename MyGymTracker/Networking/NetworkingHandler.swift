//
//  NetworkingHandler.swift
//  MyGymTracker
//
//  Created by Vaibhav on 13/04/23.
//

import Foundation
 

class NetworkingHandler {
    private let workoutDataURL = "https://aulzoiecl0.execute-api.us-east-1.amazonaws.com/default/getWorkouts"

    func fetchWorkouts() async throws -> [Exercise] {
        guard let url = URL(string: workoutDataURL) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let exercises = try JSONDecoder().decode([Exercise].self, from: data)
        return exercises
    }
}
