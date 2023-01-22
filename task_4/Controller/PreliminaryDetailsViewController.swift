//
//  TestViewController.swift
//  task_4
//
//  Created by Artem Sulzhenko on 31.12.2022.
//

import UIKit
import SnapKit

class PreliminaryDetailsViewController: UIViewController {

    private lazy var nameObjectLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = label.font.withSize(21)
        label.textAlignment = .center
        return label
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()

    private lazy var detailButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Подробнее"
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted:
                button.configuration?.baseBackgroundColor = UIColor(named: "Green")?.withAlphaComponent(0.7)
            default:
                button.configuration?.baseBackgroundColor = UIColor(named: "Green")
            }
        }
        button.addTarget(self, action: #selector(detailButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var workTimeTitleLabel = UILabel()
    private lazy var workTimeLabel = UILabel()
    private lazy var workTimeStackView = UIStackView()
    private lazy var firstTitleLabel = UILabel()
    private lazy var firstLabel = UILabel()
    private lazy var firstStackView = UIStackView()
    private lazy var secondTitleLabel = UILabel()
    private lazy var secondLabel = UILabel()
    private lazy var secondStackView = UIStackView()

    private var atmElement: ATM?
    private var infoStandElement: InformationStand?
    private var bankElement: Bank?
    private lazy var coordinateUserLocation: (x: Double, y: Double) = (0, 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")

        addUIContent()
        setConstraint()
    }

    private func addUIContent() {
        view.addSubview(mainStackView)
        view.addSubview(nameObjectLabel)
        setTitleAndInfoInStackView(titleLabel: workTimeTitleLabel, descriptionLabel: workTimeLabel,
                                   stackView: workTimeStackView)
        setTitleAndInfoInStackView(titleLabel: firstTitleLabel, descriptionLabel: firstLabel,
                                   stackView: firstStackView)
        setTitleAndInfoInStackView(titleLabel: secondTitleLabel, descriptionLabel: secondLabel,
                                   stackView: secondStackView)
        view.addSubview(detailButton)
    }

    private func setConstraint() {
        mainStackView.snp.makeConstraints { maker in
            maker.centerX.equalTo(view)
            maker.centerY.equalTo(view)
        }
        workTimeLabel.snp.makeConstraints { maker in
            maker.width.equalTo(300)
        }
        nameObjectLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(20)
            maker.left.equalToSuperview().inset(50)
            maker.right.equalToSuperview().inset(50)
            maker.width.equalTo(300)
        }
        detailButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(50)
            maker.right.equalToSuperview().inset(50)
            maker.bottom.equalToSuperview().inset(30)
            maker.height.equalTo(40)
        }
    }

    private func setTitleAndInfoInStackView(titleLabel: UILabel, descriptionLabel: UILabel,
                                            stackView: UIStackView) {
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.textColor = UIColor(named: "Gray")
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        descriptionLabel.font = descriptionLabel.font.withSize(18)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center

        stackView.axis = .vertical
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)

        mainStackView.addArrangedSubview(stackView)
    }

    func atmElementInPreDetails(element: ATM, coordinate: (x: Double, y: Double)) {
        nameObjectLabel.text = element.installPlace
        workTimeTitleLabel.text = "Режим работы"
        workTimeLabel.text = element.workTime
        firstTitleLabel.text = "Валюта"
        firstLabel.text = element.fixCurrency.rawValue
        secondTitleLabel.text = "Наличие cash in"
        secondLabel.text = element.cashIn.rawValue

        infoStandElement = nil
        bankElement = nil
        self.atmElement = element
        coordinateUserLocation = coordinate
    }

    func infoStandElementInPreDetails(element: InformationStand, coordinate: (x: Double, y: Double)) {
        nameObjectLabel.text = element.installPlace
        workTimeTitleLabel.text = "Режим работы"
        workTimeLabel.text = element.workTime
        firstTitleLabel.text = "Валюта"
        firstLabel.text = element.fixCurrency.rawValue
        secondTitleLabel.text = "Наличие cash in"
        secondLabel.text = element.cashIn.rawValue

        atmElement = nil
        bankElement = nil
        self.infoStandElement = element
        coordinateUserLocation = coordinate
    }

    func bankElementInPreDetails(element: Bank, coordinate: (x: Double, y: Double)) {
        nameObjectLabel.text = element.filialName
        workTimeTitleLabel.text = "Режим работы"
        workTimeLabel.text = element.infoWorktime
        firstTitleLabel.text = "Адрес"
        firstLabel.text = "\(element.addressType) \(element.address) \(element.house)"
        secondTitleLabel.text = "Телефон"
        secondLabel.text = element.phoneInfo

        atmElement = nil
        infoStandElement = nil
        self.bankElement = element
        coordinateUserLocation = coordinate
    }

    @objc func detailButtonTap() {
        let details = DetailsViewController()

        if atmElement != nil {
            guard let element = atmElement else { return }
            details.atmDataInDetails(element: element, coord: coordinateUserLocation)
        } else if infoStandElement != nil {
            guard let element = infoStandElement else { return }
            details.infoStandDataInDetails(element: element, coord: coordinateUserLocation)
        } else if bankElement != nil {
            guard let element = bankElement else { return }
            details.bankDataInDetails(element: element, coord: coordinateUserLocation)
        }
        let navigationController = UINavigationController(rootViewController: details)

        navigationController.modalPresentationStyle = .fullScreen

        present(navigationController, animated: true, completion: nil)
    }

}
