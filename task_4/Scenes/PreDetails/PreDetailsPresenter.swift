//
//  PreDetailsPresenter.swift
//  task_4
//
//  Created by Artem Sulzhenko on 19.01.2023.
//

import UIKit

protocol PreDetailsPresentationLogic {
    func presentData(response: PreDetails.FetchData.Response)
}

class PreDetailsPresenter: PreDetailsPresentationLogic {

    weak var viewController: PreDetailsDisplayLogic?

    func presentData(response: PreDetails.FetchData.Response) {
        if let atms = response.elementData as? ATM {
            let displayedDetails = PreDetails.FetchData.ViewModel.DisplayedData(
                coordinate: atms.coordinate,
                nameType: atms.typeName,
                id: atms.id,
                installPlace: atms.installPlace,
                workTime: atms.workTime,
                city: atms.city,
                cashIn: atms.cashIn.rawValue,
                currency: atms.fixCurrency.rawValue)

            let viewModel = PreDetails.FetchData.ViewModel(displayedData: displayedDetails)
            viewController?.displayData(viewModel: viewModel)
        } else if let infoStand = response.elementData as? InformationStand {
            let displayedDetails = PreDetails.FetchData.ViewModel.DisplayedData(
                coordinate: infoStand.coordinate,
                nameType: infoStand.typeName,
                id: infoStand.mainId,
                installPlace: infoStand.installPlace,
                workTime: infoStand.workTime,
                city: infoStand.city,
                cashIn: infoStand.cashIn.rawValue,
                currency: infoStand.fixCurrency.rawValue)

            let viewModel = PreDetails.FetchData.ViewModel(displayedData: displayedDetails)
            viewController?.displayData(viewModel: viewModel)
        } else if let bank = response.elementData as? Bank {
            let displayedDetails = PreDetails.FetchData.ViewModel.DisplayedData(
                coordinate: bank.coordinate,
                nameType: bank.typeName,
                id: bank.mainId,
                installPlace: bank.filialName,
                workTime: bank.infoWorktime,
                city: bank.city,
                fullAddress: "\(bank.addressType) \(bank.address) \(bank.house)",
                phone: bank.phoneInfo)

            let viewModel = PreDetails.FetchData.ViewModel(displayedData: displayedDetails)
            viewController?.displayData(viewModel: viewModel)
        }
    }
}
