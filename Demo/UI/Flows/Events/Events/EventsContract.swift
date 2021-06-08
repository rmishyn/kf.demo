//
//  EventsContract.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

protocol EventsInterface: AnyObject {
    var presenter: EventsPresentation! {get set}
    func setContentProvider(_ provider: TableViewContentProviding)
    func stopRefresh()
}

protocol EventsPresentation: AnyObject {
    func onViewDidLoad()
    func onRefreshAction()
}

protocol EventsOutput: AnyObject {
}

protocol EventCellProtocol {
    var eventName: String {get set}
    var venueName: String {get set}
    var weekDay: String {get set}
    var dayNumber: String {get set}
    var month: String {get set}
    var time: String {get set}
    func set(imageUrl url: URL?)
}
