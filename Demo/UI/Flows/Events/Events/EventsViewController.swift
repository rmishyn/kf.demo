//
//  EventsViewController.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import UIKit

class EventsViewController: UIViewController {

    // MARK: Properties (EventsInterface)
    
    var presenter: EventsPresentation!
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            EventTableViewCell.register(forTableView: tableView)
            tableView.tableFooterView = UIView()
            refreshControl = enablePullToRefresh(for: tableView)
        }
    }
    
    private weak var refreshControl: UIRefreshControl!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
    }
    
    // MARK: Actions
    
    override func onPullToRefresh(_ sender: UIRefreshControl) {
        presenter.onRefreshAction()
    }
}

// MARK: - EventsInterface

extension EventsViewController: EventsInterface {
    func setContentProvider(_ provider: TableViewContentProviding) {
        guard tableView != nil else { return }
        provider.tableView = tableView
    }
    
    func stopRefresh() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}
