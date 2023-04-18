//
//  ExerciseDetailView.swift
//  MyGymTracker
//
//  Created by Vaibhav on 14/04/23.
//

import SwiftUI

struct ExerciseDetailView: View {
    let exercise: CompletedExercise
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.blue, Color.neonBlue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)

    var body: some View {
         ScrollView {
             VStack(alignment: .leading, spacing: 20) {
                 Text(exercise.name ?? "")
                     .font(.largeTitle)
                     .fontWeight(.bold)
//                     .padding()
//                     .background(g,radient)
                     .foregroundColor(.white)
                     .cornerRadius(10)
                 
                 VStack {
                     HStack {
                         infoItem(title: "Force:", value: exercise.force)
                         infoItem(title: "Level:", value: exercise.level)
                     }
//                     HStack {
                         infoItem(title: "Mechanic:", value: exercise.mechanic)
                         infoItem(title: "Equipment:", value: exercise.equipment)
//                     }
//                     HStack {
                         infoItem(title: "Category:", value: exercise.category)
//                     }
                 }
                 
                 VStack(alignment: .leading, spacing: 8) {
                     Text("Primary Muscles:")
                         .font(.headline)
                     muscleList(muscles: exercise.primaryMuscles)
                 }
                 
                 VStack(alignment: .leading, spacing: 8) {
                     Text("Secondary Muscles:")
                         .font(.headline)
                     muscleList(muscles: exercise.secondaryMuscles)
                 }
                 
                 VStack(alignment: .leading, spacing: 8) {
                     Text("Instructions:")
                         .font(.headline)
                     ForEach(exercise.instructions ?? [""], id: \.self) { instruction in
                         Text(instruction)
                             .font(.subheadline)
                             .fixedSize(horizontal: false, vertical: true)
                             .padding(.leading, 16)
                     }
                 }
                 
             }
             .padding()
         }
//         .navig /ationTitle("Exercise Details")
     }
     
    private func infoItem(title: String, value: String?) -> some View {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text(value ?? "")
                    .font(.subheadline)
            }
            .padding()
            .background(gradient)
            .foregroundColor(.white)
            .cornerRadius(10)
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    
    private func muscleList(muscles: [String]?) -> some View {
          HStack {
              ForEach(muscles ?? [""], id: \.self) { muscle in
                  Text(muscle)
                      .font(.subheadline)
                      .padding(.horizontal, 8)
                      .padding(.vertical, 4)
                      .background(Color.blue.opacity(0.2))
                      .foregroundColor(Color.blue)
                      .cornerRadius(10)
              }
          }
      }
 }
//
//struct ExerciseDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseDetailView(exercise: <#CompletedExercise#>)
//    }
//}
