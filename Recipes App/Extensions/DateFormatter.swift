//
//  DateFormatter.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 25.03.24.
//

import Foundation

extension DateFormatter {
    static func postDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return dateFormatter
    }
}
