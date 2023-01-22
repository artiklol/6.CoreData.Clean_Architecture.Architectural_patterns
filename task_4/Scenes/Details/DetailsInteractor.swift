//
//  DetailsInteractor.swift
//  task_4
//
//  Created by Artem Sulzhenko on 22.01.2023.
//

import UIKit

protocol DetailsBusinessLogic {
    func fetchData(request: Details.FetchData.Request)
}

protocol DetailsDataStore {
    var elementData: BelarusBank? { get set }
}

class DetailsInteractor: DetailsBusinessLogic, DetailsDataStore {

    var presenter: DetailsPresentationLogic?

    var elementData: BelarusBank?

    func fetchData(request: Details.FetchData.Request) {
        guard let elementData = elementData else { return }
        let response = Details.FetchData.Response(elementData: elementData)
        presenter?.presentData(response: response)
    }
}
