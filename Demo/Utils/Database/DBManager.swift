//
//  DBManager.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation
import CoreData

class DBManager {
    
    // MARK: Properties
    
    /// Contains a link to single modification context. Used to prevent re-creation each time when requested
    private var _writingContext: NSManagedObjectContext? = nil
    
    // MARK: Core Data stack
    
    /**
     The persistent container for the application.
     
     This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "storage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("DBManager: Unresolved error \(error), \(error.userInfo)")
            } else{
                dprint("DBManager: Did load persistent store: \(storeDescription)")
            }
        })
        return container
    }()
    
    /// List of services which should perform related DB objects removing on database cleaning
    private var resetableServices: [ResetableObjectService] {
        [eventsService]
    }
    
    // MARK: Lifecycle
    
    /// Initializer
    init() {
        //removeStorage()
        
        let _ = persistentContainer
        readingContext.automaticallyMergesChangesFromParent = true
        
        subscribeNotifications()
    }
    
    // MARK: Private
    
    /// Remove database file from local storage
    private func removeStorage() {
        let filename = "storage.sqlite"
        let url = NSPersistentContainer.defaultDirectoryURL()
        let fileManager = FileManager.default
        guard let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey]) else { return }
        for element in enumerator {
            guard let url = element as? URL else { continue }
            dprint(category: .db, "element: \(element)")
            guard url.lastPathComponent.hasPrefix(filename) else { continue } // .sqlite, .sqlite-shm, .sqlite-wal
            dprint(category: .db, "DBManager: try to remove db file: \(url)")
            do {
                try fileManager.removeItem(at: url)
            } catch {
                dprint(category: .error, "DBManager: Did fail to remove '\(element)': error=\(error)")
            }
        }
    }
    
    /// Removes stored data from database (using services enumerated in `resetableServices`
    /// - Parameter completion: Closure called after changes are completed
    private func clearStorage(completion: @escaping VoidResultCompletion) {
        performChanges({ [weak self] (context) in
            guard let self = self else { return false }
            for service in self.resetableServices {
                service.resetAll(context: context)
            }
            return true
        }, completion: completion)
    }
    
    /// Subscribe to notifications about database content changes
    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onContextObjectsDidChange(notification:)), name: .NSManagedObjectContextObjectsDidChange, object: nil)
    }
}

// MARK: - Notifications

extension DBManager {
    
    /// Process notification about database content changes
    /// - Parameter notification: Received notification. Contains info about database content changes
    @objc func onContextObjectsDidChange(notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext, context == readingContext, let userInfo = notification.userInfo else { return }
        let _ = userInfo    // to hide 'unused' warning
        /* Analyze 'userInfo' with keys (as? Set<NSManagedObject>)
             NSUpdatedObjectsKey
             NSInsertedObjectsKey
             NSRefreshedObjectsKey
             NSDeletedObjectsKey
             NSInvalidatedObjectsKey
             NSInvalidatedAllObjectsKey
         */
    }
}

// MARK: - DBManagement
    
extension DBManager: DBManagement {

    var writingContext: NSManagedObjectContext {
        if _writingContext == nil { _writingContext = persistentContainer.newBackgroundContext() }
        return _writingContext!
    }
    
    var readingContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    var temporaryContext: NSManagedObjectContext { persistentContainer.newBackgroundContext() }
    var temporaryReadingContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = readingContext
        return context
    }
    
    var eventsService: DBObjectService<Event> { DBObjectService<Event>(dbManager: self) }
    
    func performChanges(_ changes:@escaping ((NSManagedObjectContext)->Bool), completion: VoidResultCompletion?) {
        let context = self.writingContext
        context.perform {
            let res = changes(context)
            if res {
                context.saveIfHasChanges(completion: completion)
            } else{
                if context.hasChanges {
                    context.rollback()
                }
                DispatchQueue.main.async { completion?(.success(())) }
            }
        }
    }
    
    func performRead(_ reading: @escaping (NSManagedObjectContext)->Void, completion: VoidCompletion?)  {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = readingContext
        context.perform {
            reading(context)
            if context.hasChanges {
                context.rollback()
            }
            completion?()
        }
    }
    
    func clean(completion: @escaping VoidResultCompletion) {
        clearStorage(completion: completion)
    }
}
