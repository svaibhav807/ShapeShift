//
//  CustomTextField.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 18/03/23.
//

import SwiftUI


struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)

            TextField(title, text: $text)
                .keyboardType(keyboardType)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    @State static private var text: String = ""

    static var previews: some View {
        CustomTextField(title: "Sample Title", text: $text, keyboardType: .default)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
