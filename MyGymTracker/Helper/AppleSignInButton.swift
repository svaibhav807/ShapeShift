//
//  AppleSignInButton.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 18/03/23.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInButton: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    @Binding var authorizationResult: Result<ASAuthorization, Error>?

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: colorScheme == .dark ? .white : .black)
        button.addTarget(context.coordinator, action: #selector(Coordinator.signInTapped), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ASAuthorizationControllerDelegate {
        var parent: AppleSignInButton

        init(_ parent: AppleSignInButton) {
            self.parent = parent
        }

        @objc func signInTapped() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            parent.authorizationResult = .failure(error)
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            parent.authorizationResult = .success(authorization)
        }
    }
}
//
//struct AppleSignInButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AppleSignInButton()
//    }
//}
