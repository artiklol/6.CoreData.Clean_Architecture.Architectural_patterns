//
//  StorageManager.swift
//  task_4
//
//  Created by Artem Sulzhenko on 21.01.2023.
//

import UIKit
import CoreData

class StorageManager {

    static let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    static func saveAtmToCoreData(atmDataElement: ATM) {
        guard let managedContext = managedContext else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "ATMCoreData",
                                                      in: managedContext) else { return }
        guard let task = NSManagedObject(entity: entity,
                                         insertInto: managedContext) as? ATMCoreData else { return }

        task.id = atmDataElement.id
        task.area = atmDataElement.area.rawValue
        task.cityType = atmDataElement.cityType.rawValue
        task.city = atmDataElement.city
        task.addressType = atmDataElement.addressType.rawValue
        task.address = atmDataElement.address
        task.house = atmDataElement.house
        task.installPlace = atmDataElement.installPlace
        task.workTime = atmDataElement.workTime
        task.gpsX = atmDataElement.gpsX
        task.gpsY = atmDataElement.gpsY
        task.atmType = atmDataElement.atmType.rawValue
        task.atmError = atmDataElement.atmError.rawValue
        task.currency = atmDataElement.currency.rawValue
        task.cashIn = atmDataElement.cashIn.rawValue
        task.atmPrinter = atmDataElement.atmPrinter.rawValue

        do {
            try managedContext.save()
        } catch let error {
            print("Failed save atm to core data", error.localizedDescription)
        }
    }

    static func saveInfoStandToCoreData(infoStandElement: InformationStand) {
        guard let managedContext = managedContext else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "InfoStandCoreData",
                                                      in: managedContext) else { return }
        guard let task = NSManagedObject(entity: entity,
                                         insertInto: managedContext) as? InfoStandCoreData else { return }

        task.infoId = String(infoStandElement.infoId)
        task.area = infoStandElement.area.rawValue
        task.cityType = infoStandElement.cityType.rawValue
        task.city = infoStandElement.city
        task.addressType = infoStandElement.addressType.rawValue
        task.address = infoStandElement.address
        task.house = infoStandElement.house
        task.installPlace = infoStandElement.installPlace
        task.workTime = infoStandElement.workTime
        task.gpsX = infoStandElement.gpsX
        task.gpsY = infoStandElement.gpsY
        task.currency = infoStandElement.currency.rawValue
        task.infType = infoStandElement.infType.rawValue
        task.cashIn = infoStandElement.cashIn.rawValue
        task.infPrinter = infoStandElement.infPrinter.rawValue
        task.infStatus = infoStandElement.infStatus.rawValue

        do {
            try managedContext.save()
        } catch let error {
            print("Failed save info stand to core data", error.localizedDescription)
        }
    }

    static func saveBankToCoreData(bankElement: Bank) {
        guard let managedContext = managedContext else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "BankCoreData",
                                                      in: managedContext) else { return }
        guard let task = NSManagedObject(entity: entity,
                                         insertInto: managedContext) as? BankCoreData else { return }

        task.filialId = bankElement.filialId
        task.sapId = bankElement.sapId
        task.filialName = bankElement.filialName
        task.cityType = bankElement.cityType
        task.city = bankElement.city
        task.addressType = bankElement.addressType
        task.address = bankElement.address
        task.house = bankElement.house
        task.infoWorktime = bankElement.infoWorktime
        task.gpsX = bankElement.gpsX
        task.gpsY = bankElement.gpsY
        task.belNumberSchet = bankElement.belNumberSchet
        task.foreignNumberSchet = bankElement.foreignNumberSchet
        task.phoneInfo = bankElement.phoneInfo
        task.filialNum = bankElement.filialNum
        task.cbuNum = bankElement.cbuNum

        do {
            try managedContext.save()
        } catch let error {
            print("Failed save info stand to core data", error.localizedDescription)
        }
    }

    static func countRecords(entityName: String) -> Int {
        guard let managedContext = managedContext else { return 0 }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var count = Int()
        do {
            count = try managedContext.count(for: fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return count
    }

    static func deleteAllRecords(entityName: String) {
        guard let managedContext = managedContext else { return }

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch let error {
            print("Failed delete from core data", error.localizedDescription)
        }
    }
}
