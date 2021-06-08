//
//  ContentProvidersFactory.swift
//  Demo
//
//  Created by Ruslan Mishyn on 08.06.2021.
//

import Foundation

protocol ContentProvidersFactoryProtocol {
    func eventsContentProvider(dataSource: CollectionProviderDataSource) -> TableViewContentProviding
}

class ContentProvidersFactory: ContentProvidersFactoryProtocol {
    func eventsContentProvider(dataSource: CollectionProviderDataSource) -> TableViewContentProviding {
        return EventsContentProvider(dataSource: dataSource)
    }
}
