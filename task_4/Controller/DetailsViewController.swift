//
//  DetailsViewController.swift
//  task_4
//
//  Created by Artem Sulzhenko on 06.01.2023.
//

import UIKit
import SnapKit
import MapKit

class DetailsViewController: UIViewController {

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: "ViewBackgroundColor")
        return scrollView
    }()

    private lazy var createRouteButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Построить маршрут"
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted:
                button.configuration?.baseBackgroundColor = UIColor(named: "Green")?.withAlphaComponent(0.7)
            default:
                button.configuration?.baseBackgroundColor = UIColor(named: "Green")
            }
        }
        button.addTarget(self, action: #selector(createRouteButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var firstTitleLabel = UILabel()
    private lazy var firstLabel = UILabel()
    private lazy var firstStackView = UIStackView()
    private lazy var secondTitleLabel = UILabel()
    private lazy var secondLabel = UILabel()
    private lazy var secondStackView = UIStackView()
    private lazy var thirdTitleLabel = UILabel()
    private lazy var thirdLabel = UILabel()
    private lazy var thirdStackView = UIStackView()
    private lazy var fourthTitleLabel = UILabel()
    private lazy var fourthLabel = UILabel()
    private lazy var fourthStackView = UIStackView()
    private lazy var fifthTitleLabel = UILabel()
    private lazy var fifthLabel = UILabel()
    private lazy var fifthStackView = UIStackView()
    private lazy var sixthTitleLabel = UILabel()
    private lazy var sixthLabel = UILabel()
    private lazy var sixthStackView = UIStackView()
    private lazy var seventhTitleLabel = UILabel()
    private lazy var seventhLabel = UILabel()
    private lazy var seventhStackView = UIStackView()
    private lazy var eighthTitleLabel = UILabel()
    private lazy var eighthLabel = UILabel()
    private lazy var eighthStackView = UIStackView()
    private lazy var ninthTitleLabel = UILabel()
    private lazy var ninthLabel = UILabel()
    private lazy var ninthStackView = UIStackView()
    private lazy var tenthTitleLabel = UILabel()
    private lazy var tenthLabel = UILabel()
    private lazy var tenthStackView = UIStackView()
    private lazy var eleventhTitleLabel = UILabel()
    private lazy var eleventhLabel = UILabel()
    private lazy var eleventhStackView = UIStackView()
    private lazy var thirteenthTitleLabel = UILabel()
    private lazy var thirteenthLabel = UILabel()
    private lazy var thirteenthStackView = UIStackView()

    private lazy var belarusbankCoordinate: (x: Double, y: Double) = (0, 0)
    private lazy var coordinateUserLocation: (x: Double, y: Double) = (0, 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")

        setNavigationBar()
        addUIContent()
        setConstraint()
    }

    private func addUIContent() {
        view.addSubview(scrollView)
        view.addSubview(createRouteButton)
        scrollView.addSubview(mainStackView)

        setTitleAndInfoInStackView(titleLabel: firstTitleLabel,
                                   infoLabel: firstLabel, stackView: firstStackView)
        setTitleAndInfoInStackView(titleLabel: secondTitleLabel,
                                   infoLabel: secondLabel, stackView: secondStackView)
        setTitleAndInfoInStackView(titleLabel: thirdTitleLabel,
                                   infoLabel: thirdLabel, stackView: thirdStackView)
        setTitleAndInfoInStackView(titleLabel: fourthTitleLabel,
                                   infoLabel: fourthLabel, stackView: fourthStackView)
        setTitleAndInfoInStackView(titleLabel: fifthTitleLabel,
                                   infoLabel: fifthLabel, stackView: fifthStackView)
        setTitleAndInfoInStackView(titleLabel: sixthTitleLabel,
                                   infoLabel: sixthLabel, stackView: sixthStackView)
        setTitleAndInfoInStackView(titleLabel: seventhTitleLabel,
                                   infoLabel: seventhLabel, stackView: seventhStackView)
        setTitleAndInfoInStackView(titleLabel: eighthTitleLabel,
                                   infoLabel: eighthLabel, stackView: eighthStackView)
        setTitleAndInfoInStackView(titleLabel: ninthTitleLabel,
                                   infoLabel: ninthLabel, stackView: ninthStackView)
        setTitleAndInfoInStackView(titleLabel: tenthTitleLabel,
                                   infoLabel: tenthLabel, stackView: tenthStackView)
        setTitleAndInfoInStackView(titleLabel: eleventhTitleLabel,
                                   infoLabel: eleventhLabel, stackView: eleventhStackView)
        setTitleAndInfoInStackView(titleLabel: thirteenthTitleLabel,
                                   infoLabel: thirteenthLabel, stackView: thirteenthStackView)
    }

    private func setNavigationBar() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.overrideUserInterfaceStyle = .unspecified
        let navBarAppearance = UINavigationBarAppearance()
        navigationBar?.standardAppearance = navBarAppearance
        navigationBar?.scrollEdgeAppearance = navBarAppearance

        let backButtonItem = UIBarButtonItem(title: "Назад", style: .done, target: self,
                                             action: #selector(backButtonItemTap))
        navigationItem.leftBarButtonItem  = backButtonItem
    }

    private func setConstraint() {
        scrollView.snp.makeConstraints { maker in
            maker.top.left.right.equalTo(view)
            maker.bottom.equalTo(view).inset(100)
        }
        mainStackView.snp.makeConstraints { maker in
            maker.top.equalTo(scrollView).inset(10)
            maker.left.right.bottom.equalTo(scrollView)
            maker.width.equalTo(scrollView)
        }
        createRouteButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(50)
            maker.right.equalToSuperview().inset(50)
            maker.bottom.equalToSuperview().inset(30)
            maker.height.equalTo(40)
        }
    }

    private func setTitleAndInfoInStackView(titleLabel: UILabel, infoLabel: UILabel, stackView: UIStackView) {
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.textColor = UIColor(named: "Gray")
        titleLabel.textAlignment = .left

        infoLabel.font = infoLabel.font.withSize(18)
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .right

        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(infoLabel)

        mainStackView.addArrangedSubview(stackView)

        stackView.snp.makeConstraints { maker in
            maker.right.left.equalTo(mainStackView).inset(10)
            maker.width.equalTo(mainStackView).inset(10)
        }
        titleLabel.snp.makeConstraints { maker in
            maker.width.equalTo(157)
        }
    }

    func atmDataInDetails(element: ATM, coord: (x: Double, y: Double)) {
        navigationItem.title = "Банкомат"

        firstTitleLabel.text = "ID банкомата"
        firstLabel.text = element.id
        secondTitleLabel.text = "Область"
        secondLabel.text = element.area.rawValue
        thirdTitleLabel.text = "Город"
        thirdLabel.text = "\(element.fixCityType.rawValue) \(element.city)"
        fourthTitleLabel.text = "Адрес"
        fourthLabel.text = "\(element.addressType.rawValue) \(element.address) \(element.house)"
        fifthTitleLabel.text = "Место установки"
        fifthLabel.text = element.installPlace
        sixthTitleLabel.text = "Координаты"
        sixthLabel.text = "\(element.gpsX), \(element.gpsY)"
        seventhTitleLabel.text = "Режим работы"
        seventhLabel.text = element.workTime
        eighthTitleLabel.text = "Тип банкомата"
        eighthLabel.text = element.atmType.rawValue
        ninthTitleLabel.text = "Банкомат работает"
        ninthLabel.text = element.atmError.rawValue
        tenthTitleLabel.text = "Печатает чек"
        tenthLabel.text = element.atmPrinter.rawValue
        eleventhTitleLabel.text = "Валюта"
        eleventhLabel.text = element.fixCurrency.rawValue
        thirteenthTitleLabel.text = "Наличие cash in"
        thirteenthLabel.text = element.cashIn.rawValue

        coordinateUserLocation = coord
        belarusbankCoordinate = (element.coordinate.latitude, element.coordinate.longitude)
    }

    func infoStandDataInDetails(element: InformationStand, coord: (x: Double, y: Double)) {
        navigationItem.title = "Инфокиоск"

        firstTitleLabel.text = "ID инфокиоска"
        firstLabel.text = "\(element.infoId)"
        secondTitleLabel.text = "Область"
        secondLabel.text = element.area.rawValue
        thirdTitleLabel.text = "Город"
        thirdLabel.text = "\(element.fixCityType.rawValue) \(element.city)"
        fourthTitleLabel.text = "Адрес"
        fourthLabel.text = "\(element.addressType.rawValue) \(element.address) \(element.house)"
        fifthTitleLabel.text = "Место установки"
        fifthLabel.text = element.installPlace
        sixthTitleLabel.text = "Координаты"
        sixthLabel.text = "\(element.gpsX), \(element.gpsY)"
        seventhTitleLabel.text = "Режим работы"
        seventhLabel.text = element.workTime
        eighthTitleLabel.text = "Тип инфокиоска"
        eighthLabel.text = element.infType.rawValue
        ninthTitleLabel.text = "Инфокиоск работает"
        ninthLabel.text = element.infStatus.rawValue
        tenthTitleLabel.text = "Печатает чек"
        tenthLabel.text = element.infPrinter.rawValue
        eleventhTitleLabel.text = "Валюта"
        eleventhLabel.text = element.fixCurrency.rawValue
        thirteenthTitleLabel.text = "Наличие cash in"
        thirteenthLabel.text = element.cashIn.rawValue

        coordinateUserLocation = coord
        belarusbankCoordinate = (element.coordinate.latitude, element.coordinate.longitude)
    }

    func bankDataInDetails(element: Bank, coord: (x: Double, y: Double)) {
        navigationItem.title = "Банк"

        firstTitleLabel.text = "ID банка"
        firstLabel.text = element.filialId
        secondTitleLabel.text = "SAP ID"
        secondLabel.text = element.sapId
        thirdTitleLabel.text = "Название"
        thirdLabel.text = element.filialName
        fourthTitleLabel.text = "№ филиала"
        fourthLabel.text = element.filialNum
        fifthTitleLabel.text = "№ ЦБУ"
        fifthLabel.text = element.cbuNum
        sixthTitleLabel.text = "Город"
        sixthLabel.text = "\(element.cityType) \(element.city)"
        seventhTitleLabel.text = "Адрес"
        seventhLabel.text = "\(element.addressType) \(element.address) \(element.house)"
        eighthTitleLabel.text = "Режим работы"
        eighthLabel.text = element.infoWorktime
        ninthTitleLabel.text = "Номер телефона"
        ninthLabel.text = element.phoneInfo
        tenthTitleLabel.text = "Координаты"
        tenthLabel.text =  "\(element.gpsX), \(element.gpsY)"
        eleventhTitleLabel.text = "№ р/сч (бел)"
        eleventhLabel.text = element.belNumberSchet
        thirteenthTitleLabel.text = "№ р/сч (валюта)"
        thirteenthLabel.text = element.foreignNumberSchet

        coordinateUserLocation = coord
        belarusbankCoordinate = (element.coordinate.latitude, element.coordinate.longitude)
    }

    @objc func backButtonItemTap() {
        dismiss(animated: true, completion: nil)
    }

    @objc func createRouteButtonTap() {
        let latitude: CLLocationDegrees = coordinateUserLocation.x
        let longitude: CLLocationDegrees = coordinateUserLocation.y
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(
            latitude: latitude, longitude: longitude)))
        source.name = "Мое местоположение"
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(
            latitude: belarusbankCoordinate.x, longitude: belarusbankCoordinate.y)))
        destination.name = "Беларусбанк местоположение"

        MKMapItem.openMaps(
            with: [source, destination],
            launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        )
    }

}
