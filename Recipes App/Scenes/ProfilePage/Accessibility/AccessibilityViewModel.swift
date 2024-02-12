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
    
    @Published var fontSize: CGFloat = 12
    @Published var isHighContrastEnabled = false
    @Published var isBoldTextEnabled = false
    
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
    
    func fetchAccessibilitySettings(completion: @escaping (AccessibilitySettings?, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "recipesApp", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        let ref = Firestore.firestore().collection("users").document(userId)
        ref.getDocument { documentSnapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let document = documentSnapshot, document.exists else {
                completion(nil, NSError(domain: "recipesApp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"]))
                return
            }
            guard let data = document.data() else {
                completion(nil, NSError(domain: "recipesApp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document data is empty"]))
                return
            }
            let settings = AccessibilitySettings(data: data)
            completion(settings, nil)
        }
    }
    
    private func changeSettings(with data: [String: Any]) {
        if data["fontSize"] is CGFloat {
            if let fontSize = data["fontSize"] as? CGFloat {
                self.fontSize = fontSize
            }
            
            if let highContrast = data["highContrast"] as? Bool {
                self.isHighContrastEnabled = highContrast
            }
            
            if let boldText = data["boldText"] as? Bool {
                self.isBoldTextEnabled = boldText
            }
        }
    }
    
}

struct AccessibilitySettings {
    let fontSize: CGFloat
    let highContrast: Bool
    let boldText: Bool
    
    init?(data: [String: Any]) {
        guard let fontSize = data["fontSize"] as? CGFloat,
              let highContrast = data["highContrast"] as? Bool,
              let boldText = data["boldText"] as? Bool else {
            return nil
        }
        self.fontSize = fontSize
        self.highContrast = highContrast
        self.boldText = boldText
    }
}
