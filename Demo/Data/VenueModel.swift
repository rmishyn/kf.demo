//
//  VenueModel.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation
import ObjectMapper

class VenueModel: Mappable {
    
    let id: Int
    let name: String
    
    // MARK: Mappable
    
    required init?(map: Map) {
        let json = map.JSON
        guard let id = json[Mapping.Venue.id] as? Int,
              let name = json[Mapping.Venue.name] as? String else {
            return nil
        }
        (self.id, self.name) = (id, name)
    }
    
    func mapping(map: Map) {
        id                  >>> map[Mapping.Venue.id]
        name                >>> map[Mapping.Venue.name]
    }
}
