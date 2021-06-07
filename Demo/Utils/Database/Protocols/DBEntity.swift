//
//  DBEntity.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import CoreData

/// Protocol describing common requirements to used database objects
protocol DBEntity: NSManagedObject {
    /// Name of database entity
    static var entityName: String {get}
    /// Method to update a database object with dictionary of properties
    /// - Parameter incoming: Dictionary of properties to be applied to database object
    /// - Parameter context: Context used to perform changes
    func map(_ incoming:[String:Any], in context:NSManagedObjectContext)
    /// Create new instance of database entity and add it to database
    /// - Parameter context: Context used to perform changes
    static func create(in context: NSManagedObjectContext) -> Self?
    /// Modify data dictionary (parsed JSON) structure to make dictionary available for import
    /// - Parameter incoming: Original properties list
    /// - Returns: Modified properties list
    static func modify(incoming:[String:Any]) -> [String:Any]
}

extension DBEntity {
    
    static var entityName: String { typeName }
    
    func map(_ incoming: [String : Any], in context: NSManagedObjectContext) {}
    
    static func create(in context: NSManagedObjectContext) -> Self? {
        guard let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: context), let item = NSManagedObject(entity: entity, insertInto: context) as? Self else { return nil }
        return item
    }
    
    static func modify(incoming: [String : Any]) -> [String : Any] { incoming }
}
