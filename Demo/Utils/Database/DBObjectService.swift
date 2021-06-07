//
//  DBObjectService.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import CoreData

/// Interface containing requirement to support removing data from database
protocol ResetableObjectService {
    func resetAll(context: NSManagedObjectContext)
}

/// Service providing a functionality to operate with single database Entity assigned via `ObjectType`
struct DBObjectService<ObjectType>: ResetableObjectService where ObjectType: NSManagedObject & DBRequestable {
    
    /// Access to database manager which is assigned to this service
    private(set) weak var dbManager: DBManagement!
    /// Getter providing access to new writing context
    var temporaryContext: NSManagedObjectContext { dbManager.temporaryContext }
    /// Getter providing access to new reading context
    var temporaryReadingContext: NSManagedObjectContext { dbManager.temporaryReadingContext }
    /// Getter providing access to common reading context
    var regularReadingContext: NSManagedObjectContext { dbManager.readingContext }
    
    // MARK: Lifecycle
    
    /// Initializer
    /// - Parameter dbManager: Database manager which should be assigned to this service
    init(dbManager:DBManagement) {
        self.dbManager = dbManager
    }
    
    // MARK: Public
    
    /// Performs writing operations using `writingContext`, saves them is `changes` returns `true` and then calls `completion` (asynchronously, using main thread)
    /// - Parameter changes: Closure containing instructions which performs changes. Returns `true` if changes must be saved or `false` if changes should be reverted
    /// - Parameter completion: Closure called asynchronously after `changes` are performed
    func performChanges(_ changes:@escaping ((NSManagedObjectContext)->Bool), completion: VoidResultCompletion?) {
        dbManager.performChanges(changes, completion: completion)
    }
    
    /// Performs reading operations using `readingContext` and then calls `completion`
    /// - Parameter reading: Closure containing reading instructions
    /// - Parameter completion: Closure called synchronously after `reading` is finished
    func performRead(_ reading:@escaping (NSManagedObjectContext)->Void, completion: VoidCompletion? = nil)  {
        dbManager.performRead(reading, completion: completion)
    }
    
    /// Prepare a list of database objects (of assigned entity) filtered using `predicates`
    /// - Parameter predicate: list of predicates used to limit results
    /// - Returns: Array of database objects which conforms to predicates
    func filteredObjects(predicates: [NSPredicate]?, context: NSManagedObjectContext? = nil) -> [ObjectType] {
        let _context: NSManagedObjectContext = context ?? dbManager.readingContext
        var items: [ObjectType]?
        let request = ObjectType.availableObjectsRequest(predicates: predicates)
        do {
            items = try _context.fetch(request) as? [ObjectType]
        } catch {
            dprint(category: .error, "Failed to fetch '\(ObjectType.entityName)': \(error)")
        }
        return items ?? []
    }
    
    /// Prepare a list of database objects (filtered only by Entity's `availableObjectsRequest`)
    func allObjects(context: NSManagedObjectContext? = nil) -> [ObjectType] { filteredObjects(predicates: nil, context: context) }
    
    /// Save info from dictionary to object of Entity
    /// - Parameter itemInfo: Dictionary containing data to be saved into Entity object
    /// - Parameter context: Context used to save changes
    /// - Parameter processing: Closure used to apply additional changes to object after data saved
    /// - Parameter completion: Closure called after changes are saved
    func save(itemInfo:[String:Any],
              context:NSManagedObjectContext?,
              processing: ((ObjectType)->())? = nil,
              completion:DBObjectIdentifierResultCompletion?) {
        guard ObjectType.self is DBIdentifibleByIntId.Type || ObjectType.self is DBIdentifibleByStringId.Type else {
            completion?(.failure(NSError(domain: .database, errorCode: .incorrectIdentifierType)))
            return
        }
        let context = context ?? dbManager.writingContext
        context.perform {
            var id: DBObjectIdentifier? = nil
            if let ObjectTypeIdentifible = ObjectType.self as? DBIdentifibleByIntId.Type,
               let item = ObjectTypeIdentifible.save(item: itemInfo, context: context) {
                id = item.idInt
                processing?(item as! ObjectType)
            } else if let ObjectTypeIdentifible = ObjectType.self as? DBIdentifibleByStringId.Type,
                      let item = ObjectTypeIdentifible.save(item: itemInfo, context: context) {
                id = item.idStr
                processing?(item as! ObjectType)
            }
            
            context.saveIfHasChanges(completion: { (result) in
                switch result {
                case .failure(let error):
                    dprint(category: .error, "Failed to save context: \(error)")
                    DispatchQueue.main.async { completion?(.failure(error)) }
                case .success: DispatchQueue.main.async { completion?(.success(id)) }
                }
            })
        }
    }
    
