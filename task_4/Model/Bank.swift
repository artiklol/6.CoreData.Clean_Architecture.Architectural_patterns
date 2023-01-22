//
//  Bank.swift
//  task_4
//
//  Created by Artem Sulzhenko on 10.01.2023.
//

import Foundation
import MapKit

class Bank: BelarusBank, Codable {

    override var mainId: String {
        return filialId
    }
    override var typeName: String {
        return typeNameBank
    }
    override var cityBelarusbank: String {
        return city
    }
    override var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(gpsX) ?? 0,
                                      longitude: Double(gpsY) ?? 0)
    }

    let typeNameBank = "Банк"
    let filialId: String
    let sapId: String
    let filialName: String
    let cityType: String
    let city: String
    let addressType: String
    let address: String
    let house: String
    let infoWorktime: String
    let gpsX: String
    let gpsY: String
    let belNumberSchet: String
    let foreignNumberSchet: String
    let phoneInfo: String
    let filialNum: String
    let cbuNum: String

    enum CodingKeys: String, CodingKey {
        case filialId = "filial_id"
        case sapId = "sap_id"
        case filialName = "filial_name"
        case cityType = "name_type"
        case city = "name"
        case addressType = "street_type"
        case address = "street"
        case house = "home_number"
        case infoWorktime = "info_worktime"
        case gpsX = "GPS_X"
        case gpsY = "GPS_Y"
        case belNumberSchet = "bel_number_schet"
        case foreignNumberSchet = "foreign_number_schet"
        case phoneInfo = "phone_info"
        case filialNum = "filial_num"
        case cbuNum = "cbu_num"
    }

    init(filialId: String, sapId: String, filialName: String, cityType: String, city: String, addressType: String, address: String, house: String, infoWorktime: String, gpsX: String, gpsY: String, phoneInfo: String, belNumberSchet: String, foreignNumberSchet: String, filialNum: String, cbuNum: String) {
        self.filialId = filialId
        self.sapId = sapId
        self.filialName = filialName
        self.cityType = cityType
        self.city = city
        self.infoWorktime = infoWorktime
        self.addressType = addressType
        self.address = address
        self.house = house
        self.gpsX = gpsX
        self.gpsY = gpsY
        self.phoneInfo = phoneInfo
        self.belNumberSchet = belNumberSchet
        self.foreignNumberSchet = foreignNumberSchet
        self.filialNum = filialNum
        self.cbuNum = cbuNum
    }

}

typealias BankList = [Bank]
