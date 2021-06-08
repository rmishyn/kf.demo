//
//  EventsContentProvider.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import UIKit

/// Class which provides content of Statements list (Profile flow)
class EventsContentProvider: TableViewContentProvider {
    
    static let weekdayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter
    }()
    
    static let dayNumberDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter
    }()
    
    static let monthDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter
    }()
    
    static let timeDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let event = dataSource.item(at: indexPath) as? Event,
            let uicell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.cellIdentifier) {
            if var cell = uicell as? EventCellProtocol {
                
                cell.eventName = event.name ?? "-"
                cell.venueName = event.venue?.name ?? "-"
                if let startTime = event.startTime {
                    cell.weekDay = EventsContentProvider.weekdayDateFormatter.string(from: startTime).uppercased()
                    cell.dayNumber = EventsContentProvider.dayNumberDateFormatter.string(from: startTime)
                    cell.month = EventsContentProvider.monthDateFormatter.string(from: startTime)
                    var timeComponents: [String] = [EventsContentProvider.timeDateFormatter.string(from: startTime)]
                    if let endTime = event.endTime {
                        timeComponents.append(EventsContentProvider.timeDateFormatter.string(from: endTime))
                    }
                    cell.time = timeComponents.joined(separator: " - ")
                } else {
                    
                }
                if let imageIdentifier = event.imagesIdentifiers.first {
                    let url = URL(imageIdentifier: imageIdentifier)
                    cell.set(imageUrl: url)
                }
                
            }
            return uicell
        }
        
        return UITableViewCell()
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}
