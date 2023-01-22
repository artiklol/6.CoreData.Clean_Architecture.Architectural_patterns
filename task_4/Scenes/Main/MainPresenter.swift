//
//  MainPresenter.swift
//  task_4
//
//  Created by Artem Sulzhenko on 17.01.2023.
//

import UIKit
import CoreLocation

protocol MainPresentationLogic {
    func presentData(response: Main.FetchData.Response)
    func atmStatusCode(statusCode: Int)
    func infoStandStatusCode(statusCode: Int)
    func bankStatusCode(statusCode: Int)
}

class MainPresenter: MainPresentationLogic {

    weak var viewController: MainDisplayLogic?
    var worker: MainWorker?

    // MARK: Do something
    func presentData(response: Main.FetchData.Response) {
        worker = MainWorker()

        guard let displayedData = worker?.getDisplayedData(from: response.data) else { return }
        var viewModel = Main.FetchData.ViewModel(displayedData: displayedData)

        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        let defaultLocation = CLLocation(latitude: 52.425163, longitude: 31.015039)
        let userLocation = locationManager.location ?? defaultLocation
        viewModel.displayedData = viewModel.displayedData.sorted {
            CLLocation(latitude: $0.coordinate.latitude,
                       longitude: $0.coordinate.longitude).distance(
                        from: userLocation) < CLLocation(latitude: $1.coordinate.latitude,
                                                         longitude: $1.coordinate.longitude).distance(
                                                            from: userLocation) }

        var sectionCity = [String]()
        var citySet = Set<String>()
        for element in viewModel.displayedData {
            if !citySet.contains(element.city) {
                sectionCity.append(element.city)
            }
            citySet.insert(element.city)
        }

        viewController?.displayData(viewModel: viewModel, sectionCity: sectionCity)
        viewController?.stopActivityView()
        viewController?.setRegion(coordinate: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                                                     longitude: userLocation.coordinate.longitude))
    }

    func atmStatusCode(statusCode: Int) {
        viewController?.atmStatusCode(statusCode: statusCode)
    }

    func infoStandStatusCode(statusCode: Int) {
        viewController?.infoStandStatusCode(statusCode: statusCode)
    }

    func bankStatusCode(statusCode: Int) {
        viewController?.bankStatusCode(statusCode: statusCode)
    }
}
