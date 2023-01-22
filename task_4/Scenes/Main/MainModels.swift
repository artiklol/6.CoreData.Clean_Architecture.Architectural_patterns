//
//  MainModels.swift
//  task_4
//
//  Created by Artem Sulzhenko on 17.01.2023.
//

import UIKit
import CoreLocation

enum Main {

    enum FetchData {

        struct Request {
        }

        struct Response {
            var data: [BelarusBank]
        }

        struct ViewModel {
            struct DisplayedData {
                var coordinate: CLLocationCoordinate2D
                var nameType: String
                var id: String
                var installPlace: String
                var workTime: String
                var city: String
                var currency: String?
                var phone: String?
            }

            var displayedData: [DisplayedData]
        }
    }
}
