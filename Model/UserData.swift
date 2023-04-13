//
//  UserData.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 18/03/23.
//

import Foundation
enum Gender: String, Codable {
    case male
    case female
    case other

    var value: Double {
        switch self {
        case .male: return 5
        case .female: return -161
        case .other: return 5
        }
    }
}

enum ActivityLevel: String, Codable {
    case sedentary
    case lightlyActive
    case moderatelyActive
    case veryActive
    case extremelyActive

    var text: String {
        switch self {
        case .sedentary: return "Sedentary"
        case .lightlyActive: return "Lightly Active"
        case .moderatelyActive: return "Moderately Active"
        case .veryActive: return "Very Active"
        case .extremelyActive: return "Extremely Active"
        }
    }

    var multiplier: Double {
        switch self {
        case .sedentary: return 1.2
        case .lightlyActive: return 1.375
        case .moderatelyActive: return 1.55
        case .veryActive: return 1.725
        case .extremelyActive: return 1.9
        }
    }
}

struct UserData: Codable {
    var weight: Double?
    var height: Double?
    var age: Int?
    var gender: Gender?
    var activityLevel: ActivityLevel?

    func calculateBMR() -> Double? {
        guard let weight = weight, let height = height, let age = age, let gender = gender else {
            return nil
        }

        let baseBMR = (10 * weight) + (6.25 * height) - (5 * Double(age))
        return baseBMR + gender.value
    }

    func calculateTDEE() -> Double? {
        guard let bmr = calculateBMR(), let activityLevel = activityLevel else {
            return nil
        }

        return bmr * activityLevel.multiplier
    }

    func calculateCalorieDeficit(desiredDeficit: Double) -> Double? {
        guard let tdee = calculateTDEE() else {
            return nil
        }

        return tdee - desiredDeficit
    }


    func save() {
          let userDefaultsKey = "userData"
          do {
              let encoder = JSONEncoder()
              let data = try encoder.encode(self)
              UserDefaults.standard.set(data, forKey: userDefaultsKey)
          } catch {
              print("Error encoding UserData: \(error)")
          }
      }

      static func load() -> UserData? {
          let userDefaultsKey = "userData"

          if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
              do {
                  let decoder = JSONDecoder()
                  let userData = try decoder.decode(UserData.self, from: data)
                  return userData
              } catch {
                  print("Error decoding UserData: \(error)")
                  return nil
              }
          } else {
              return nil
          }
      }
}
