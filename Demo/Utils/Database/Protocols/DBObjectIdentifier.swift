//
//  DBObjectIdentifier.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

/// Protocol for types which are allowed to be used as database object identifier
protocol DBObjectIdentifier {}

extension Int: DBObjectIdentifier {}
extension Int64: DBObjectIdentifier {}
extension String: DBObjectIdentifier {}
