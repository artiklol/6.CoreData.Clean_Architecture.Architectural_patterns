//
//  MainConfigurator.swift
//  task_4
//
//  Created by Artem Sulzhenko on 17.01.2023.
//

import Foundation

class MainConfigurator {

    static let shared = MainConfigurator()

    func configure(with view: MainViewController) {
        let viewController = view
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

}
