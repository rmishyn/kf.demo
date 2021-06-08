//
//  UIView+Extension.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import UIKit

/// Protocol describing a shadow configuration provider
protocol ShadowInfoProviding {
    var color: UIColor {get}
    var opacity: Float {get}
    var offset: CGSize {get}
    var radius: CGFloat {get}
    var masksToBounds: Bool {get}
}

/// Structure containing a shadow configuration
struct ShadowInfo: ShadowInfoProviding {
    let color: UIColor
    let opacity: Float
    let offset: CGSize
    let radius: CGFloat
    let masksToBounds: Bool
    
    init(color: UIColor, opacity: Float = 1.0, offset: CGSize, radius: CGFloat, masksToBounds:Bool = false) {
        self.color = color
        self.opacity = opacity
        self.offset = offset
        self.radius = radius
        self.masksToBounds = masksToBounds
    }
}

extension UIView {
    
    /// Add shadow effect to this view
    /// - Parameter configuration: Shadow configuration
    func dropShadow(with configuration: ShadowInfoProviding) {
        layer.masksToBounds = configuration.masksToBounds
        layer.shadowColor = configuration.color.cgColor
        layer.shadowOpacity = configuration.opacity
        layer.shadowOffset = configuration.offset
        layer.shadowRadius = configuration.radius
    }
    
}
