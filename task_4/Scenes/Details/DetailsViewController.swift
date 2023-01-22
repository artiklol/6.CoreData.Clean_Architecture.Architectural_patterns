//
//  DetailsViewController.swift
//  task_4
//
//  Created by Artem Sulzhenko on 22.01.2023.
//

import UIKit
import CoreLocation
import MapKit

protocol DetailsDisplayLogic: AnyObject {
    func displayData(viewModel: Details.FetchData.ViewModel)
}

class DetailsViewController: UIViewController, DetailsDisplayLogic {

    var interactor: DetailsBusinessLogic?
    var router: (NSObjectProtocol & DetailsDataPassing)?

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

    private lazy var destination = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")

        setNavigationBar()
        addUIContent()
        setConstraint()
        getData()
    }

    func getData() {
        let request = Details.FetchData.Request()
        interactor?.fetchData(request: request)
    }

    func displayData(viewModel: Details.FetchData.ViewModel) {
        if let atm = viewModel.displayedData as? ATM {
            displayAtm(atm: atm)
        } else if let infoStand = viewModel.displayedData as? InformationStand {
            displayInfoStand(infoStand: infoStand)
        } else if let bank = viewModel.displayedData as? Bank {
            displayBank(bank: bank)
        }
    }

    private func displayAtm(atm: ATM) {
        navigationItem.title = "Банкомат"

        firstTitleLabel.text = "ID банкомата"
        firstLabel.text = atm.id
        secondTitleLabel.text = "Область"
        secondLabel.text = atm.area.rawValue
        thirdTitleLabel.text = "Город"
        thirdLabel.text = "\(atm.fixCityType.rawValue) \(atm.city)"
        fourthTitleLabel.text = "Адрес"
        fourthLabel.text = "\(atm.addressType.rawValue) \(atm.address) \(atm.house)"
        fifthTitleLabel.text = "Место установки"
        fifthLabel.text = atm.installPlace
        sixthTitleLabel.text = "Координаты"
        sixthLabel.text = "\(atm.gpsX), \(atm.gpsY)"
        seventhTitleLabel.text = "Режим работы"
        seventhLabel.text = atm.workTime
        eighthTitleLabel.text = "Тип банкомата"
        eighthLabel.text = atm.atmType.rawValue
        ninthTitleLabel.text = "Банкомат работает"
        ninthLabel.text = atm.atmError.rawValue
        tenthTitleLabel.text = "Печатает чек"
        tenthLabel.text = atm.atmPrinter.rawValue
        eleventhTitleLabel.text = "Валюта"
        eleventhLabel.text = atm.fixCurrency.rawValue
        thirteenthTitleLabel.text = "Наличие cash in"
        thirteenthLabel.text = atm.cashIn.rawValue

        destination = CLLocationCoordinate2D(latitude: Double(atm.gpsX) ?? 0,
                                             longitude: Double(atm.gpsY) ?? 0)
    }

    private func displayInfoStand(infoStand: InformationStand) {
        navigationItem.title = "Инфокиоск"

        firstTitleLabel.text = "ID инфокиоска"
        firstLabel.text = "\(infoStand.infoId)"
        secondTitleLabel.text = "Область"
        secondLabel.text = infoStand.area.rawValue
        thirdTitleLabel.text = "Город"
        thirdLabel.text = "\(infoStand.fixCityType.rawValue) \(infoStand.city)"
        fourthTitleLabel.text = "Адрес"
        fourthLabel.text = "\(infoStand.addressType.rawValue) \(infoStand.address) \(infoStand.house)"
        fifthTitleLabel.text = "Место установки"
        fifthLabel.text = infoStand.installPlace
        sixthTitleLabel.text = "Координаты"
        sixthLabel.text = "\(infoStand.gpsX), \(infoStand.gpsY)"
        seventhTitleLabel.text = "Режим работы"
        seventhLabel.text = infoStand.workTime
        eighthTitleLabel.text = "Тип инфокиоска"
        eighthLabel.text = infoStand.infType.rawValue
        ninthTitleLabel.text = "Инфокиоск работает"
        ninthLabel.text = infoStand.infStatus.rawValue
        tenthTitleLabel.text = "Печатает чек"
        tenthLabel.text = infoStand.infPrinter.rawValue
        eleventhTitleLabel.text = "Валюта"
        eleventhLabel.text = infoStand.fixCurrency.rawValue
        thirteenthTitleLabel.text = "Наличие cash in"
        thirteenthLabel.text = infoStand.cashIn.rawValue

        destination = CLLocationCoordinate2D(latitude: Double(infoStand.gpsX) ?? 0,
                                             longitude: Double(infoStand.gpsY) ?? 0)
    }

    private func displayBank(bank: Bank) {
        navigationItem.title = "Банк"

        firstTitleLabel.text = "ID банка"
        firstLabel.text = bank.filialId
        secondTitleLabel.text = "SAP ID"
        secondLabel.text = bank.sapId
        thirdTitleLabel.text = "Название"
        thirdLabel.text = bank.filialName
        fourthTitleLabel.text = "№ филиала"
        fourthLabel.text = bank.filialNum
        fifthTitleLabel.text = "№ ЦБУ"
        fifthLabel.text = bank.cbuNum
        sixthTitleLabel.text = "Город"
        sixthLabel.text = "\(bank.cityType) \(bank.city)"
        seventhTitleLabel.text = "Адрес"
        seventhLabel.text = "\(bank.addressType) \(bank.address) \(bank.house)"
        eighthTitleLabel.text = "Режим работы"
        eighthLabel.text = bank.infoWorktime
        ninthTitleLabel.text = "Номер телефона"
        ninthLabel.text = bank.phoneInfo
        tenthTitleLabel.text = "Координаты"
        tenthLabel.text =  "\(bank.gpsX), \(bank.gpsY)"
        eleventhTitleLabel.text = "№ р/сч (бел)"
        eleventhLabel.text = bank.belNumberSchet
        thirteenthTitleLabel.text = "№ р/сч (валюта)"
        thirteenthLabel.text = bank.foreignNumberSchet

        destination = CLLocationCoordinate2D(latitude: Double(bank.gpsX) ?? 0,
                                             longitude: Double(bank.gpsY) ?? 0)
    }

    @objc func backButtonItemTap() {
        dismiss(animated: true, completion: nil)
    }

    @objc func createRouteButtonTap() {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        let defaultLocation = CLLocation(latitude: 52.425163, longitude: 31.015039)
        let userLocation = locationManager.location ?? defaultLocation

        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude)))
        source.name = "Мое местоположение"
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(
            latitude: destination.latitude, longitude: destination.longitude)))
        destination.name = "Беларусбанк местоположение"

        MKMapItem.openMaps(
            with: [source, destination],
            launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        )
    }
}

extension DetailsViewController {
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
}

extension DetailsViewController {
    private func setup() {
        let viewController = self
        let interactor = DetailsInteractor()
        let presenter = DetailsPresenter()
        let router = DetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
