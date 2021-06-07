//
//  EventModel.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation
import ObjectMapper

class EventModel: Mappable {
    
    let id: Int
    let venueId: Int
    let images: [String]
    let name: String
    let startTime: Date
    let endTime: Date
    
    // MARK: Mappable
    
    required init?(map: Map) {
        let json = map.JSON
        let dateFormatter = DateFormatter.iso8601DateFormatter
        guard let id = json[Mapping.Event.id] as? Int,
              let venueId = json[Mapping.Event.venueId] as? Int,
              let name = json[Mapping.Event.name] as? String,
              let startTimeStr = json[Mapping.Event.startTime] as? String,
              let startTime = dateFormatter.date(from: startTimeStr),
              let endTimeStr = json[Mapping.Event.endTime] as? String,
              let endTime = dateFormatter.date(from: endTimeStr) else {
            return nil
        }
        self.images = (json[Mapping.Event.images] as? [String]) ?? []
        (self.id, self.venueId, self.name) = (id, venueId, name)
        (self.startTime, self.endTime) = (startTime, endTime)
    }
    
    func mapping(map: Map) {
        let dateTransform = ISO8601DateTransform()
        id              >>> map[Mapping.Event.id]
        venueId         >>> map[Mapping.Event.venueId]
        name            >>> map[Mapping.Event.name]
        startTime       >>> (map[Mapping.Event.startTime], dateTransform)
        endTime         >>> (map[Mapping.Event.endTime], dateTransform)
        images          >>> map[Mapping.Event.images]
    }
}
