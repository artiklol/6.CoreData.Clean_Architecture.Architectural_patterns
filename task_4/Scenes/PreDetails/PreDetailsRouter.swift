//
//  PreDetailsRouter.swift
//  task_4
//
//  Created by Artem Sulzhenko on 19.01.2023.
//

import UIKit

@objc protocol PreDetailsRoutingLogic {
     func routeToDetails()
}

protocol PreDetailsDataPassing {
    var dataStore: PreDetailsDataStore? { get }
}

class PreDetailsRouter: NSObject, PreDetailsRoutingLogic, PreDetailsDataPassing {

    weak var viewController: PreDetailsViewController?
    var dataStore: PreDetailsDataStore?

    func routeToDetails() {
        let toDetails = DetailsViewController()
        guard var toDataStore = toDetails.router?.dataStore else { return }
        guard let dataStore = dataStore else { return }
        guard let viewController = viewController else { return }
        passDataToPreDetails(source: dataStore, destination: &toDataStore)
        navigateToPreDetails(source: viewController, destination: toDetails)
    }

    func navigateToPreDetails(source: PreDetailsViewController, destination: DetailsViewController) {
        let navigationController = UINavigationController(rootViewController: destination)
        navigationController.modalPresentationStyle = .fullScreen

        source.present(navigationController, animated: true)
    }

    func passDataToPreDetails(source: PreDetailsDataStore, destination: inout DetailsDataStore) {
        destination.elementData = source.elementData
    }
}
