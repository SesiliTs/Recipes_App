//
//  OnboardingModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 28.03.24.
//

import Foundation

struct OnboardingModel {
    let image: String
    let title: String
    let description: String
}

let onboardingPages = [
    OnboardingModel(image: "onboarding-1", title: "რა ვჭამო?".uppercased(), description: "დაათვალიერე რეკომენდაციები და მოძებნე სასურველი კერძი"),
    OnboardingModel(image: "onboarding-2", title: "იმ პიცის რეცეპტს ვეღარ ვპოულობ".uppercased(), description: "შეინახე შენი საყვარელი რეცეპტი და მიუბრუნდი როცა გინდა"),
    OnboardingModel(image: "onboarding-3", title: "სად არის ჩემი რეცეპტების წიგნი?".uppercased(), description: "რვეულებში ძებნა რომ აღარ დაგჭირდეს, ატვირთე შენი რეცეპტები და მოამზადე ნებისმიერ დროს"),
    OnboardingModel(image: "onboarding-4", title: "რჩევა მჭირდება".uppercased(), description: "დასვი კითხვა, მიიღე რჩევები და სხვებსაც გაუზიარე შენი კულინარიული გამოცდილება")
]
