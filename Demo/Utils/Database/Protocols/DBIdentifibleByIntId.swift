//
//  DBIdentifibleByIntId.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import CoreData

/// Protocol to define database entities which use identifiers of `Int64` type
protocol DBIdentifibleByIntId: DBEntity {
    /// Entity identifier
    var idInt: Int64? {get set}
    /// Looks for database item by identifier and returns it if found. Can create new item if existing one doesn't exist and `create` is `true`
    /// - Parameters:
    ///     - id: Identifier to be used on search
    ///     - context: Context used to perform search inside it
    ///     - create: Flag determining if item should be crated if it was not found
    /// - Returns: Item which was found or created
    static func item(byId id: Int64, in context: NSManagedObjectContext, create: Bool) -> Self?
    /// Save dictionary data as database item (update existing or create new one)
    /// - Parameters:
    ///     - incoming: Dictionary containing an identifier and other information used to update/create database item
    ///     - context: Context used to perform changes
    static func save(item incoming: [String : Any], context: NSManagedObjectContext) -> Self?
    /// Find database item by identifier and remove it from database if found
    /// - Parameters:
    ///     - id: Identifier to be used on search
    ///     - context: Context used to perform search inside it
    static func remove(byId id: Int64, in context: NSManagedObjectContext)
}

extension DBIdentifibleByIntId {
    
    static func item(byId id: Int64, in context: NSManagedObjectContext, create: Bool) -> Self? {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.predicate = NSPredicate(format: "\(Mapping.id) = %lld", id)
        request.returnsObjectsAsFaults = false
        var result:Self? = nil
        do {
            result = try context.fetch(request).first
        } catch {
            dprint(category: .error, "Failed to fetch \(error)")
        }
        if result == nil && create {
            if let res = Self.create(in: context) {
                res.idInt = id
                result = res
            }
        }
        return result
    }
    
    static func save(item incoming: [String : Any], context: NSManagedObjectContext) -> Self? {
        var result:Self?
        let _incoming = modify(incoming: incoming)
        
        if let id = _incoming[Mapping.id] as? Int64 {
            result = item(byId: id, in: context, create: true)
        } else if let idstr = incoming[Mapping.id] as? String,
            let id = Int64(idstr) {
            result = item(byId: id, in: context, create: true)
        }
        result?.map(_incoming, in:context)
        return result
    }
    
    static func remove(byId id: Int64, in context: NSManagedObjectContext) {
        if let item = item(byId: id, in: context, create: false) {
            context.delete(item)
        }
    }
}
