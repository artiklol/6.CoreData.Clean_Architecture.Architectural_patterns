//
//  ATM.swift
//  task_4
//
//  Created by Artem Sulzhenko on 10.01.2023.
//

import Foundation
import MapKit

class ATM: BelarusBank, Codable {

    override var mainId: String {
        return id
    }
    override var typeName: String {
        return typeNameATM
    }
    override var cityBelarusbank: String {
        return city
    }
    override var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(gpsX) ?? 0,
                                      longitude: Double(gpsY) ?? 0)
    }

    let typeNameATM = "Банкомат"
    let id: String
    let area: Area
    let cityType: CityType
    let city: String
    let addressType: AddressType
    let address, house, installPlace, workTime: String
    let gpsX, gpsY: String
    let atmType: ATMTypeEnum
    let atmError: ATMError
    let currency: ATMCurrency
    let cashIn, atmPrinter: ATMError
    var fixCurrency: FixCurrency {
        switch currency {
        case .byn:
            let fixCurrency = FixCurrency.byn
            return fixCurrency
        case .bynUsd:
            let fixCurrency = FixCurrency.bynUsd
            return fixCurrency
        case .empty:
            let fixCurrency = FixCurrency.empty
            return fixCurrency
        }
    }
    var fixCityType: FixCityType {
        switch cityType {
        case .empty:
            let fixCity = FixCityType.empty
            return fixCity
        case .agroTown:
            let fixCity = FixCityType.agroTown
            return fixCity
        case .city:
            let fixCity = FixCityType.city
            return fixCity
        case .urbanSettlement:
            let fixCity = FixCityType.urbanSettlement
            return fixCity
        case .urbanSettlementDuplicat:
            let fixCity = FixCityType.urbanSettlement
            return fixCity
        case .village:
            let fixCity = FixCityType.village
            return fixCity
        case .resortVillage:
            let fixCity = FixCityType.resortVillage
            return fixCity
        case .resortVillageDuplicate:
            let fixCity = FixCityType.resortVillage
            return fixCity
        case .settlement:
            let fixCity = FixCityType.settlement
            return fixCity
        case .district:
            let fixCity = FixCityType.district
            return fixCity
        case .workSettlement:
            let fixCity = FixCityType.workSettlement
            return fixCity
        case .villageCouncil:
            let fixCity = FixCityType.villageCouncil
            return fixCity
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, area
        case cityType = "city_type"
        case city
        case addressType = "address_type"
        case address, house
        case installPlace = "install_place"
        case workTime = "work_time"
        case gpsX = "gps_x"
        case gpsY = "gps_y"
        case atmType = "ATM_type"
        case atmError = "ATM_error"
        case currency
        case cashIn = "cash_in"
        case atmPrinter = "ATM_printer"
    }

    init(id: String, area: Area, cityType: CityType, city: String, addressType: AddressType, address: String,
         house: String, installPlace: String, workTime: String, gpsX: String, gpsY: String, atmType: ATMTypeEnum,
         atmError: ATMError, currency: ATMCurrency, cashIn: ATMError, atmPrinter: ATMError) {
        self.id = id
        self.area = area
        self.cityType = cityType
        self.city = city
        self.addressType = addressType
        self.address = address
        self.house = house
        self.installPlace = installPlace
        self.workTime = workTime
        self.gpsX = gpsX
        self.gpsY = gpsY
        self.atmType = atmType
        self.atmError = atmError
        self.currency = currency
        self.cashIn = cashIn
        self.atmPrinter = atmPrinter
    }

}

enum AddressType: String, Codable {
    case addressType = " "
    case addressTypeStreet = "ул. "
    case empty = ""
    case purple = "-"
    case boulevard = "б-р"
    case boulevardDuplicat = "бул."
    case other = "др."
    case microdistrict = "мкр."
    case alleyway = "пер."
    case square = "пл."
    case village = "пос."
    case avenue = "пр."
    case customStreet = "РАД общ. польз-я"
    case station = "ст."
    case tract = "тракт"
    case street = "ул."
    case highway = "шоссе"
}

enum Area: String, Codable {
    case brestRegion = "Брестская"
    case vitebskRegion = "Витебская"
    case gomelRegion = "Гомельская"
    case grodnoRegion = "Гродненская"
    case minsk = "Минск"
    case minskRegion = "Минская"
    case mogilevRegion = "Могилевская"
}

enum ATMError: String, Codable {
    case yes = "да"
    case no = "нет"
}

enum ATMTypeEnum: String, Codable {
    case externalAtm = "Внешний"
    case internalAtm = "Внутренний"
    case streetAtm = "Уличный"
}

enum CityType: String, Codable {
    case empty = ""
    case agroTown = "аг."
    case city = "г."
    case urbanSettlement = "г.п."
    case urbanSettlementDuplicat = "гп"
    case village = "д."
    case resortVillage = "к.п."
    case resortVillageDuplicate = "кп"
    case settlement = "п."
    case district = "р-н"
    case workSettlement = "рп"
    case villageCouncil = "с/с"
}

enum FixCityType: String, Codable {
    case empty = "-"
    case agroTown = "аг."
    case city = "г."
    case urbanSettlement = "г.п."
    case urbanSettlementDuplicat = ""
    case village = "д."
    case resortVillage = "к.п."
    case resortVillageDuplicate = " "
    case settlement = "п."
    case district = "р-н"
    case workSettlement = "р.п."
    case villageCouncil = "с/с"
}

enum ATMCurrency: String, Codable {
    case byn = "BYN   "
    case bynUsd = "BYN   USD   "
    case empty = ""
}

enum FixCurrency: String, Codable {
    case byn = "BYN"
    case bynUsd = "BYN, USD"
    case bynRub = "BYN, RUB"
    case empty = "-"
}

typealias ATMList = [ATM]
