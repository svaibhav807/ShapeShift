//
//  ExerciseListView.swift
//  MyGymTracker
//
//  Created by Vaibhav on 08/04/23.
//

import SwiftUI

struct ExerciseListView: View {
    @Environment(\.exerciseManagedObjectContext) var exerciseContext
    @FetchRequest(entity: CompletedExercise.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CompletedExercise.date, ascending: false)], animation: .default)
    private var completedExercises: FetchedResults<CompletedExercise>
    @State private var showingAddView = false

    var body: some View {
        List {
            Group {
                NavigationLink(destination: WorkoutSelectionView()) {
                    HStack {
                        Text("Add New Item")
                        Spacer()
                        Button {
                            showingAddView.toggle()
                        } label: {
                        }
                    }
                }
//                .background(backgroundColor)
            }
            
            Group {
                
                ForEach(completedExercises) { exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                        VStack(alignment: .leading) {
                            Text(exercise.name ?? "")
                                .font(.headline)
                            Text("Completed on: \(dateFormatter.string(from: exercise.date ?? Date()))")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteExercise)
            }
        }
    }
    
    private func deleteExercise(offsets: IndexSet) {
        withAnimation {
            offsets.map { completedExercises[$0] }.forEach(exerciseContext.delete)
            DataController().save(context: exerciseContext)
        }
    }
    
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

}

struct ExcerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseListView()
    }
}
