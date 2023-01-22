//
//  MainInteractor.swift
//  task_4
//
//  Created by Artem Sulzhenko on 17.01.2023.
//

import UIKit
import CoreData

protocol MainBusinessLogic {
    func fetchDataAtm(request: Main.FetchData.Request)
    func fetchDataInformationStand(request: Main.FetchData.Request)
    func fetchDataBank(request: Main.FetchData.Request)
    func fetchAtmFromCoreData()
    func fetchInfoStandFromCoreData()
    func fetchBankFromCoreData()
    func showModelFilter(typeName: String)
    func hideModelFilter(typeName: String)
    var needForActivationActivityView: Bool { get }
}

protocol MainDataStore {
    var data: [BelarusBank] { get }
}

class MainInteractor: MainBusinessLogic, MainDataStore {

    var presenter: MainPresentationLogic?
    lazy var data = [BelarusBank]()
    private lazy var bufferData = [BelarusBank]()

    private lazy var atmActivity = true
    private lazy var infoStandActivity = true
    private lazy var bankActivity = true

    var needForActivationActivityView = Bool()

    func fetchDataAtm(request: Main.FetchData.Request) {
        if atmActivity {
            needForActivationActivityView = true
            NetworkManager.fetchDataAtm { [weak self] atms, statusCode in
                if statusCode >= 200 && statusCode < 300 {
                    self?.getData(getData: atms, dataType: ATM.typeNameATM)
                    StorageManager.deleteAllRecords(entityName: "ATMCoreData")
                    for atm in atms {
                        StorageManager.saveAtmToCoreData(atmDataElement: atm)
                    }
                } else {
                    self?.presenter?.atmStatusCode(statusCode: statusCode)
                }
            }
        } else {
            needForActivationActivityView = false
        }
    }

    func fetchDataInformationStand(request: Main.FetchData.Request) {
        if infoStandActivity {
            NetworkManager.fetchDataInformationStand { [weak self] infoStands, statusCode in
                if statusCode >= 200 && statusCode < 300 {
                    self?.getData(getData: infoStands, dataType: InformationStand.typeNameInfoStand)
                    StorageManager.deleteAllRecords(entityName: "InfoStandCoreData")
                    for infoStand in infoStands {
                        StorageManager.saveInfoStandToCoreData(infoStandElement: infoStand)
                    }
                } else {
                    self?.presenter?.infoStandStatusCode(statusCode: statusCode)
                }
            }
        }
    }

    func fetchDataBank(request: Main.FetchData.Request) {
        if bankActivity {
            NetworkManager.fetchDataBank { [weak self] banks, statusCode in
                if statusCode >= 200 && statusCode < 300 {
                    self?.getData(getData: banks, dataType: Bank.typeNameBank)
                    StorageManager.deleteAllRecords(entityName: "BankCoreData")
                    for bank in banks {
                        StorageManager.saveBankToCoreData(bankElement: bank)
                    }
                } else {
                    self?.presenter?.bankStatusCode(statusCode: statusCode)
                }
            }
        }
    }

    func fetchAtmFromCoreData() {
        if atmActivity {
            data = data.filter { $0.typeName != ATM.typeNameATM }
            let fetchRequest: NSFetchRequest<ATMCoreData> = ATMCoreData.fetchRequest()
            guard let managedContext = StorageManager.managedContext else { return }
            guard let atmCoreData = try? managedContext.fetch(fetchRequest) else { return }

            for atm in atmCoreData {
                data.append(convertAtmCoreDataToBelarusbank(atmCoreData: atm))
            }

            let response = Main.FetchData.Response(data: data)
            presenter?.presentData(response: response)
        }
    }

    func fetchInfoStandFromCoreData() {
        if infoStandActivity {
            data = data.filter { $0.typeName != InformationStand.typeNameInfoStand }
            let fetchRequest: NSFetchRequest<InfoStandCoreData> = InfoStandCoreData.fetchRequest()
            guard let managedContext = StorageManager.managedContext else { return }
            guard let infoStandCoreData = try? managedContext.fetch(fetchRequest) else { return }

            for infoStand in infoStandCoreData {
                data.append(convertInfoStandCoreDataToBelarusbank(infoStandCoreData: infoStand))
            }

            let response = Main.FetchData.Response(data: data)
            presenter?.presentData(response: response)
        }
    }

    func fetchBankFromCoreData() {
        if bankActivity {
            data = data.filter { $0.typeName != Bank.typeNameBank }
            let fetchRequest: NSFetchRequest<BankCoreData> = BankCoreData.fetchRequest()
            guard let managedContext = StorageManager.managedContext else { return }
            guard let bankCoreData = try? managedContext.fetch(fetchRequest) else { return }

            for bank in bankCoreData {
                data.append(convertBankCoreDataToBelarusbank(bankCoreData: bank))
            }

            let response = Main.FetchData.Response(data: data)
            presenter?.presentData(response: response)
        }
    }

