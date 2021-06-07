//
//  ServicesProviding.swift
//  Demo
//
//  Created by Ruslan Mishyn on 06.06.2021.
//

import Foundation

protocol ServicesProviding {
    var eventsService: EventsServiceProtocol {get}
}
