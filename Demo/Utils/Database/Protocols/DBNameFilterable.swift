//
//  DBNameFilterable.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import Foundation

/// Protocol used to support data filtering in FRCDataSource and FRCDropdownListDataSource instances
protocol DBNameFilterable {
    /// List if properties names which should be used to filter data
    static var filteredFieldsNames: [String] {get}
}
