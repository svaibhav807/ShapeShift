//
//  ContentView.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 09/01/23.
//

import SwiftUI
//import AuthenticationServices

struct ContentView: View {
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn: Bool = false
    @Environment (\.managedObjectContext) var manageObjectContext
    @EnvironmentObject var vm: HealthKitViewModel
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food: FetchedResults<Food>
//    @State private var appleAuthorizationResult: Result<ASAuthorization, Error>?

    @State private var showingAddView = false

    var body: some View {


//        if vm.isAuthorized {
        
            NavigationView {
                VStack(alignment: .leading, spacing: 5) {

                    HStack(alignment: .center, spacing: 5) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Calories consumed: \(Int(totalCaloriesToday())) KCal (Today)")
                                .foregroundColor(.gray)
                            Text("Calories burned: \(vm.userActiveCaloriesBurned) KCal (Today)")
                                .foregroundColor(.gray)
                            let (isInCalorieDeficit, calories) = vm.isInCalorieDefecit(caloriesConsumed: totalCaloriesToday())
                            Text("\(calories ?? 0) KCal (Today)")
                                .foregroundColor(isInCalorieDeficit ?? true ? .green : .red)
                        }
                        Spacer()
                        StepsView(image: Image(systemName: "figure.walk"))
                    }
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))

                    HomeCombinedView()
                        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))

                }
                .navigationTitle("MyGymTracker")
                .onAppear {
                    vm.readStepsTakenToday()
                    vm.readCaloriesBurnedToday()
//                    Task {
//                       await vm.readWorkouts()
//                    }
                }
            }
//        } else {
//            VStack {
//                Text("Please Authorize Health!")
//                    .font(.title3)
//
//                Button {
//                    vm.healthRequest()
//                } label: {
//                    Text("Authorize HealthKit")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                }
//                .frame(width: 320, height: 55)
//                .background(Color(.orange))
//                .cornerRadius(10)
//            }
//        }

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


extension Notification.Name {
    static let signInWithApple = Notification.Name("signInWithApple")
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(HealthKitViewModel())
    }
}
