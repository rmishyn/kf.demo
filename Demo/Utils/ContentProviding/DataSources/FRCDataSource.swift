//
//  FRCDataSource.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import CoreData

/// Data source providing an access to database content
class FRCDataSource<Entity>: NSObject, NSFetchedResultsControllerDelegate where Entity: NSManagedObject & DBRequestable & DBNameFilterable {
    
    /// Service providing an access to single database table (Entity)
    private let dbService: DBObjectService<Entity>
    
    /// Fetched results controller used to fetch data from database and listen for changes
    private var frc: NSFetchedResultsController<Entity>? {
        willSet { frc?.delegate = nil }
    }
    /// Database context used to access database content
    private var context: NSManagedObjectContext?
    /// Section name. Used if fetched data should be separated by sections
    private var sectionNameKeyPath: String?
    /// Collection of predicates used to limit fetched content
    private var predicates: [NSPredicate]?
    /// Collection of sort descriptors used to sort fetched content
    private var sortDescriptors: [NSSortDescriptor]?
    /// Value used to limit amount of fetched objects
    private var limit: Int?
    /// The batch size of the objects specified in the fetch request
    private var batchSize: Int?
    /// Delegate for sending an events about data changes
    weak var delegate: DataProviderDelegate?
    /// Delegate for sending an events about data changes inside single changes transaction
    private var changesDelegate: DataProviderDelegate?
    
    // MARK: Public methods
    
    /// Initializer
    /// - Parameters:
    ///   - dbService: Service providing an access to single database table (Entity)
    ///   - context: Database context used to access database content
    ///   - sectionNameKeyPath: Section name. Used if fetched data should be separated by sections
    ///   - predicates: Collection of predicates used to limit fetched content
    ///   - sortDescriptors: Collection of sort descriptors used to sort fetched content
    ///   - limit: Value used to limit amount of fetched objects
    init(dbService: DBObjectService<Entity>,
         context: NSManagedObjectContext? = nil,
         sectionNameKeyPath: String? = nil,
         predicates: [NSPredicate]? = nil,
         sortDescriptors: [NSSortDescriptor]? = nil,
         limit: Int? = nil,
         batchSize: Int? = nil) {
        self.dbService = dbService
        self.context = context
        self.sectionNameKeyPath = sectionNameKeyPath
        self.predicates = predicates
        self.sortDescriptors = sortDescriptors
        self.limit = limit
        self.batchSize = batchSize
        
        super.init()
        
        frc = prepareFRC()
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let _ = delegate else { return }
        changesDelegate = delegate
        changesDelegate?.willChangeContent()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        guard let _ = changesDelegate else { return }
        
        switch type {
        case .insert:
            changesDelegate?.insertSections(at: IndexSet(arrayLiteral: sectionIndex))
        case .delete:
            changesDelegate?.deleteSections(at: IndexSet(arrayLiteral: sectionIndex))
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let _ = changesDelegate else { return }
        
        switch type {
        case .insert:
            changesDelegate?.insertRows(at: [newIndexPath!])
        case .delete:
            changesDelegate?.deleteRows(at: [indexPath!])
        case .update:
            changesDelegate?.reloadRows(at: [indexPath!])
        case .move:
            changesDelegate?.deleteRows(at: [indexPath!])
            changesDelegate?.insertRows(at: [newIndexPath!])
        @unknown default:
            fatalError("Unsupported NSFetchedResultsChangeType: \(type.rawValue)")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let _ = changesDelegate else { return }
        changesDelegate?.didChangeContent()
        changesDelegate = nil
    }
    
    // MARK: Private methods
    
    /// Create and configure new `NSFetchedResultsController` instance
    private func prepareFRC(extraPredicates: [NSPredicate]? = nil) -> NSFetchedResultsController<Entity> {
        
        var predicates = self.predicates
        if let extra = extraPredicates, !extra.isEmpty {
            predicates = predicates ?? []
            predicates?.append(contentsOf: extra)
        }
        let frc = dbService.frc(context: context, sectionNameKeyPath: sectionNameKeyPath, predicates: predicates, sortDescriptors: sortDescriptors, limit: limit, batchSize: batchSize)
        startFRC(frc)
        return frc
    }
    
    /// Fetch database content with `NSFetchedResultsController` and start changes listening
    private func startFRC(_ frc: NSFetchedResultsController<Entity>?) {
        guard let frc = frc else { return }
        frc.delegate = self
        do {
            try frc.performFetch()
            dprint("fetched (\(typeName)): \(frc.fetchedObjects!.count)")
        }catch{
            dprint(category: .error, "FRC fetch failed: \(error)")
        }
    }
}

// MARK: - CollectionProviderDataSource

extension FRCDataSource: CollectionProviderDataSource {
    
    var items: [Any] {
        let fetchedObjects = frc?.fetchedObjects
        return fetchedObjects ?? []
    }
    
    var hasItems: Bool {
        return (frc?.fetchedObjects?.count ?? 0) > 0
    }
    
    func numberOfSections() -> Int {
        return frc?.sections?.count ?? 0
    }
    
    func numberOfRows(in section:Int) -> Int {
        return frc?.sections?[section].numberOfObjects ?? 0
    }
    
    func item(at indexPath: IndexPath) -> Any? {
        return frc?.object(at: indexPath)
    }
    
    func items(in section: Int) -> [Any] {
        return frc?.sections?[section].objects ?? []
    }
    
    func filter(with text: String) {
        guard !text.isEmpty, !Entity.filteredFieldsNames.isEmpty  else {
            frc = prepareFRC(extraPredicates: nil)
            return
        }
        var orPredicates: [NSPredicate] = []
        for filteredFieldName in Entity.filteredFieldsNames {
            let format = "\(filteredFieldName) CONTAINS[cd] %@"
            let predicate = NSPredicate(format: format, text)
            orPredicates.append(predicate)
        }
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: orPredicates)
        frc = prepareFRC(extraPredicates: [predicate])
    }
}
