//
//  Mapping.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

struct Mapping {
    
    static let id = "id"
    
    struct Venue {
        static let id = "venueId"
        static let name = "venueName"
    }
    
    struct Event {
        static let id = "id"
        static let venueId = "venueId"
        static let name = "name"
        static let startTime = "startTime"
        static let endTime = "endTime"
        static let images = "images"
    }
}
