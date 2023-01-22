//
//  PreDetailsInteractor.swift
//  task_4
//
//  Created by Artem Sulzhenko on 19.01.2023.
//

import UIKit

protocol PreDetailsBusinessLogic {
    func fetchData(request: PreDetails.FetchData.Request)
}

protocol PreDetailsDataStore {
    var elementData: BelarusBank? { get set }
}

class PreDetailsInteractor: PreDetailsBusinessLogic, PreDetailsDataStore {
    var elementData: BelarusBank?

    var presenter: PreDetailsPresentationLogic?

    func fetchData(request: PreDetails.FetchData.Request) {
        guard let elementData = elementData else { return }
        let response = PreDetails.FetchData.Response(elementData: elementData)
        presenter?.presentData(response: response)
    }
}
