//
//  MapView.swift
//  task_4
//
//  Created by Artem Sulzhenko on 17.01.2023.
//

import UIKit
import MapKit
import CoreLocation

class MapView: MKMapView {

    private lazy var locationManager = CLLocationManager()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.overrideUserInterfaceStyle = .unspecified
        setupManager()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(data: [Main.FetchData.ViewModel.DisplayedData]) {
        removeAnnotations(annotations.filter { $0.title != "Я" })
        for element in data {
            let pinLocation = element.coordinate
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.subtitle = element.id
            objectAnnotation.title = element.nameType
            addAnnotation(objectAnnotation)
        }
    }

    private func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    private func checkAuthorization() {
        switch locationAuthorizationStatus() {
        case .authorizedWhenInUse:
            self.showsUserLocation = true
            self.userLocation.title = "Я"
            self.userLocation.subtitle = "Я"
        case .denied:
            print("danied")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        setupManager()
    }

    func locationAuthorizationStatus() -> CLAuthorizationStatus {
        let locationManager = CLLocationManager()
        var locationAuthorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            locationAuthorizationStatus =  locationManager.authorizationStatus
        } else {
            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        }
        return locationAuthorizationStatus
    }

}

extension MapView: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}
