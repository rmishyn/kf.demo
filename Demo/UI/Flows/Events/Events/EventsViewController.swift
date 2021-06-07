//
//  EventsViewController.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import UIKit

class EventsViewController: UIViewController {

    // MARK: Properties (EventsInterface)
    
    var presenter: EventsPresentation!

}

// MARK: - EventsInterface

extension EventsViewController: EventsInterface { }
