//
//  ContentView.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 09/01/23.
//

import SwiftUI

struct ContentView: View {
    @Environment (\.managedObjectContext) var manageObjectContext
    @EnvironmentObject var vm: HealthKitViewModel
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food: FetchedResults<Food>

    @State private var showingAddView = false

    var body: some View {
        if vm.isAuthorized {

            NavigationView {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Calories consumed: \(Int(totalCaloriesToday())) KCal (Today)")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    Text("Calories burned: \(vm.userActiveCaloriesBurned) KCal (Today)")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    Text("Calorie Deficit: \((Int(vm.userActiveCaloriesBurned) ?? 0) - Int(totalCaloriesToday())) KCal (Today)")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    List {
                        ForEach(food) {
                            food in
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
                        }
                        .onDelete(perform: deleteFood)
                    }
                    .listStyle(.plain)
                    .refreshable { }
                }
                .navigationTitle("MyGymTracker")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddView.toggle()
                        } label: {
                            Label("Add food", systemImage: "plus.circle")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
                .sheet(isPresented: $showingAddView) {
                    AddFoodView()
                }
                .onAppear {
                    vm.readStepsTakenToday()
                    vm.readCaloriesBurnedToday()
                }
            }
        } else {
            VStack {
                Text("Please Authorize Health!")
                    .font(.title3)

                Button {
                    vm.healthRequest()
                } label: {
                    Text("Authorize HealthKit")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(width: 320, height: 55)
                .background(Color(.orange))
                .cornerRadius(10)
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

    private func totalCaloriesToday() -> Double {
        var caloriesToday : Double = 0
        for item in food {
            if Calendar.current.isDateInToday(item.date!) {
                caloriesToday += item.calories
            }
        }
        print("Calories today: \(caloriesToday)")
        return caloriesToday
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
