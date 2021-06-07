//
//  NSManagedObjectContext+Extension.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    /// Check if context contains uncommited changes. Attempt to commit unsaved changes
    /// - Parameter completion: Closure called asynchronously after operation is done
    func saveIfHasChanges(completion: VoidResultCompletion?) {
        if hasChanges {
            do {
                try save()
            } catch {
                dprint(category: .error, "Failed to save context: \(error)")
                DispatchQueue.main.async { completion?(.failure(error)) }
                return
            }
        }
        DispatchQueue.main.async { completion?(.success(())) }
    }
}
