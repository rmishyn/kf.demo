//
//  Venue+Extension.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import Foundation
import CoreData

extension Venue: DBIdentifibleByIntId {
    var idInt: Int64? {
        get { id }
        set { id = newValue ?? 0 }
    }
}

extension Venue {
    
    /// Create or update (if exists) database `Event` item with data model
    /// - Parameters:
    ///     - model: Instrument ratings info data model containing an information which should be written into database
    ///     - context: Context used to perform changes
    /// - Returns: Item which was updated or created
    static func item(with model: VenueModel, in context: NSManagedObjectContext) -> Venue? {
        
        let item = Venue.item(byId: Int64(model.id), in: context, create: true)!
        item.name = model.name

        return item
    }
    
}
