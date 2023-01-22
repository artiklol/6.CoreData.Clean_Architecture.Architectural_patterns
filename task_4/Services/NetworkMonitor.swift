//
//  NetworkMonitor.swift
//  task_4
//
//  Created by Artem Sulzhenko on 22.01.2023.
//

import Network
import Foundation

class NetworkMonitor {

    static var isConnectedToNetwork = Bool()

    static func startMonitoringNetwork() {
        let networkMonitor = NWPathMonitor()

        networkMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                isConnectedToNetwork = true
            } else {
                isConnectedToNetwork = false
            }
        }

        let internetQueue = DispatchQueue(label: "InternetMonitor")
        networkMonitor.start(queue: internetQueue)
    }

}
