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

    var body: some View {
          VStack {
              ZStack {
                  Circle()
                      .fill(.gray)
                      .frame(width: 80, height: 80)
                  VStack (spacing: 3){
                      Image(systemName: "figure.walk")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 35, height: 35)
                          .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
                          .colorInvert()
                      Text("1000")
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
