//
//  PreDetailsModels.swift
//  task_4
//
//  Created by Artem Sulzhenko on 19.01.2023.
//

import UIKit
import CoreLocation

enum PreDetails {

    enum FetchData {
        struct Request {
        }

        struct Response {
            var elementData: BelarusBank
        }

        struct ViewModel {
            struct DisplayedData {
                var coordinate: CLLocationCoordinate2D
                var nameType: String
                var id: String
                var installPlace: String
                var workTime: String
                var city: String
                var cashIn: String?
                var currency: String?
                var fullAddress: String?
                var phone: String?
            }

            var displayedData: DisplayedData
        }
    }
}
