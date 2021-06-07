//
//  DBManagerContract.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation
import CoreData

/// Protocol describing interface to access local database
protocol DBManagement: AnyObject {
    /// Primary context to access writing functionality
    var writingContext: NSManagedObjectContext {get}
    /// Primary context to access reading functionality
    var readingContext: NSManagedObjectContext {get}
    /// Returns new additional context to access writing functionality
    var temporaryContext: NSManagedObjectContext {get}
    /// Returns new additional context to access reading functionality
    var temporaryReadingContext: NSManagedObjectContext {get}
    
    /// Performs writing operations using `writingContext`, saves them is `changes` returns `true` and then calls `completion` (asynchronously, using main thread)
    /// - Parameter changes: Closure containing instructions which performs changes. Returns `true` if changes must be saved or `false` if changes should be reverted
    /// - Parameter completion: Closure called asynchronously after `changes` are performed
    func performChanges(_ changes:@escaping ((NSManagedObjectContext)->Bool), completion: VoidResultCompletion? )
    /// Performs reading operations using `readingContext` and then calls `completion`
    /// - Parameter reading: Closure containing reading instructions
    /// - Parameter completion: Closure called synchronously after `reading` is finished
    func performRead(_ reading:@escaping (NSManagedObjectContext)->(), completion: VoidCompletion?)
    
    /// Service providing a functionality to operate with `Event` items
    var eventsService: DBObjectService<Event> {get}
}
