//
//  EventsContract.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

protocol EventsInterface: AnyObject {
    var presenter: EventsPresentation! {get set}
}

protocol EventsPresentation: AnyObject {
}

protocol EventsOutput: AnyObject {
}
