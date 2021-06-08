//
//  BaseTableViewCell.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import UIKit

/// Class used as parent class for other `UITableViewCell` subclasses throughout the app
class BaseTableViewCell: UITableViewCell, BaseTableViewCellProtocol {

    //MARK: - BaseTableViewCellProtocol
    
    /// Performs cell class registration in `UITableView`. This is required if cell is designed out of UITableView in Nib or Storyboard
    /// Only registered cell class can be dequeued with `UITableView`'s method `dequeueReusableCell(withIdentifier:)`
    /// - Parameter tableView: `UITableView` instance for which cell class should be registered
    class func register(forTableView tableView:UITableView) {
        let cellIdentifier = self.cellIdentifier
        tableView.register(self, forCellReuseIdentifier: cellIdentifier)
        let cellNib = UINib.init(nibName: nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    /// Stop any cell activity
    func invalidate() {
        NotificationCenter.default.removeObserver(self)
    }
}
