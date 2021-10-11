//
//  Dependencies.swift
//  KODE-Weather
//
//  Created by Developer on 23.09.2021.
//

import Foundation

struct AppDependencies: HasCoreDataClientProvider {
    let coreDataClient: CoreDataClient
}

protocol HasCoreDataClientProvider {
    var coreDataClient: CoreDataClient { get }
}
