//
//  CollectionDataProvidingContract.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import UIKit

/// Protocol describing a base functionality of providers which can provide UI collections content
protocol CollectionContentProviding: AnyObject {
    /// Collection title
    var title: String? {get}
    /// Collection identifier (to identify a collection when several collections used together)
    var identifier: String? {get}
    /// Container of data
    var dataSource: CollectionProviderDataSource! {get}
    /// Describes if `dataSource` contains any data
    var hasItems: Bool {get}
    /// Collection of data items holded in `dataSource`
    var items: [Any] {get}
    /// Method providing indexed access to data in `dataSource`
    /// - Parameter indexPath: IndexPath describing index of data which should be extracted from `dataSource`
    /// - Returns: Element extracted from `dataSource` at provided index or nil of item not found by this index
    func item(at indexPath: IndexPath) -> Any?
    /// Filter data in `dataSource` with provided text
    /// - Parameter text: String used to filter data
    func filter(with text: String)
    /// Reload assigned UI collection
    func reload()
    /// Stop any activity of this provider. Used if it is expected to not use this provider anymore (before dealocation)
    func deactivate()
}

/// Protocol describing a functionality of providers which can provide content for connected UITableView collection and handle its events
protocol TableViewContentProviding: UITableViewDataSource, UITableViewDelegate, CollectionContentProviding {
    /// Closure called on connected UITableView is scrolled
    var onDidScroll: VoidCompletion? {get set}
    /// UITableView connected to this provider
    var tableView: UITableView? {get set}
    /// Select single row in connected UITableView
    /// - Parameters:
    ///   - indexPath: Index path of row which should be selected
    ///   - animated: Flag to indicate if animation should be applied to selection
    func selectItem(at indexPath: IndexPath, animated: Bool)
    /// Deselect single row in connected UITableView
    /// - Parameters:
    ///   - indexPath: Index path of row which should be deselected
    ///   - animated: Flag to indicate if animation should be applied to deselection
    func deselectItem(at indexPath: IndexPath, animated: Bool)
}

/// Protocol describing data collection used in `CollectionContentProviding` providers
protocol CollectionProviderDataSource {
    /// Listener of data changes
    var delegate: DataProviderDelegate? {get set} //to observe changes in data
    /// Collection of data items
    var items: [Any] {get}
    /// Describes if data collection contains anything
    var hasItems: Bool {get}
    /// Number of data sections
    /// - Returns: Number of data sections
    func numberOfSections() -> Int
    /// Number of data elements in section of data collection
    /// - Parameter section: Index of data section
    /// - Returns: Number of data elements in section of data collection
    func numberOfRows(in section: Int) -> Int
    /// Provides indexed access to element of data according for index
    /// - Parameter index: Index of element which should be returned
    /// - Returns: Element for index or nil if element not found for this index
    func item(at indexPath: IndexPath) -> Any?
    /// Collection of data elements in single section
    /// - Parameter section: Section index
    /// - Returns: Collection of data elements in single section
    func items(in section: Int) -> [Any]
    /// Apply filter to data elements collection
    /// - Parameter text: String used to filter data elements
    func filter(with text: String)
}

/// Protocol describing a listener of events about data changes in `CollectionProviderDataSource`
protocol DataProviderDelegate: AnyObject {
    /// Notify a delegate about data changes starting
    func willChangeContent()
    /// Notify a delegate about new sections were inserted into data items collection
    /// - Parameter indexes: Indexes of inserted sections
    func insertSections(at indexes:IndexSet)
    /// Notify a delegate about sections were removed from data items collection
    /// - Parameter indexes: Indexes of deleted sections
    func deleteSections(at indexes:IndexSet)
    /// Notify a delegate about new items were inserted into data items collection
    /// - Parameter indexPaths: Indexes of inserted items (IndexPath format)
    func insertRows(at indexPaths:[IndexPath])
    /// Notify a delegate about items were removed from data items collection
    /// - Parameter indexPaths: Indexes of deleted items (IndexPath format)
    func deleteRows(at indexPaths:[IndexPath])
    /// Notify a delegate about updated items in data items collection. Used to reload UI elements
    /// - Parameter indexPaths: Indexes of updated items (IndexPath format)
    func reloadRows(at indexPaths:[IndexPath])
    /// Notify a delegate about data changes finished
    func didChangeContent()
    /// Notify a delegate about data cleanup
    func willResetDataSource()
}

// MARK: - CollectionContentProviding

extension CollectionContentProviding {
    func filter(with text: String) {
        dataSource.filter(with: text)
        reload()
    }
}

// MARK: - TableViewContentProviding

extension TableViewContentProviding {
    func reload() {
        tableView?.reloadData()
    }
}

// MARK: - CollectionProviderDataSource

extension CollectionProviderDataSource {
    func filter(with text: String) { }
}