    /// Save info from array of dictionaries to object of Entity
    /// - Parameter itemsInfo: Array of dictionaries containing data to be saved into Entity object
    /// - Parameter context: Context used to save changes
    /// - Parameter processing: Closure used to apply additional changes to object after each object data saved
    /// - Parameter completion: Closure called after changes are saved
    func save(itemsInfo: [[String:Any]],
              context: NSManagedObjectContext?,
              processing: ((Int,ObjectType)->())? = nil,
              finally: ((_ ids: [DBObjectIdentifier], NSManagedObjectContext)->())? = nil,
              completion: DBObjectIdentifiersResultCompletion?) {
        guard ObjectType.self is DBIdentifibleByIntId.Type || ObjectType.self is DBIdentifibleByStringId.Type else {
            completion?(.failure(NSError(domain: .database, errorCode: .incorrectIdentifierType)))
            return
        }
        let context = context ?? dbManager.writingContext
        context.perform {
            var ids: [DBObjectIdentifier] = []
            for (index,itemInfo) in itemsInfo.enumerated() {
                if let ObjectTypeIdentifible = ObjectType.self as? DBIdentifibleByIntId.Type,
                   let item = ObjectTypeIdentifible.save(item: itemInfo, context: context),
                   let id = item.idInt {
                    ids.append(id)
                    processing?(index,item as! ObjectType)
                } else if let ObjectTypeIdentifible = ObjectType.self as? DBIdentifibleByStringId.Type,
                          let item = ObjectTypeIdentifible.save(item: itemInfo, context: context),
                          let id = item.idStr {
                    ids.append(id)
                    processing?(index,item as! ObjectType)
                } else {
                    continue
                }
            }
            finally?(ids, context)
            context.saveIfHasChanges(completion: { (result) in
                switch result {
                case .failure(let error):
                    dprint(category: .error, "Failed to save context: \(error)")
                    DispatchQueue.main.async { completion?(.failure(error)) }
                case .success:
                    DispatchQueue.main.async { completion?(.success(ids)) }
                }
            })
        }
    }
    
    /// Find object by `id` and aply changes from `processing` to it
    /// - Parameter id: oject identifier
    /// - Parameter context: Context used to perform changes
    /// - Parameter processing: Closure used to apply changes to object
    /// - Parameter completion: Closure called after changes are completed and saved
    func update(byId id:Any, context: NSManagedObjectContext? = nil, processing: @escaping (ObjectType, NSManagedObjectContext)->(), completion: VoidResultCompletion?) {
        let _context = context ?? dbManager.writingContext
        let _completion: VoidResultCompletion?  = (completion != nil) ? { (result) in  DispatchQueue.main.async { completion!(result) } } : nil
        _context.perform {
            var item: ObjectType? = nil
            if let ObjectTypeIdentifible = ObjectType.self as? DBIdentifibleByIntId.Type {
                guard let id = id as? Int64 else {
                    let error = NSError(domain: .database, errorCode: ErrorCode.incorrectIdentifierType)
                    _completion?(.failure(error))
                    return
                }
                item = (ObjectTypeIdentifible.item(byId: id, in: _context, create: false) as! ObjectType)
            } else if let ObjectTypeIdentifible = ObjectType.self as? DBIdentifibleByStringId.Type {
                guard let id = id as? String else {
                    let error = NSError(domain: .database, errorCode: ErrorCode.incorrectIdentifierType)
                    _completion?(.failure(error))
                    return
                }
                item = (ObjectTypeIdentifible.item(byId: id, in: _context, create: false) as! ObjectType)
            }
            guard let _item = item else {
                let error = NSError(domain: .database, errorCode: ErrorCode.objectNotFound)
                _completion?(.failure(error));
                return
            }
            processing(_item, _context)
            _context.saveIfHasChanges(completion: _completion)
        }
    }
    
