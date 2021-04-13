//
//  String+.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//

import Foundation

extension String {
    
    /* Default DateFormat: yyyy-MM-dd */
    func toDate(with format: String? = nil) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = format ?? "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
}
