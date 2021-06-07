//
//  DBRequestable.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import CoreData

/// Protocol describing database entities functionality for using with DBObjectService
protocol DBRequestable {
    associatedtype Entity: NSManagedObject
    /// Predicate used to fetch available only entities
    static var defaultAvailableObjectsRequestPredicate: NSPredicate? {get}
    /// Sort descriptors used to sort fetch results by defaults
    static var defaultSortDescriptors: [NSSortDescriptor] {get}
    /// Prepare `NSFetchRequest` to fetch available only entities fetching. Fetch results can be limited with addional pedicates (combined with `defaultAvailableObjectsRequestPredicate` using `AND` rule)
    /// - Parameter predicates: Additional predicates which should be combined with `defaultAvailableObjectsRequestPredicate`
    /// - Parameter sortDescriptors: List of sort descriptors to replace `defaultSortDescriptors`
    static func availableObjectsRequest(predicates: [NSPredicate]?, sortDescriptors: [NSSortDescriptor]?) -> NSFetchRequest<Entity>
    /// Remove single entity from database. Used to support additional logic before data removing
    static func remove(item: Entity, context: NSManagedObjectContext)
}

extension DBRequestable {
    
    static func availableObjectsRequest(predicates: [NSPredicate]? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<Entity> {
        let entityName = Entity.entityName
        let request = NSFetchRequest<Entity>(entityName: entityName)
        var _predicates:[NSPredicate] = []
        if let _defaultAvailableObjectsRequestPredicate = defaultAvailableObjectsRequestPredicate {
            _predicates.append(_defaultAvailableObjectsRequestPredicate)
        }
        if let _ = predicates?.first {
            _predicates.append(contentsOf: predicates!)
        }
        request.predicate = _predicates.isEmpty ? nil : NSCompoundPredicate(andPredicateWithSubpredicates: _predicates)
        request.sortDescriptors = ((sortDescriptors == nil) || (sortDescriptors!.isEmpty)) ? defaultSortDescriptors : sortDescriptors
        return request
    }
    
    static var defaultAvailableObjectsRequestPredicate: NSPredicate? { nil }
}
