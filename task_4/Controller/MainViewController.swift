//
//  MainViewController.swift
//  task_4
//
//  Created by Artem Sulzhenko on 29.12.2022.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation
import SystemConfiguration

class MainViewController: UIViewController {

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .unspecified
        return map
    }()

    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Карта", "Список"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = UIColor(named: "SegmentControlBackgroundColor")
        guard let borderColor = UIColor(named: "BorderColor") else { return segmentControl }
        segmentControl.layer.borderColor =  UIColor(named: "Gray")?.cgColor
        segmentControl.selectedSegmentTintColor = UIColor(named: "Green")
        segmentControl.layer.borderWidth = 0.5

        let textAttributNormal = [NSAttributedString.Key.foregroundColor: UIColor(named: "BlackWhite")]
        segmentControl.setTitleTextAttributes(textAttributNormal as [NSAttributedString.Key: Any], for: .normal)

        let textAttributChange = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(textAttributChange, for: .selected)
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        return segmentControl
    }()

    private lazy var listCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = UIColor(named: "ViewBackgroundColor")
        return collectionView
    }()

    let checkboxStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.layer.cornerRadius = 10
        stackView.backgroundColor = .none
        return stackView
    }()

    let chekboxView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        view.layer.cornerRadius = 10
        guard let borderColor = UIColor(named: "BorderColor") else { return view }
        view.layer.borderColor =  UIColor(named: "Gray")?.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()

    private lazy var atmFilterButton = UIButton()
    private lazy var atmFilterLabel = UILabel()
    private lazy var atmFilterStackView = UIStackView()
    private lazy var infoStandFilterButton = UIButton()
    private lazy var infoStandFilterLabel = UILabel()
    private lazy var infoStandFilterStackView = UIStackView()
    private lazy var bankFilterButton = UIButton()
    private lazy var bankFilterLabel = UILabel()
    private lazy var bankFilterStackView = UIStackView()

    private lazy var locationManager = CLLocationManager()
    private lazy var refreshButton = UIBarButtonItem(title: "Обновить", style: .plain, target: self,
                                                     action: #selector(refreshButtonTapped))
    private lazy var filterButton = UIBarButtonItem(title: "Фильтр", style: .plain, target: self,
                                                    action: #selector(filterButtonButtonTapped))

    private lazy var overlayActivityView = UIView()
    private lazy var activityIndicatorView = UIActivityIndicatorView()

    private lazy var sectionCity = [String]()
    private lazy var allDataBelarusbank = [BelarusBank]()
    private lazy var bufferBelarusbank = [BelarusBank]()
    private lazy var atmActivity = true
    private lazy var infoStandActivity = true
    private lazy var bankActivity = true
    private lazy var atmNameType = "Банкомат"
    private lazy var infoStandNameType = "Инфокиоск"
    private lazy var bankNameType = "Банк"

    private lazy var preliminaryDetails = PreliminaryDetailsViewController()

    private lazy var coordinateDoubleUserLocation: (x: Double, y: Double) = (0, 0)
    private lazy var coordinateUserLocation = CLLocation(latitude: 0, longitude: 0)
    private lazy var defaultLocation = CLLocation(latitude: 52.425163, longitude: 31.015039)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")

        mapView.delegate = self

        addUIContent()
        setNavigationBar()
        setListCollection()
        setConstraint()
        checkNetworkBeforeFetchingData()
        checkAuthorization()
        segmentControlValueChanged(segmentControl)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setSheetOrientation()
    }

    private func addUIContent() {
        view.addSubview(mapView)
        view.addSubview(listCollectionView)
        view.addSubview(segmentControl)
        infoStandFilterStackView.addArrangedSubview(infoStandFilterButton)
        infoStandFilterStackView.addArrangedSubview(infoStandFilterLabel)
        bankFilterStackView.addArrangedSubview(bankFilterButton)
        bankFilterStackView.addArrangedSubview(bankFilterLabel)
        chekboxView.addSubview(checkboxStackView)
        view.addSubview(chekboxView)
        setButtonAndTitleInStackView(button: atmFilterButton, label: atmFilterLabel,
                                     title: atmNameType, color: "Green", stackView: atmFilterStackView)
        setButtonAndTitleInStackView(button: infoStandFilterButton, label: infoStandFilterLabel,
                                     title: infoStandNameType, color: "GreenTwo",
                                     stackView: infoStandFilterStackView)
        setButtonAndTitleInStackView(button: bankFilterButton, label: bankFilterLabel, title: bankNameType,
                                     color: "GreenThree", stackView: bankFilterStackView)
    }

    private func setListCollection() {
        listCollectionView.dataSource = self
        listCollectionView.delegate = self

        listCollectionView.register(CollectionViewCell.self,
                                    forCellWithReuseIdentifier: CollectionViewCell.identifier)
        listCollectionView.register(HeaderCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: HeaderCollectionReusableView.reuserId)

    }

    private func setNavigationBar() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.overrideUserInterfaceStyle = .unspecified
        let navBarAppearance = UINavigationBarAppearance()
        navigationBar?.standardAppearance = navBarAppearance
        navigationBar?.scrollEdgeAppearance = navBarAppearance
        navigationItem.title = "Беларусбанк"
        navigationItem.rightBarButtonItem = refreshButton
        navigationItem.leftBarButtonItem = filterButton
    }

    private func setConstraint() {
        mapView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.left.right.bottom.equalTo(view)
        }
        segmentControl.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            maker.left.right.equalTo(view).inset(40)
            maker.height.equalTo(30)
        }
        listCollectionView.snp.makeConstraints { maker in
            maker.top.equalTo(segmentControl.snp.bottom).offset(10)
            maker.left.right.bottom.equalTo(view)
        }
        chekboxView.snp.makeConstraints { maker in
            maker.top.left.equalTo(mapView).inset(5)
            maker.height.equalTo(105)
            maker.width.equalTo(133)
        }
        checkboxStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalTo(chekboxView)
        }
    }

    private func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    private func startActivityView() {
        overlayActivityView.backgroundColor = .gray.withAlphaComponent(0.7)
        overlayActivityView.frame = view.frame
        activityIndicatorView.style = UIActivityIndicatorView.Style.large
        activityIndicatorView.color = .white
        activityIndicatorView.center = CGPoint(x: overlayActivityView.bounds.width / 2,
                                               y: overlayActivityView.bounds.height / 2)
        overlayActivityView.addSubview(activityIndicatorView)
        view.addSubview(overlayActivityView)
        refreshButton.isHidden = true
        filterButton.isHidden = true
        activityIndicatorView.startAnimating()
    }

    private func stopActivityView() {
        refreshButton.isHidden = false
        filterButton.isHidden = false
        activityIndicatorView.stopAnimating()
        overlayActivityView.removeFromSuperview()
    }

    private func setButtonAndTitleInStackView(button: UIButton, label: UILabel, title: String,
                                              color: String, stackView: UIStackView) {
        let origImage = UIImage(named: "CheckedCheckbox")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor(named: "BlackWhite")
        button.backgroundColor = .none
        button.addTarget(self, action: #selector(filterButtonsTap), for: .touchUpInside)

        label.font = label.font.withSize(17)
        label.text = title
        label.textColor = UIColor(named: color)
        label.textAlignment = .left

        stackView.axis = .horizontal
        stackView.spacing = 2

        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(label)

        checkboxStackView.addArrangedSubview(stackView)

        button.snp.makeConstraints { maker in
            maker.left.equalTo(checkboxStackView)
            maker.height.width.equalTo(30)
        }
    }

    private func addAndSortData(data: [BelarusBank]) {
        allDataBelarusbank += data
        checkAuthorization()
        if locationAuthorizationStatus() == .authorizedWhenInUse {
            allDataBelarusbank = allDataBelarusbank.sorted {
                CLLocation(latitude: $0.coordinate.latitude,
                           longitude: $0.coordinate.longitude).distance(
                            from: coordinateUserLocation) < CLLocation(latitude: $1.coordinate.latitude,
                                                                       longitude: $1.coordinate.longitude).distance(
                                                                        from: coordinateUserLocation) }
        } else {
            allDataBelarusbank = allDataBelarusbank.sorted {
                CLLocation(latitude: $0.coordinate.latitude,
                           longitude: $0.coordinate.longitude).distance(
                            from: defaultLocation) < CLLocation(latitude: $1.coordinate.latitude,
                                                                longitude: $1.coordinate.longitude).distance(
                                                                    from: defaultLocation) }
        }
    }

    private func addSortedCity() {
        sectionCity = []
        var citySet = Set<String>()
        for element in allDataBelarusbank {
            if !citySet.contains(element.cityBelarusbank) {
                sectionCity.append(element.cityBelarusbank)
            }
            citySet.insert(element.cityBelarusbank)
        }
        listCollectionView.reloadData()
    }

    private func showAlertStatusCodeError(statusCode: Int, text: String) {
        let alert = UIAlertController(title: "Код ответа \(statusCode)",
                                      message: "Произошла неизвестная сетевая ошибка. " +
                                      "Не удалось получить данные \(text).",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Повторить ещё раз", style: .default) { _ in
            self.fethData()
        })
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))

        stopActivityView()
        present(alert, animated: true, completion: nil)
    }

    private func removeDataModel(nameTypeModel: String) {
        allDataBelarusbank = allDataBelarusbank.filter { $0.typeName != nameTypeModel }
        addSortedCity()
    }

    private func removeAnnotationsModel(nameTypeModel: String) {
        mapView.removeAnnotations(mapView.annotations.filter { $0.title == nameTypeModel })
    }

    private func fethData() {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "by.clevertec.task_5", qos: .background, attributes: [.concurrent])
        let atmTypeName = atmNameType
        let infoStandTypeName = infoStandNameType
        let bankTypeName = bankNameType

        startActivityView()

        if !atmActivity && !infoStandActivity && !bankActivity {
            stopActivityView()
            let alert = UIAlertController(title: "Не выбран тип данных",
                                          message: "Нажмите кнопку фильтр. " +
                                          "В списе выберете тип данных.",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))

            present(alert, animated: true, completion: nil)
        }

        if atmActivity {
            group.enter()
            NetworkManager.fetchDataAtm { [weak self] atms, statusCode in
                if statusCode >= 200 && statusCode < 300 {
                    self?.removeAnnotationsModel(nameTypeModel: atmTypeName)
                    self?.removeDataModel(nameTypeModel: atmTypeName)
                    self?.addPoints(list: atms, title: atmTypeName)
                    self?.addAndSortData(data: atms)
                    self?.addSortedCity()
                    self?.stopActivityView()
                    group.leave()
                } else {
                    self?.showAlertStatusCodeError(statusCode: statusCode, text: atmTypeName)
                    group.leave()
                }
            }
        }

        if infoStandActivity {
            group.enter()
            queue.async(group: group) {
                NetworkManager.fetchDataInformationStand { [weak self] infoStands, statusCode in
                    if statusCode >= 200 && statusCode < 300 {
                        self?.removeAnnotationsModel(nameTypeModel: infoStandTypeName)
                        self?.removeDataModel(nameTypeModel: infoStandTypeName)
                        self?.addPoints(list: infoStands, title: infoStandTypeName)
                        self?.addAndSortData(data: infoStands)
                        self?.addSortedCity()
                        group.leave()
                    } else {
                        self?.showAlertStatusCodeError(statusCode: statusCode, text: infoStandTypeName)
                        group.leave()
                    }
                }
            }
        }

        if bankActivity {
            group.enter()
            queue.async(group: group) {
                NetworkManager.fetchDataBank { [weak self] banks, statusCode in
                    if statusCode >= 200 && statusCode < 300 {
                        self?.removeAnnotationsModel(nameTypeModel: bankTypeName)
                        self?.removeDataModel(nameTypeModel: bankTypeName)
                        self?.addPoints(list: banks, title: bankTypeName)
                        self?.addAndSortData(data: banks)
                        self?.addSortedCity()
                        group.leave()
                    } else {
                        self?.showAlertStatusCodeError(statusCode: statusCode, text: bankTypeName)
                        group.leave()
                    }
                }
            }
        }

    }

    private func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else { return false }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    private func checkNetworkBeforeFetchingData() {
        if isConnectedToNetwork() {
            fethData()
        } else {
            let alert = UIAlertController(title: "Отсутствует интернет",
                                          message: "Проверьте ваше соединение с интернетом",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    private func setRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.setRegion(region, animated: true)
    }

    private func addPoints(list: [BelarusBank], title: String) {
        for element in list {
            let pinLocation = element.coordinate
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = title

            if let atm = element as? ATM {
                objectAnnotation.subtitle = atm.id
            } else if let infoStand = element as? InformationStand {
                objectAnnotation.subtitle = "\(infoStand.infoId)"
            } else if let bank = element as? Bank {
                objectAnnotation.subtitle = bank.filialId
            }

            mapView.addAnnotation(objectAnnotation)
        }
    }

    private func checkAuthorization() {
        switch locationAuthorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.userLocation.title = "Я"
            mapView.userLocation.subtitle = "Я"
        case .denied:
            let alert = UIAlertController(title: nil,
                                          message: "Для продолжения работы этому приложению требуется " +
                                          "доступ к вашей геолокации. Вы хотите предоставить доступ?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Открыть настройки", style: .default) { _ in
                if let urlSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(urlSetting)
                }})
            alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))

            present(alert, animated: true, completion: nil)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        setupManager()
        guard let userCoordinate: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        setRegion(coordinate: userCoordinate)
    }

    private func locationAuthorizationStatus() -> CLAuthorizationStatus {
        let locationManager = CLLocationManager()
        var locationAuthorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            locationAuthorizationStatus =  locationManager.authorizationStatus
        } else {
            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        }
        return locationAuthorizationStatus
    }

    private func setSheetOrientation() {
        if UIDevice.current.orientation.isLandscape {
            if let sheet = preliminaryDetails.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersEdgeAttachedInCompactHeight = true
            }
        } else {
            if let sheet = preliminaryDetails.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersEdgeAttachedInCompactHeight = false
            }
        }
    }

    private func showPreDetails(element: BelarusBank) {
        if let atm = element as? ATM {
            preliminaryDetails.atmElementInPreDetails(element: atm, coordinate: coordinateDoubleUserLocation)
        } else if let infoStand = element as? InformationStand {
            preliminaryDetails.infoStandElementInPreDetails(element: infoStand,
                                                            coordinate: coordinateDoubleUserLocation)
        } else if let bank = element as? Bank {
            preliminaryDetails.bankElementInPreDetails(element: bank, coordinate: coordinateDoubleUserLocation)
        }
        setSheetOrientation()

        present(preliminaryDetails, animated: true, completion: nil)
    }

    private func addTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
            self.chekboxView.isHidden = false
        }, completion: nil)
    }

    private func removeTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
            self.chekboxView.isHidden = true
        }, completion: nil)
    }

    private func showAndHideElements(typeName: String) {
        if  bufferBelarusbank.filter({ $0.typeName == typeName }).isEmpty {
            mapView.removeAnnotations(mapView.annotations.filter { $0.title == typeName })
            bufferBelarusbank += allDataBelarusbank.filter({ $0.typeName == typeName })
            allDataBelarusbank.removeAll(where: { $0.typeName == typeName })
            sectionCity = sectionCity.filter { city in
                allDataBelarusbank.contains { $0.cityBelarusbank == city }
            }
            listCollectionView.reloadData()

            let tintedImage = UIImage(named: "UncheckedCheckbox")?.withRenderingMode(.alwaysTemplate)

            if typeName == atmNameType {
                atmActivity = false
                atmFilterButton.setImage(tintedImage, for: .normal)
                atmFilterButton.tintColor = UIColor(named: "BlackWhite")
                atmFilterLabel.textColor = UIColor(named: "BlackWhite")
            } else if typeName == infoStandNameType {
                infoStandActivity = false
                infoStandFilterButton.setImage(tintedImage, for: .normal)
                infoStandFilterButton.tintColor = UIColor(named: "BlackWhite")
                infoStandFilterLabel.textColor = UIColor(named: "BlackWhite")
            } else if typeName == bankNameType {
                bankActivity = false
                bankFilterButton.setImage(tintedImage, for: .normal)
                bankFilterButton.tintColor = UIColor(named: "BlackWhite")
                bankFilterLabel.textColor = UIColor(named: "BlackWhite")
            }
        } else {
            addPoints(list: bufferBelarusbank.filter({ $0.typeName == typeName }), title: typeName)
            addAndSortData(data: bufferBelarusbank.filter({ $0.typeName == typeName }))
            bufferBelarusbank.removeAll(where: { $0.typeName == typeName })
            sectionCity = []
            addSortedCity()

            let tintedImage = UIImage(named: "CheckedCheckbox")?.withRenderingMode(.alwaysTemplate)

            if typeName == atmNameType {
                atmActivity = true
                atmFilterButton.setImage(tintedImage, for: .normal)
                atmFilterButton.tintColor = UIColor(named: "BlackWhite")
                atmFilterLabel.textColor = UIColor(named: "Green")
            } else if typeName == infoStandNameType {
                infoStandActivity = true
                infoStandFilterButton.setImage(tintedImage, for: .normal)
                infoStandFilterButton.tintColor = UIColor(named: "BlackWhite")
                infoStandFilterLabel.textColor = UIColor(named: "GreenTwo")
            } else if typeName == bankNameType {
                bankActivity = true
                bankFilterButton.setImage(tintedImage, for: .normal)
                bankFilterButton.tintColor = UIColor(named: "BlackWhite")
                bankFilterLabel.textColor = UIColor(named: "GreenThree")
            }
        }
    }

    @objc func segmentControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.isHidden = false
            listCollectionView.isHidden = true
        case 1:
            mapView.isHidden = true
            listCollectionView.isHidden = false
        default:
            break
        }
    }

    @objc func refreshButtonTapped() {
        checkNetworkBeforeFetchingData()
    }

    @objc func filterButtonButtonTapped() {
        if chekboxView.isHidden {
            addTransparentView()
        } else {
            removeTransparentView()
        }
    }

    @objc func filterButtonsTap(button: UIButton) {
        switch button {
        case atmFilterButton:
            showAndHideElements(typeName: atmNameType)
        case infoStandFilterButton:
            showAndHideElements(typeName: infoStandNameType)
        case bankFilterButton:
            showAndHideElements(typeName: bankNameType)
        default:
            break
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            coordinateDoubleUserLocation.x = location.coordinate.latitude
            coordinateDoubleUserLocation.y = location.coordinate.longitude
            coordinateUserLocation = location
        }
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let subtitle = view.annotation?.subtitle, let subtitleValue = subtitle else { return }

        if subtitle != "Я" {
            var indexResult = 0
            for index in 0..<allDataBelarusbank.count where allDataBelarusbank[index].mainId == subtitleValue {
                indexResult = index
            }
            setRegion(coordinate: allDataBelarusbank[indexResult].coordinate)
            showPreDetails(element: allDataBelarusbank[indexResult])
            mapView.deselectAnnotation(view.annotation, animated: false)
        }

    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "ballonPin"
        let meTitle = "Я"
        let annotationBalloon = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)

        if annotation.title == meTitle {
            annotationBalloon.glyphImage = UIImage(named: "Human")
            annotationBalloon.glyphTintColor = .white
        } else if annotation.title == atmNameType {
            annotationBalloon.glyphImage = UIImage(named: "ATM")
            annotationBalloon.markerTintColor = UIColor(named: "Green")
        } else if annotation.title == infoStandNameType {
            annotationBalloon.glyphImage = UIImage(named: "InfoStand")
            annotationBalloon.markerTintColor = UIColor(named: "GreenTwo")
        } else if annotation.title == bankNameType {
            annotationBalloon.glyphImage = UIImage(named: "Bank")
            annotationBalloon.markerTintColor = UIColor(named: "GreenThree")
        }
        return annotationBalloon
    }

}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCity.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDataBelarusbank.filter { $0.cityBelarusbank == sectionCity[section] }.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cellData = allDataBelarusbank.filter { $0.cityBelarusbank == sectionCity[indexPath.section] }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier,
                                                            for: indexPath) as? CollectionViewCell else {
            return CollectionViewCell()
        }

        if let atm = cellData[indexPath.row] as? ATM {
            cell.dataAtmInCell(element: atm)
        } else if let info = cellData[indexPath.row] as? InformationStand {
            cell.dataInfoStandInCell(element: info)
        } else if let bank = cellData[indexPath.row] as? Bank {
            cell.dataBankInCell(element: bank)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reuserId, for: indexPath)
        guard let typedHeaderView = header as? HeaderCollectionReusableView else { return header }

        typedHeaderView.setTitleHeader(title: "\(sectionCity[indexPath.section])")
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = allDataBelarusbank.filter { $0.cityBelarusbank == sectionCity[indexPath.section] }
        showPreDetails(element: selectedItem[indexPath.row])
        segmentControl.selectedSegmentIndex = 0
        segmentControlValueChanged(segmentControl)
        setRegion(coordinate: selectedItem[indexPath.row].coordinate)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let interItemSpacing: CGFloat = 5
        let width = (collectionView.bounds.width - (interItemSpacing * (itemsPerRow - 1)) - 20) / itemsPerRow
        return CGSize(width: width, height: width + 25)
    }

}
