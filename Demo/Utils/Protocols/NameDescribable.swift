//
//  NameDescribable.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

/// Protocol supporting ability to get class name as string
protocol NameDescribable { }

extension NameDescribable {
    
    /// Name of instance type
    var typeName: String { String(describing: type(of: self)) }
    
    /// Name of class/structure/etc.
    static var typeName: String { String(describing: self) }
    
    /// Class identifier
    static var identifier: String { String(describing: self) }
    
    /// Name of database entity
    static var entityName: String { typeName }
}

extension NSObject: NameDescribable { }
