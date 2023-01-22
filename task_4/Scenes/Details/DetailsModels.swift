//
//  DetailsModels.swift
//  task_4
//
//  Created by Artem Sulzhenko on 22.01.2023.
//

import UIKit
import CoreLocation

enum Details {
    enum FetchData {
        struct Request {
        }

        struct Response {
            var elementData: BelarusBank
        }

        struct ViewModel {
            var displayedData: BelarusBank
        }
    }
}
