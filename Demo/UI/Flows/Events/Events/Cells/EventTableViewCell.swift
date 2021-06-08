//
//  EventTableViewCell.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import UIKit
import SDWebImage

class EventTableViewCell: BaseTableViewCell {

    // MARK: IBOutlets
    
    @IBOutlet private weak var eventNameLabel: UILabel!
    @IBOutlet private weak var venueNameLabel: UILabel!
    @IBOutlet private weak var weekDayLabel: UILabel!
    @IBOutlet private weak var dayNumberLabel: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var eventImageView: UIImageView!
    
    @IBOutlet private weak var contentContainerView: UIView! {
        didSet { contentContainerView.dropShadow(with: ShadowInfo(color: .black.withAlphaComponent(0.3), offset: .zero, radius: 2.0)) }
    }
    
    // MARK: Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventImageView.image = nil
    }
}

// MARK: - StatementCellProtocol

extension EventTableViewCell: EventCellProtocol {
    
    var eventName: String {
        get { eventNameLabel.text ?? "" }
        set { eventNameLabel.text = newValue }
    }
    var venueName: String {
        get { venueNameLabel.text ?? "" }
        set { venueNameLabel.text = newValue }
    }
    var weekDay: String {
        get { weekDayLabel.text ?? "" }
        set { weekDayLabel.text = newValue }
    }
    var dayNumber: String {
        get { dayNumberLabel.text ?? "" }
        set { dayNumberLabel.text = newValue }
    }
    var month: String {
        get { monthLabel.text ?? "" }
        set { monthLabel.text = newValue }
    }
    var time: String {
        get { timeLabel.text ?? "" }
        set { timeLabel.text = newValue }
    }
    func set(imageUrl url: URL?) {
        eventImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "cellPlaceholder"), options: [], completed: nil)
    }
}
