//
//  DetailsRouter.swift
//  task_4
//
//  Created by Artem Sulzhenko on 22.01.2023.
//
import UIKit

@objc protocol DetailsRoutingLogic {
    // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol DetailsDataPassing {
    var dataStore: DetailsDataStore? { get }
}

class DetailsRouter: NSObject, DetailsRoutingLogic, DetailsDataPassing {

    weak var viewController: DetailsViewController?
    var dataStore: DetailsDataStore?

}
