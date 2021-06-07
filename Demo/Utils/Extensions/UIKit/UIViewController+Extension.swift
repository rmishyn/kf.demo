//
//  UIViewController+Extension.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import UIKit

extension UIViewController {
    
    /// Creates the view controller with the specified identifier and initializes it with the data from the storyboard
    /// - Parameters:
    ///   - storyboard: Storyboard containing this view controller definition
    ///   - identifier: An identifier string that uniquely identifies the view controller in the storyboard file
    /// - Returns: View controller loaded from storyboard
    private class func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
        storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    /// Creates the view controller with the specified identifier and initializes it with the data from the storyboard
    /// - Parameters:
    ///   - storyboard: Storyboard containing this view controller definition
    ///   - identifier: An identifier string that uniquely identifies the view controller in the storyboard file
    /// - Returns: View controller loaded from storyboard
    class func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
        instantiateControllerInStoryboard(storyboard, identifier: identifier)
    }
    
    /// Creates the view controller with the default identifier and initializes it with the data from the storyboard
    /// - Parameters:
    ///   - storyboard: Storyboard containing this view controller definition
    /// - Returns: View controller loaded from storyboard
    class func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
        controllerInStoryboard(storyboard, identifier: identifier)
    }
    
    /// Creates the view controller with the default identifier and initializes it with the data from the storyboard
    /// - Parameters:
    ///   - storyboard: Storyboard enumeration case containing this view controller definition
    /// - Returns: View controller loaded from storyboard
    class func controllerFromStoryboard(_ storyboard: Storyboard) -> Self {
        controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: nil), identifier: identifier)
    }
    
}
