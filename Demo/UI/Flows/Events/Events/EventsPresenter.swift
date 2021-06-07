//
//  EventsPresenter.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

class EventsPresenter: EventsPresentation {
    
    // MARK: Properties
    
    private weak var output: EventsOutput!
    private unowned var view: EventsInterface!
    
    // MARK: Public methods
    
    init(view: EventsInterface, output: EventsOutput, configuration: EventsConfiguration) {
        self.view = view
        self.output = output
    }
}
