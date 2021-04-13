//
//  Date+.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//

import Foundation

extension Date {
    
    /* Default DateFormat: yyyy MMM. d */
    func toDateString(with format: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = format ?? "yyyy MMM. d"
        return dateFormatter.string(from: self)
    }
}
