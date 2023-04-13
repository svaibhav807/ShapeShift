//
//  HomeCombinedView.swift
//  MyGymTracker
//
//  Created by Vaibhav on 08/04/23.
//

import SwiftUI

struct HomeCombinedView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            Picker("Tabs", selection: $selectedTab) {
                Text("Food List").tag(0)
                Text("Exercise List").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            if selectedTab == 0 {
                FoodListView()
            } else if selectedTab == 1 {
                ExerciseListView()
            }
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

struct HomeCombinedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCombinedView()
    }
}
