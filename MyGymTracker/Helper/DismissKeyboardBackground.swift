//
//  DismissKeyboardBackground.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 18/03/23.
//

import SwiftUI

struct DismissKeyboardBackground: View {
    var body: some View {
        GeometryReader { _ in
            EmptyView()
        }
        .background(Color.clear)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
