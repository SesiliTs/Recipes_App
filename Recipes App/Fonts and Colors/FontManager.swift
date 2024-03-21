//
//  Fonts.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 19.01.24.
//

import UIKit
import Firebase

extension Notification.Name {
    static let fontSettingsDidChange = Notification.Name("FontSettingsDidChange")
}

class FontManager {
    
    private var currentUser = Auth.auth().currentUser
    
    static let shared = FontManager()
    
    var bodyFontSmall = UIFont(name: "HelveticaNeueLTGEO-55ROMAN", size: 12.0)
    var bodyFont = UIFont(name: "HelveticaNeueLTGEO-55ROMAN", size: 14.0)
    var bodyFontMedium = UIFont(name: "HelveticaNeueLTGEO-65Medium", size: 16.0)
    var headlineFont = UIFont(name: "HelveticaNeueLTGEO-85Heavy", size: 20.0)
    
    private var userListener: ListenerRegistration?
    
    init() {
        checkLoggedUser()
    }
    
    private func checkLoggedUser() {
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
                    
                    self?.updateFonts(with: data)
                }
            } else {
                self?.setDefaultFonts()
            }
        }
    }
    
    private func updateFonts(with data: [String: Any]) {
        if let fontSize = data["fontSize"] as? CGFloat {
            self.bodyFont = UIFont(name: "HelveticaNeueLTGEO-55ROMAN", size: fontSize)
            self.bodyFontMedium = UIFont(name: "HelveticaNeueLTGEO-65Medium", size: fontSize + 2)
            self.headlineFont = UIFont(name: "HelveticaNeueLTGEO-85Heavy", size: fontSize + 6)
            NotificationCenter.default.post(name: .fontSettingsDidChange, object: nil)
        }
        
        if let isBold = data["boldText"] as? Bool, isBold {
            self.bodyFont = UIFont(name: "HelveticaNeueLTGEO-85Heavy", size: self.bodyFont?.pointSize ?? 14.0)
            self.bodyFontMedium = UIFont(name: "HelveticaNeueLTGEO-85Heavy", size: self.bodyFontMedium?.pointSize ?? 16.0)
            self.headlineFont = UIFont(name: "HelveticaNeueLTGEO-85Heavy", size: self.headlineFont?.pointSize ?? 20.0)
            NotificationCenter.default.post(name: .fontSettingsDidChange, object: nil)
        }
    }
    
    private func setDefaultFonts() {
        self.bodyFont = UIFont(name: "HelveticaNeueLTGEO-55ROMAN", size: 14.0)
        self.bodyFontMedium = UIFont(name: "HelveticaNeueLTGEO-65Medium", size: 16.0)
        self.headlineFont = UIFont(name: "HelveticaNeueLTGEO-85Heavy", size: 20.0)
        NotificationCenter.default.post(name: .fontSettingsDidChange, object: nil)
    }
    
    deinit {
        userListener?.remove()
    }
    
}
