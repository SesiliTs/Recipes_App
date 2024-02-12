//
//  ColorManager.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 19.01.24.
//

import UIKit
import Firebase

extension Notification.Name {
    static let colorSettingsDidChange = Notification.Name("ColorSettingsDidChange")
}

class ColorManager {
    static let shared = ColorManager()

    var backgroundColor: UIColor = UIColor(hexString: "#F9F9F9")
    var primaryColor: UIColor = UIColor(hexString: "#F55A51")
    var textGrayColor: UIColor = UIColor(hexString: "#666666")
    var textLightGray: UIColor = UIColor(hexString: "#BDBDBD")
    var borderColor: UIColor = UIColor(.clear)

    private var userListener: ListenerRegistration?

    init() {
        checkUserSettings()
    }

    private func checkUserSettings() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if let user = user {
                let userId = user.uid
                let ref = Firestore.firestore().collection("users").document(userId)

                self?.userListener = ref.addSnapshotListener { [weak self] (documentSnapshot, error) in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                    }

                    self?.updateColors(with: data)
                }
            } else {
                self?.setDefaultColors()
            }
        }
    }

    private func updateColors(with data: [String: Any]) {
        if let highContrast = data["highContrast"] as? Bool, highContrast {
            backgroundColor = .white
            primaryColor = UIColor(hexString: "#F55A51")
            textGrayColor = .black
            textLightGray = .darkGray
            borderColor = .black
            NotificationCenter.default.post(name: .colorSettingsDidChange, object: nil)
        } else {
            setDefaultColors()
        }
    }

    private func setDefaultColors() {
        backgroundColor = UIColor(hexString: "#F9F9F9")
        primaryColor = UIColor(hexString: "#F55A51")
        textGrayColor = UIColor(hexString: "#666666")
        textLightGray = UIColor(hexString: "#BDBDBD")
        borderColor = UIColor(.clear)
        NotificationCenter.default.post(name: .colorSettingsDidChange, object: nil)
    }

    deinit {
        userListener?.remove()
    }
}