    /// Remove object from database
    /// - Parameter id: oject identifier
    /// - Parameter context: Context used to perform changes
    /// - Parameter completion: Closure called after object removed and context saved
    func remove(byId id: Any, context: NSManagedObjectContext? = nil, completion: VoidResultCompletion?) {
        let _context = context ?? dbManager.writingContext
        let _completion: VoidResultCompletion?  = (completion != nil) ? { (result) in  DispatchQueue.main.async { completion!(result) } } : nil
        
        _context.perform {
            if let ObjectTypeIdentifible = ObjectType.self as? DBIdentifibleByIntId.Type {
                guard let id = id as? Int64 else {
                    let error = NSError(domain: .database, errorCode: ErrorCode.incorrectIdentifierType)
                    _completion?(.failure(error))
                    return
                }
                ObjectTypeIdentifible.remove(byId: id, in: _context)
            } else if let ObjectTypeIdentifible = ObjectType.self as? DBIdentifibleByStringId.Type {
                guard let id = id as? String else {
                    let error = NSError(domain: .database, errorCode: ErrorCode.incorrectIdentifierType)
                    _completion?(.failure(error))
                    return
                }
                ObjectTypeIdentifible.remove(byId: id, in: _context)
            }
            _context.saveIfHasChanges(completion: _completion)
        }
    }
    
    /**
     Remove all objects (assigned Entity) from database synchronously with conditions
     
     Method doesn't save a changes to context. So, context should be saved separately
     - Parameter predicate: predicate to limit objects which will be removed
     - Parameter ids: Array of identifiers to be excluded from removed objects list
     - Parameter context: Context used to perform changes
     */
    func removeAll(filterWith predicate: NSPredicate? = nil, exceptIds ids: [AnyHashable], context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<ObjectType>(entityName: ObjectType.entityName)
        
        var andPredicates: [NSPredicate] = []
        if !ids.isEmpty { andPredicates.append( NSPredicate(format: "NOT(id in %@)", ids) ) }
        if let predicate = predicate { andPredicates.append(predicate) }
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: andPredicates)
        
        do {
            let result = try fetchRequest.execute()
            for object in result {
                ObjectType.remove(item: object as! ObjectType.Entity, context: context)
            }
        }catch{
            dprint(category: .error, "Cannot fetch '\(ObjectType.entityName)': \(error)")
        }
    }
    
    /**
     Remove all objects (assigned Entity) from database synchronously
     
     Method doesn't save a changes to context. So, context should be saved separately.
     Also, no additional logic is performed from `Entity.remove` (to do it faster)
     - Parameter context: Context used to perform changes
     */
    func resetAll(context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<ObjectType>(entityName: ObjectType.entityName)
        do {
            let result = try fetchRequest.execute()
            for object in result {
                context.delete(object)
            }
        }catch{
            dprint(category: .error, "Cannot fetch '\(ObjectType.entityName)': \(error)")
        }
    }
    
    /**
     Create new fetched results controller
     - Parameter context: Context used to fetch data
     - Parameter sectionNameKeyPath: A key path on result objects that returns the section name. Pass nil to indicate that the controller should generate a single section
     - Parameter predicates: Array of predicates used to limit fetched objects
     - Parameter sortDescriptors: Array of sort descriptors used to sort fetched objects
     - Parameter limit: The fetch limit of the fetch request
     - Returns: Created and configured fetched results controller
     */
    func frc(context: NSManagedObjectContext? = nil,
             sectionNameKeyPath: String? = nil,
             predicates: [NSPredicate]? = nil,
             sortDescriptors: [NSSortDescriptor]? = nil,
             limit: Int? = nil,
             batchSize: Int? = nil) -> NSFetchedResultsController<ObjectType> {
        let _context = context ?? dbManager.readingContext
        let request = ObjectType.availableObjectsRequest(predicates: predicates, sortDescriptors: sortDescriptors) as! NSFetchRequest<ObjectType>
        let frc = NSFetchedResultsController<ObjectType>(fetchRequest: request, managedObjectContext: _context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        if let limit = limit {
            request.fetchLimit = limit
        }
        if let batchSize = batchSize {
            request.fetchBatchSize = batchSize
        }
        return frc
    }
}
