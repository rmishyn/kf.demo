//
//  DateFormatter.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

extension DateFormatter {
    
    static let iso8601DateFormatter = DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZZ", locale: "en_US_POSIX")
    
}
