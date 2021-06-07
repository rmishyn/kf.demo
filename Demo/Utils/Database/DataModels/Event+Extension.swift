//
//  Event+Extension.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import Foundation
import CoreData

extension Event: DBIdentifibleByIntId {
    var idInt: Int64? {
        get { id }
        set { id = newValue ?? 0 }
    }
}

// MARK: - DBRequestable

extension Event: DBRequestable {
    
    static var defaultSortDescriptors: [NSSortDescriptor] { [NSSortDescriptor(key: #keyPath(Event.startTime), ascending: true)] }
    
    static func remove(item: Event, context: NSManagedObjectContext) {
        context.delete(item)
    }
}

extension Event {
    
    /// Create or update (if exists) database `Event` item with data model
    /// - Parameters:
    ///     - model: Instrument ratings info data model containing an information which should be written into database
    ///     - context: Context used to perform changes
    /// - Returns: Item which was updated or created
    static func item(with model: EventModel, in context: NSManagedObjectContext) -> Event? {
        
        let item = Event.item(byId: Int64(model.id), in: context, create: true)!
        item.name = model.name
        item.startTime = model.startTime
        item.endTime = model.endTime
        item.images = model.images.joined(separator: "|||")
        
        item.venue = Venue.item(byId: Int64(model.venueId), in: context, create: false)

        return item
    }
    
}
