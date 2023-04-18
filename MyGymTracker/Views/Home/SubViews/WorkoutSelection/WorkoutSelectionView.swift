//
//  WorkoutSelectionView.swift
//  MyGymTracker
//
//  Created by Vaibhav on 13/04/23.
//

import SwiftUI

struct WorkoutSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.exerciseManagedObjectContext) var exerciseContext
    @StateObject private var viewModel = WorkoutSelectionViewModel(apiClient: NetworkingHandler())
    @State private var expandedItems: Set<UUID> = []
    @State private var searchText: String = ""

    var filteredWorkouts: [Exercise] {
        viewModel.availableWorkouts.filter { workout in
            searchText.isEmpty || workout.name.localizedStandardContains(searchText)
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                       .padding(.horizontal)
            List(filteredWorkouts, id: \.id) { workout in
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(workout.name)
                                .font(.headline)
                                .foregroundColor(.blue)
                            Text("Category: \(workout.category)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            withAnimation {
                                toggleExpanded(for: workout)
                            }
                        }) {
                            Image(systemName: expandedItems.contains(workout.id) ? "chevron.up" : "chevron.down")
                                .foregroundColor(.blue)
                        }
                    }
                    if expandedItems.contains(workout.id) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Instructions:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            ForEach(workout.instructions, id: \.self) { instruction in
                                Text(instruction)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top)
                        Button(action: {
                            addWorkout(workout: workout)
                        }) {
                            Text("Add Workout")
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 24)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding(.top)
                    }
                }
                .padding(.vertical)
            }
        }
        .onAppear(perform:{
            Task{
               await viewModel.fetchWorkouts()
            }
        })
    }
    
    private func toggleExpanded(for workout: Exercise) {
        if expandedItems.contains(workout.id) {
            expandedItems.remove(workout.id)
        } else {
            expandedItems.insert(workout.id)
        }
    }
    
    func addWorkout(workout: Exercise) {
        DataController().addExercise(exercise: workout, context: exerciseContext)
        presentationMode.wrappedValue.dismiss()
    }
}
//
//struct WorkoutSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutSelectionView()
//    }
//}
