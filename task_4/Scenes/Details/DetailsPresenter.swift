//
//  DetailsPresenter.swift
//  task_4
//
//  Created by Artem Sulzhenko on 22.01.2023.
//

import UIKit

protocol DetailsPresentationLogic {
    func presentData(response: Details.FetchData.Response)
}

class DetailsPresenter: DetailsPresentationLogic {

    weak var viewController: DetailsDisplayLogic?

    func presentData(response: Details.FetchData.Response) {
        if let atm = response.elementData as? ATM {
            let displayedDetails = atm

            let viewModel = Details.FetchData.ViewModel(displayedData: displayedDetails)
            viewController?.displayData(viewModel: viewModel)
        } else if let infoStand = response.elementData as? InformationStand {
            let displayedDetails = infoStand

            let viewModel = Details.FetchData.ViewModel(displayedData: displayedDetails)
            viewController?.displayData(viewModel: viewModel)
        } else if let bank = response.elementData as? Bank {
            let displayedDetails = bank

            let viewModel = Details.FetchData.ViewModel(displayedData: displayedDetails)
            viewController?.displayData(viewModel: viewModel)
        }
    }
}