    func showModelFilter(typeName: String) {
        if typeName == ATM.typeNameATM {
            atmActivity = true
        } else if typeName == InformationStand.typeNameInfoStand {
            infoStandActivity = true
        } else if typeName == Bank.typeNameBank {
            bankActivity = true
        }
        data += bufferData.filter { $0.typeName == typeName }
        bufferData = bufferData.filter { $0.typeName != typeName }
        let response = Main.FetchData.Response(data: data)
        presenter?.presentData(response: response)
    }

    func hideModelFilter(typeName: String) {
        if typeName == ATM.typeNameATM {
            atmActivity = false
        } else if typeName == InformationStand.typeNameInfoStand {
            infoStandActivity = false
        } else if typeName == Bank.typeNameBank {
            bankActivity = false
        }
        bufferData += data.filter { $0.typeName == typeName }
        data = data.filter { $0.typeName != typeName }
        let response = Main.FetchData.Response(data: data)
        presenter?.presentData(response: response)
    }

    private func convertAtmCoreDataToBelarusbank(atmCoreData: ATMCoreData) -> ATM {
        let atm = ATM(id: atmCoreData.id ?? "",
                      area: Area(rawValue: atmCoreData.area ?? "") ?? .empty,
                      cityType: CityType(rawValue: atmCoreData.cityType ?? "") ?? .empty,
                      city: atmCoreData.city ?? "",
                      addressType: AddressType(rawValue: atmCoreData.addressType ?? "") ?? .empty,
                      address: atmCoreData.address ?? "",
                      house: atmCoreData.house ?? "",
                      installPlace: atmCoreData.installPlace ?? "",
                      workTime: atmCoreData.workTime ?? "",
                      gpsX: atmCoreData.gpsX ?? "", gpsY: atmCoreData.gpsY ?? "",
                      atmType: ATMTypeEnum(rawValue: atmCoreData.atmType ?? "") ?? .empty,
                      atmError: ATMError(rawValue: atmCoreData.atmError ?? "") ?? .empty,
                      currency: ATMCurrency(rawValue: atmCoreData.currency ?? "") ?? .empty,
                      cashIn: ATMError(rawValue: atmCoreData.cashIn ?? "") ?? .empty,
                      atmPrinter: ATMError(rawValue: atmCoreData.atmPrinter ?? "") ?? .empty)
        return atm
    }

    private func convertInfoStandCoreDataToBelarusbank(
        infoStandCoreData: InfoStandCoreData) -> InformationStand {
        let infoStand = InformationStand(
            infoId: Int(infoStandCoreData.infoId ?? "") ?? 0,
            area: Area(rawValue: infoStandCoreData.area ?? "") ?? .empty,
            cityType: CityType(rawValue: infoStandCoreData.cityType ?? "") ?? .empty,
            city: infoStandCoreData.city ?? "",
            addressType: AddressType(rawValue: infoStandCoreData.addressType ?? "") ?? .empty,
            address: infoStandCoreData.address ?? "",
            house: infoStandCoreData.house ?? "",
            installPlace: infoStandCoreData.installPlace ?? "",
            workTime: infoStandCoreData.workTime ?? "",
            gpsX: infoStandCoreData.gpsX ?? "", gpsY: infoStandCoreData.gpsY ?? "",
            currency: InformationStandCurrency(rawValue: infoStandCoreData.currency ?? "") ?? .empty,
            infType: ATMTypeEnum(rawValue: infoStandCoreData.infType ?? "") ?? .empty,
            cashIn: ATMError(rawValue: infoStandCoreData.cashIn ?? "") ?? .empty,
            infPrinter: ATMError(rawValue: infoStandCoreData.infPrinter ?? "") ?? .empty,
            infStatus: ATMError(rawValue: infoStandCoreData.infStatus ?? "") ?? .empty)
        return infoStand
    }

    private func convertBankCoreDataToBelarusbank(bankCoreData: BankCoreData) -> Bank {
        let bank = Bank(
            filialId: bankCoreData.filialId ?? "",
            sapId: bankCoreData.sapId ?? "",
            filialName: bankCoreData.filialName ?? "",
            cityType: bankCoreData.cityType ?? "",
            city: bankCoreData.city ?? "",
            addressType: bankCoreData.addressType ?? "",
            address: bankCoreData.address ?? "",
            house: bankCoreData.house ?? "",
            infoWorktime: bankCoreData.infoWorktime ?? "",
            gpsX: bankCoreData.gpsX ?? "", gpsY: bankCoreData.gpsY ?? "",
            phoneInfo: bankCoreData.phoneInfo ?? "",
            belNumberSchet: bankCoreData.belNumberSchet ?? "",
            foreignNumberSchet: bankCoreData.foreignNumberSchet ?? "",
            filialNum: bankCoreData.filialNum ?? "",
            cbuNum: bankCoreData.cbuNum ?? "")
        return bank
    }

    private func getData(getData: [BelarusBank], dataType: String) {
        data = data.filter { $0.typeName != dataType }
        data += getData
        let response = Main.FetchData.Response(data: data)
        presenter?.presentData(response: response)
    }

}
