//
//  TableViewContentProvider.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import UIKit

// Provider which can provide content for connected UITableView collection and handle its events
class TableViewContentProvider: NSObject {
    
    // MARK: TableViewContentProviding (properties)
    
    private(set) var dataSource: CollectionProviderDataSource!
    weak var tableView: UITableView? {
        didSet {
            if let tableView = self.tableView {
                tableView.delegate = self
                tableView.dataSource = self
                reloadContent()
            }
        }
    }
    var hasItems: Bool {  dataSource.hasItems }
    var onDidScroll: VoidCompletion?
    
    var items: [Any] { dataSource.items }
    
    var title: String? { nil }
    var identifier: String? { nil }
    
    /// MARK: Properties
    
    /// Closure called if any cell was selected in connected table view
    var onDidSelectItem: ((_ atIndexPath: IndexPath, _ provider: TableViewContentProviding) -> ())?
    /// Closure called if any cell was deselected in connected table view
    var onDidDeselectItem: ((_ atIndexPath: IndexPath, _ provider: TableViewContentProviding) -> ())?
    /// Closure called if swipe gesture detected (leading-to-trailing deirection)
    var onLeadingSwipeAction: ((_ atIndexPath: IndexPath, _ provider: TableViewContentProviding) -> ())?
    /// Closure called if swipe gesture detected (trailing-to-leading deirection)
    var onTrailingSwipeAction: ((_ atIndexPath: IndexPath, _ provider: TableViewContentProviding) -> ())?
    /// Closure called on data changed in datasource assigned with this provider
    var onDidChangeContent: ((_ provider: TableViewContentProviding)->())?
    
    // MARK: Lifecycle
    
    /// Initializer
    /// - Parameter dataSource: Container of data used to prepare UI content
    init(dataSource: CollectionProviderDataSource) {
        super.init()
        self.dataSource = dataSource
        self.dataSource.delegate = self
    }
    
    /// Deinitializer
    deinit {
        deactivate()
    }
}

// MARK: - TableViewContentProviding

extension TableViewContentProvider: TableViewContentProviding {
    
    @objc func item(at indexPath: IndexPath) -> Any? {
        return dataSource.item(at: indexPath)
    }
    
    @objc func deactivate() {
        (onDidSelectItem, onDidDeselectItem, onLeadingSwipeAction, onTrailingSwipeAction, onDidChangeContent, onDidScroll) = (nil, nil, nil, nil, nil, nil)
        if let tableView = tableView {
            if self === tableView.delegate {
                tableView.delegate = nil
            }
            if self === tableView.dataSource {
                tableView.dataSource = nil
            }
            self.tableView = nil
        }
    }
    
    func selectItem(at indexPath: IndexPath, animated: Bool) {
        tableView?.selectRow(at: indexPath, animated: animated, scrollPosition: .none)
    }
    
    func deselectItem(at indexPath: IndexPath, animated: Bool) {
        tableView?.deselectRow(at: indexPath, animated: animated)
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int { dataSource.numberOfSections() }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { dataSource.numberOfRows(in: section) }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { UITableViewCell() }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { 64.0 }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDidSelectItem?(indexPath, self)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDidDeselectItem?(indexPath, self)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UISwipeActionsConfiguration(actions: [])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UISwipeActionsConfiguration(actions: [])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? BaseCellProtocol {
            cell.invalidate()
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onDidScroll?()
    }
}

extension TableViewContentProvider: DataProviderDelegate {
    @objc func reloadContent() {
        guard let tableView = tableView else { return }
//        tableView.beginUpdates()
        tableView.reloadData()
//        tableView.endUpdates()
    }
    
    @objc func willChangeContent() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.willChangeContent()
            }
            return
        }
        tableView?.beginUpdates()
    }
    
    @objc func insertSections(at indexes:IndexSet) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.insertSections(at: indexes)
            }
            return
        }
        tableView?.insertSections(indexes, with: AppConfiguration.Animation.tableViewAnimation)
    }
    
    @objc func deleteSections(at indexes:IndexSet) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.deleteSections(at: indexes)
            }
            return
        }
        tableView?.deleteSections(indexes, with: AppConfiguration.Animation.tableViewAnimation)
    }
    
    @objc func insertRows(at indexPaths:[IndexPath]) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.insertRows(at: indexPaths)
            }
            return
        }
        tableView?.insertRows(at: indexPaths, with: AppConfiguration.Animation.tableViewAnimation)
    }
    
    @objc func deleteRows(at indexPaths:[IndexPath]) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.deleteRows(at: indexPaths)
            }
            return
        }
        tableView?.deleteRows(at: indexPaths, with: AppConfiguration.Animation.tableViewAnimation)
    }
    
    @objc func reloadRows(at indexPaths:[IndexPath]) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.reloadRows(at: indexPaths)
            }
            return
        }
        guard let tableView = self.tableView else { return }
        var indexPathsToReload: [IndexPath] = []
        if let visibleIndexPaths: [IndexPath] = tableView.indexPathsForVisibleRows {
            for indexPath in indexPaths {
                if visibleIndexPaths.contains(indexPath) {
                    indexPathsToReload.append(indexPath)
                }
            }
        }
        if !indexPathsToReload.isEmpty {
            tableView.reloadRows(at: indexPathsToReload, with: AppConfiguration.Animation.tableViewAnimationReload)
        }
    }
    
    @objc func didChangeContent() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.didChangeContent()
            }
            return
        }
        tableView?.endUpdates()
        onDidChangeContent?(self)
    }
    
    @objc func willResetDataSource() {
        deactivate()
    }
}
