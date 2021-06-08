//
//  UIViewController+PullToRefresh.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import UIKit

extension UIViewController {
    
    /// Initialize Pull-to-Refresh feature for `tableView` on this scene
    /// - Parameter tableView: `UITableView` for which Pull-to-Refresh feature should be enabled
    /// - Returns: Refresh control used to support Pull-to_refresh functionality
    func enablePullToRefresh(for tableView: UITableView) -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(onPullToRefresh(_:)), for: .valueChanged)
        return refreshControl
    }
    
    /// Event handler for processing Pull-to-Refresh action
    @objc func onPullToRefresh(_ sender: UIRefreshControl) {}
    
}
