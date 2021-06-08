//
//  BaseCellProtocol.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import UIKit

/// Protocol used to describe common functionality of collections cells throughout app
protocol BaseCellProtocol: NameDescribable {
    /// Cell identifier used to dequeue reusable cells
    static var cellIdentifier: String {get}
    /// Name of "*.xib" containing a data for cell loading from NIB
    static var nibName: String {get}
    /// Stop any activity of cell before it will be removed from collection
    func invalidate()
}

/// Protocol used to describe common functionality of tableview cells throughout app
protocol BaseTableViewCellProtocol: BaseCellProtocol {
    /// Register cell class for using with specified `UITableView`
    /// - Parameter tableView: `UITableView` where cell class using should be enabled
    static func register(forTableView tableView: UITableView)
}

extension BaseCellProtocol {
    
    static var cellIdentifier: String { typeName }
    
    static var nibName: String { typeName }
}
