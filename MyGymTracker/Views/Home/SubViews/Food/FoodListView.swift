//
//  FoodListView.swift
//  MyGymTracker
//
//  Created by Vaibhav on 08/04/23.
//

import SwiftUI

struct FoodListView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food: FetchedResults<Food>
    @Environment (\.managedObjectContext) var manageObjectContext
    @State private var showingAddView = false
    let backgroundColor: Color = Color(.systemGray6)
    let viewBackgroundColor: Color = Color(.systemBackground)

    var body: some View {
        List {
            Group {
                NavigationLink(destination: AddFoodView()) {
                    HStack {
                        Text("Add New Item")
                        Spacer()
                        Button {
                            showingAddView.toggle()
                        } label: {
                        }
                    }
                }
                .background(backgroundColor)
            }
            
            Group {
                ForEach(food) { food in
                    NavigationLink(destination: Text("\(food.calories)")) {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(food.name ?? "Text")
                                    .bold()
                                Text("\(Int(food.calories))") + Text(" calories").foregroundColor(.red)
                            }
                            
                            Spacer()
                            Text(timeSince(date: food.date ?? Date()))
                                .foregroundColor(.gray)
                                .italic()
                        }
                    }
                    .background(backgroundColor)
                }
                .onDelete(perform: deleteFood)
            }
        }
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0] }
                .forEach(manageObjectContext.delete)

            // Saves to our database
            DataController().save(context: manageObjectContext)
        }
    }
}

struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView()
    }
}
