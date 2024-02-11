//
//  Fonts.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 19.01.24.
//

import UIKit
import Firebase

class FontManager {
    
    private var currentUser = Auth.auth().currentUser
    
    static let shared = FontManager()

    var bodyFont = UIFont(name: "HelveticaNeueLTGEO-55ROMAN", size: 12.0)
    var bodyFontMedium = UIFont(name: "HelveticaNeueLTGEO-65Medium", size: 14.0)
    var headlineFont = UIFont(name: "HelveticaNeueLTGEO-85Heavy", size: 18.0)

    init() {
        checkLoggedUser()
    }
    
    private func checkLoggedUser() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if let _ = user {
                guard let currentUser = self?.currentUser else { return }
                let userId = currentUser.uid
                let ref = Firestore.firestore().collection("users").document(userId)
                
                ref.getDocument { (document, error) in
                    if let error = error {
                        print("Error getting user document: \(error)")
                    } else {
                        if let fontSize = document?.data()?["fontSize"] as? CGFloat {
                            self?.bodyFont = UIFont(name: "HelveticaNeueLTGEO-55ROMAN", size: fontSize)
                            self?.bodyFontMedium = UIFont(name: "HelveticaNeueLTGEO-65Medium", size: fontSize)
                            self?.headlineFont = UIFont(name: "HelveticaNeueLTGEO-85Heavy", size: fontSize)
                        }
                        
                        if let isBold = document?.data()?["boldText"] as? Bool {
                            if isBold {
                                self?.bodyFont = UIFont(name: "HelveticaNeueLTGEO-85Heavy", size: 12.0)
                                self?.bodyFontMedium = UIFont(name: "HelveticaNeueLTGEO-85Heavy", size: 14.0)
                                self?.headlineFont = UIFont(name: "HelveticaNeueLTGEO-85Heavy", size: 18.0)
                            }
                        }
                    }
                }
                
            } else {
                self?.bodyFont = UIFont(name: "HelveticaNeueLTGEO-55ROMAN", size: 12.0)
                self?.bodyFontMedium = UIFont(name: "HelveticaNeueLTGEO-65Medium", size: 14.0)
                self?.headlineFont = UIFont(name: "HelveticaNeueLTGEO-85Heavy", size: 18.0)
            }
        }
    }

}
