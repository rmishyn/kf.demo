//
//  URL+Extension.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import Foundation

extension URL {
    init?(imageIdentifier: String) {
        let string = "\(AppConfiguration.Networking.imagesStorageUrl)\(imageIdentifier).png"
        self.init(string: string)
    }
}
