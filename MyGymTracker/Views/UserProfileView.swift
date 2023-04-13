//
//  UserProfileView.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 18/03/23.
//

import SwiftUI

import SwiftUI

struct UserProfileView: View {
    @State private var userData = UserData()

    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var age: String = ""
    @State private var selectedGender: Gender? = .male
    @State private var selectedActivityLevel: ActivityLevel? = .sedentary
    @FocusState private var textInFocus: Bool

    private let genderOptions: [Gender] = [.male, .female, .other]
    private let activityLevelOptions: [ActivityLevel] = [.sedentary, .lightlyActive, .moderatelyActive, .veryActive, .extremelyActive]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    CustomTextField(title: "Weight (kg)", text: $weight, keyboardType: .decimalPad)
                        .focused($textInFocus)

                    CustomTextField(title: "Height (cm)", text: $height, keyboardType: .decimalPad)
                        .focused($textInFocus)

                    CustomTextField(title: "Age", text: $age, keyboardType: .numberPad)
                        .focused($textInFocus)


                    Picker("Gender", selection: $selectedGender) {
                        ForEach(genderOptions, id: \.self) { gender in
                            Text(gender.rawValue.capitalized).tag(gender)
                        }
                    }
                }

                Section(header: Text("Activity Level")) {
                    Picker("Activity Level", selection: $selectedActivityLevel) {
                        ForEach(activityLevelOptions, id: \.self) { activityLevel in
                            Text(activityLevel.text).tag(activityLevel)
                        }
                    }
                }

                Section {
                    HStack {
                        Spacer()
                        Button(action: saveUserData) {
                            Text("Save")
                                .frame(width: 120, height: 44)
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("User Data")
            .onAppear(perform: loadUserData)

        }
    }

    private func loadUserData() {
        if let loadedUserData = UserData.load() {
            userData = loadedUserData

            weight = String(userData.weight ?? 0)
            height = String(userData.height ?? 0)
            age = String(userData.age ?? 0)
            selectedGender = userData.gender
            selectedActivityLevel = userData.activityLevel
        }
    }

    private func saveUserData() {
        textInFocus = false
        guard let weight = Double(weight), let height = Double(height), let age = Int(age),
              let gender = selectedGender, let activityLevel = selectedActivityLevel else {
            // Show an alert or some other UI feedback to indicate that all fields must be filled
            return
        }

        userData.weight = weight
        userData.height = height
        userData.age = age
        userData.gender = gender
        userData.activityLevel = activityLevel

        userData.save()
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
