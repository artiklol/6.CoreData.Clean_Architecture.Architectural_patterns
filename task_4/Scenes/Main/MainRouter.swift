//
//  MainRouter.swift
//  task_4
//
//  Created by Artem Sulzhenko on 17.01.2023.
//

import UIKit

@objc protocol MainRoutingLogic {
    func routeToPreDetails(id: String)
}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {

    weak var viewController: MainViewController?
    var dataStore: MainDataStore?

    func routeToPreDetails(id: String) {
        let toPreDetails = PreDetailsViewController()
        guard var toDataStore = toPreDetails.router?.dataStore else { return }
        guard let dataStore = dataStore else { return }
        guard let viewController = viewController else { return }
        passDataToPreDetails(source: dataStore, destination: &toDataStore, id: id)
        navigateToPreDetails(source: viewController, destination: toPreDetails)
    }

    func navigateToPreDetails(source: MainViewController, destination: PreDetailsViewController) {
        if UIDevice.current.orientation.isLandscape {
            if let sheet = destination.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersEdgeAttachedInCompactHeight = true
            }
        } else {
            if let sheet = destination.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersEdgeAttachedInCompactHeight = false
            }
        }
        source.present(destination, animated: true)
    }

    func passDataToPreDetails(source: MainDataStore, destination: inout PreDetailsDataStore, id: String) {
        var indexResult = Int()
        for index in 0..<source.data.count where source.data[index].mainId == id {
            indexResult = index
        }
        destination.elementData = source.data[indexResult]
    }
}
