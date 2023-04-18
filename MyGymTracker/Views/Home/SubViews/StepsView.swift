//
//  StepsView.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 17/03/23.
//

import SwiftUI

struct StepsView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var vm: HealthKitViewModel
    let image: Image

    private let expectedDailyValue: Double = 1000
    
    private var currentGradient: LinearGradient {
        let progress = vm.userStepCount / expectedDailyValue
        
        if progress >= 0 && progress <= 0.25 {
            return LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
        } else if progress > 0.25 && progress <= 0.75 {
            return LinearGradient(gradient: Gradient(colors: [Color.blue, Color.neonBlue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
        } else {
            return LinearGradient(gradient: Gradient(colors: [Color.green, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    var body: some View {
          VStack {
              ZStack {
                  Circle()
                      .fill(currentGradient)
                      .frame(width: 80, height: 80)
                  VStack (spacing: 3){
                      Image(systemName: "figure.walk")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 35, height: 35)
                          .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
                          .colorInvert()
                      Text(String(vm.userStepCount))
                          .font(.system(size: 16, weight: .semibold))
                          .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                          .foregroundColor(colorScheme == .light ? .white : .black)
                  }
                  .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
              }
          }
      }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView(image: Image(systemName: "figure.walk"))
            .environmentObject(HealthKitViewModel())
    }
}

extension Color {
    static let neonBlue = Color(red: 77 / 255, green: 218 / 255, blue: 255 / 255)
}
