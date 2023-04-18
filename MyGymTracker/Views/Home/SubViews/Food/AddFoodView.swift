//
//  AddFoodView.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 09/01/23.
//

import SwiftUI

struct AddFoodView: View {
    @Environment (\.managedObjectContext) var manageObjectContext
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var calories = 0.0

    var body: some View {
        Form {
            Section {
                TextField("Food name", text: $name)

                VStack {
                Text("calories: \(Int(calories))")
                    Slider(value: $calories, in: 0...1000, step: 10)
                }
                .padding()

                HStack {
                    Spacer()
                    Button("Submit") {
                        DataController().addFood(name: name, calories: calories, context: manageObjectContext)
                        dismiss()
                    }
                    Spacer()

                }
            }
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView()
    }
}
