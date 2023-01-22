//
//  PreDetailsConfigurator.swift
//  task_4
//
//  Created by Artem Sulzhenko on 19.01.2023.
//

import Foundation

class PreDetailsConfigurator {

    static let shared = PreDetailsConfigurator()

    func configure(with view: PreDetailsViewController) {
        let viewController = view
        let interactor = PreDetailsInteractor()
        let presenter = PreDetailsPresenter()
        let router = PreDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

    }

}
