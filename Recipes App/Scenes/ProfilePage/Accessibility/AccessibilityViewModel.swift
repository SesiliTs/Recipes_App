//
//  AccessibilityViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 11.02.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AccessibilityViewModel: ObservableObject {
    
    func updateAccessibilitySettings(highContrast: Bool, boldText: Bool, fontSize: CGFloat) async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userReference = Firestore.firestore().collection("users").document(userId)
        try await userReference.updateData([
            "highContrast": highContrast,
            "boldText": boldText,
            "fontSize": fontSize
        ])
        self.objectWillChange.send()
    }
    
}
