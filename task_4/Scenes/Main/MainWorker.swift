//
//  MainWorker.swift
//  task_4
//
//  Created by Artem Sulzhenko on 17.01.2023.
//

import UIKit

class MainWorker {
    func getDisplayedData(from data: [BelarusBank]) -> [Main.FetchData.ViewModel.DisplayedData] {

        var displayedAtms = [Main.FetchData.ViewModel.DisplayedData]()

        data.forEach { data in
            if let atm = data as? ATM {
                let displayedAtm = Main.FetchData.ViewModel.DisplayedData(
                    coordinate: atm.coordinate,
                    nameType: ATM.typeNameATM,
                    id: atm.mainId,
                    installPlace: atm.installPlace,
                    workTime: atm.workTime,
                    city: atm.city,
                    currency: atm.fixCurrency.rawValue)

                displayedAtms.append(displayedAtm)
            } else if let infoStand = data as? InformationStand {
                let displayedInfoStand = Main.FetchData.ViewModel.DisplayedData(
                    coordinate: infoStand.coordinate,
                    nameType: InformationStand.typeNameInfoStand,
                    id: infoStand.mainId,
                    installPlace: infoStand.installPlace,
                    workTime: infoStand.workTime,
                    city: infoStand.city,
                    currency: infoStand.fixCurrency.rawValue)

                displayedAtms.append(displayedInfoStand)
            } else if let bank = data as? Bank {
                let displayedBank = Main.FetchData.ViewModel.DisplayedData(
                    coordinate: bank.coordinate,
                    nameType: Bank.typeNameBank,
                    id: bank.mainId,
                    installPlace: bank.filialName,
                    workTime: bank.infoWorktime,
                    city: bank.city,
                    phone: bank.phoneInfo)

                displayedAtms.append(displayedBank)
            }

        }

        return displayedAtms
    }
}
