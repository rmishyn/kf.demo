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
    
    private let eventsService: EventsServiceProtocol
    private let dbEventsService: DBObjectService<Event>
    private let contentProvidersFactory: ContentProvidersFactoryProtocol
    private var tableViewContentProvider: TableViewContentProviding?
    
    private var viewDidLoad: Bool = false
    private var isEventsRequestActive: Bool = false
    
    // MARK: Public methods
    
    init(view: EventsInterface, output: EventsOutput, configuration: EventsConfiguration) {
        self.view = view
        self.output = output
        self.eventsService = configuration.eventsService
        self.dbEventsService = configuration.dbEventsService
        self.contentProvidersFactory = configuration.contentProvidersFactory
        refreshEvents()
        prepareDataProvider()
    }
    
    // MARK: Private methods
    
    private func refreshEvents() {
        guard !isEventsRequestActive else { return }
        isEventsRequestActive = true
        let requestParameters = AppConfiguration.DefaultEventsRequestParameters.self
        eventsService.getEvents(lat: requestParameters.lat,
                                lon: requestParameters.lon,
                                placeId: requestParameters.placeId,
                                locationRadius: requestParameters.locationRadius,
                                pageNumber: requestParameters.pageNumber,
                                pageSize: requestParameters.pageSize, completion: { [weak self] (result) in
                                    guard let self = self else { return }
                                    defer { self.isEventsRequestActive = false; self.view.stopRefresh() }
                                    switch result {
                                    case .failure: break
                                    case .success: break
                                    }
                                })
    }
    
    private func prepareDataProvider() {
        let dataSource = FRCDataSource<Event>(dbService: self.dbEventsService, predicates: nil)
        let tableViewContentProvider = contentProvidersFactory.eventsContentProvider(dataSource: dataSource)
        
//        tableViewContentProvider.onDidSelectItem = { [weak self] (indexPath, _) in
//            self?.openItem(at: indexPath)
//        }
        self.tableViewContentProvider = tableViewContentProvider
        if viewDidLoad {
            view.setContentProvider(tableViewContentProvider)
        }
    }
    
    // MARK: EventsPresentation
    
    func onViewDidLoad() {
        if let tableViewContentProvider = tableViewContentProvider {
            view.setContentProvider(tableViewContentProvider)
        }
        viewDidLoad = true
    }
    
    func onRefreshAction() {
        refreshEvents()
    }
}
