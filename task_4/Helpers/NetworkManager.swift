//
//  NetworkManager.swift
//  task_4
//
//  Created by Artem Sulzhenko on 30.12.2022.
//

import Foundation
import UIKit

class NetworkManager {

    static private let atmsUrl = "https://belarusbank.by/api/atm"
    static private let informationStandsUrl = "https://belarusbank.by/api/infobox"
    static private var banksUrl = "https://belarusbank.by/api/filials_info"

    static private var statusCodeAtm = 0
    static private var statusCodeInformationStands = 0
    static private var statusCodBank = 0

    static func fetchDataAtm(completion: @escaping ([ATM], Int) -> Void) {
        guard let url = URL(string: atmsUrl) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let response = response as? HTTPURLResponse {
                statusCodeAtm = response.statusCode
            }

            guard let data = data else { return }
            guard let result = try? JSONDecoder().decode(ATMList.self, from: data) else { return }
            let ATMs = result

            DispatchQueue.main.async {
                completion(ATMs, statusCodeAtm)
            }
        }.resume()
    }

    static func fetchDataInformationStand(completion: @escaping ([InformationStand], Int) -> Void) {
        guard let url = URL(string: informationStandsUrl) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let response = response as? HTTPURLResponse {
                statusCodeInformationStands = response.statusCode
            }

            guard let data = data else { return }
            guard let result = try? JSONDecoder().decode(InformationStandList.self, from: data) else { return }
            let informationStands = result

            DispatchQueue.main.async {
                completion(informationStands, statusCodeInformationStands)
            }
        }.resume()
    }

    static func fetchDataBank(completion: @escaping ([Bank], Int) -> Void) {
        guard let url = URL(string: banksUrl) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let response = response as? HTTPURLResponse {
                statusCodBank = response.statusCode
            }

            guard let data = data else { return }
            guard let result = try? JSONDecoder().decode(BankList.self, from: data) else { return }
            let banks = result

            DispatchQueue.main.async {
                completion(banks, statusCodBank)
            }

        }.resume()
    }
}
