//
//  MainViewController.swift
//  task_4
//
//  Created by Artem Sulzhenko on 17.01.2023.
//

import UIKit
import MapKit

protocol MainDisplayLogic: AnyObject {
    func displayData(viewModel: Main.FetchData.ViewModel, sectionCity: [String])
    func stopActivityView()
    func atmStatusCode(statusCode: Int)
    func infoStandStatusCode(statusCode: Int)
    func bankStatusCode(statusCode: Int)
    func setRegion(coordinate: CLLocationCoordinate2D)
}

class MainViewController: UIViewController {

    var interactor: MainBusinessLogic?
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?

    private lazy var segmentControl = SegmentControl(frame: .zero)
    private lazy var atmFilterButton = AtmFilterButton()
    private lazy var infoStandFilterButton = InfoStandFilterButton()
    private lazy var bankFilterButton = BankFilterButton()
    private lazy var refreshButton = UIBarButtonItem(title: "Обновить", style: .plain, target: self,
                                                     action: #selector(refreshButtonTapped))
    private lazy var filterButton = UIBarButtonItem(title: "Фильтр", style: .plain, target: self,
                                                    action: #selector(filterButtonButtonTapped))
    private lazy var mapView = MapView()
    private lazy var listCollectionView = ListCollectionView(frame: .zero)
    private lazy var checkBoxView = CheckBoxView()

    private lazy var overlayActivityView = UIView()
    private lazy var activityIndicatorView = UIActivityIndicatorView()

    private lazy var allDataBelarusbank = [Main.FetchData.ViewModel.DisplayedData]()
    private lazy var sectionCity = [String]()

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        MainConfigurator.shared.configure(with: self)
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        mapView.delegate = self
        listCollectionView.delegate = self
        listCollectionView.dataSource = self

        NetworkMonitor.startMonitoringNetwork()
        showAlertAuthorizationStatusDanied()
        addUIElements()
        setConstraint()
        setNavigationBar()
        addActivityToButtons()
        getData()
    }

    // MARK: Get data
    func getData() {
        let request = Main.FetchData.Request()
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "by.clevertec.task_6", qos: .background, attributes: [.concurrent])

        if NetworkMonitor.isConnectedToNetwork {
            group.enter()
            interactor?.fetchDataAtm(request: request)
            guard let interactor = interactor else { return }
            if interactor.needForActivationActivityView {
                startActivityView()
            }
            group.leave()

            group.enter()
            queue.async(group: group) {
                self.interactor?.fetchDataInformationStand(request: request)
                group.leave()
            }

            group.enter()
            queue.async(group: group) {
                self.interactor?.fetchDataBank(request: request)
                group.leave()
            }
        } else {
            countRecordsToCoreData()
            interactor?.fetchAtmFromCoreData()
            interactor?.fetchInfoStandFromCoreData()
            interactor?.fetchBankFromCoreData()
        }
    }

}

extension MainViewController: MainDisplayLogic {
    func displayData(viewModel: Main.FetchData.ViewModel, sectionCity: [String]) {
        mapView.set(data: viewModel.displayedData)
        allDataBelarusbank = viewModel.displayedData
        self.sectionCity = sectionCity
        listCollectionView.reloadData()
    }

    func atmStatusCode(statusCode: Int) {
        showAlertStatusCodeError(statusCode: statusCode, text: ATM.typeNameATM)
    }

    func infoStandStatusCode(statusCode: Int) {
        showAlertStatusCodeError(statusCode: statusCode, text: InformationStand.typeNameInfoStand)
    }

    func bankStatusCode(statusCode: Int) {
        showAlertStatusCodeError(statusCode: statusCode, text: Bank.typeNameBank)
    }

    func stopActivityView() {
        refreshButton.isHidden = false
        filterButton.isHidden = false
        activityIndicatorView.stopAnimating()
        overlayActivityView.removeFromSuperview()
    }

    func setRegion(coordinate: CLLocationCoordinate2D) {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
            mapView.setRegion(region, animated: true)
    }

    private func countRecordsToCoreData() {
        if StorageManager.countRecords(entityName: "ATMCoreData") == 0 &&
            StorageManager.countRecords(entityName: "InfoStandCoreData") == 0 &&
            StorageManager.countRecords(entityName: "BankCoreData") == 0 {
            showAlertFirstNetwork()
        }
    }

    private func showAlertAuthorizationStatusDanied() {
        if mapView.locationAuthorizationStatus() == .denied {
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
        }
    }

    private func showAlertFirstNetwork() {
        let alert = UIAlertController(title: "Отсутствует интернет",
                                      message: "Для первого запуска приложения требуется " +
                                      "подключение к интернету.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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

    private func showAlertStatusCodeError(statusCode: Int, text: String) {
        let alert = UIAlertController(title: "Код ответа \(statusCode)",
                                      message: "Произошла неизвестная сетевая ошибка. " +
                                      "Не удалось получить данные \(text).",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Повторить ещё раз", style: .default) { _ in
            self.getData()
        })
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        stopActivityView()
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController {
    private func addUIElements() {
        view.addSubview(mapView)
        view.addSubview(listCollectionView)
        view.addSubview(segmentControl)
        view.addSubview(checkBoxView)
    }

    private func setConstraint() {
        mapView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.left.right.bottom.equalTo(view)
        }
        listCollectionView.snp.makeConstraints { maker in
            maker.top.equalTo(segmentControl.snp.bottom).offset(10)
            maker.left.right.bottom.equalTo(view)
        }
        segmentControl.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            maker.left.right.equalTo(view).inset(40)
            maker.height.equalTo(30)
        }
        checkBoxView.snp.makeConstraints { maker in
            maker.top.left.equalTo(view.safeAreaLayoutGuide).inset(5)
            maker.height.equalTo(105)
            maker.width.equalTo(133)
        }
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

    private func addActivityToButtons() {
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        atmFilterButton.addTarget(self, action: #selector(filterButtonsTap), for: .touchUpInside)
        infoStandFilterButton.addTarget(self, action: #selector(filterButtonsTap), for: .touchUpInside)
        bankFilterButton.addTarget(self, action: #selector(filterButtonsTap), for: .touchUpInside)
        checkBoxView.addAtmButton(button: atmFilterButton)
        checkBoxView.addInfoStandFilterButton(button: infoStandFilterButton)
        checkBoxView.addBankFilterButton(button: bankFilterButton)
    }
}

extension MainViewController {
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
        getData()
    }

    @objc func filterButtonButtonTapped() {
        if checkBoxView.isHidden {
            checkBoxView.isHidden = false
        } else {
            checkBoxView.isHidden = true
        }
    }

    @objc func filterButtonsTap(button: UIButton) {
        switch button {
        case atmFilterButton:
            if atmFilterButton.isSelected {
                interactor?.hideModelFilter(typeName: ATM.typeNameATM)
                atmFilterButton.isSelected = false
            } else {
                interactor?.showModelFilter(typeName: ATM.typeNameATM)
                atmFilterButton.isSelected = true
            }
        case infoStandFilterButton:
            if infoStandFilterButton.isSelected {
                interactor?.hideModelFilter(typeName: InformationStand.typeNameInfoStand)
                infoStandFilterButton.isSelected = false
            } else {
                interactor?.showModelFilter(typeName: InformationStand.typeNameInfoStand)
                infoStandFilterButton.isSelected = true
            }
        case bankFilterButton:
            if bankFilterButton.isSelected {
                interactor?.hideModelFilter(typeName: Bank.typeNameBank)
                bankFilterButton.isSelected = false
            } else {
                interactor?.showModelFilter(typeName: Bank.typeNameBank)
                bankFilterButton.isSelected = true
            }
        default:
            break
        }
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let subtitle = view.annotation?.subtitle, let subtitleValue = subtitle else { return }
        guard let title = view.annotation?.title else { return }
        let meTitle = "Я"

        if subtitle != meTitle {
            var indexResult = 0
            for index in 0..<allDataBelarusbank.count
            where allDataBelarusbank[index].id == subtitleValue && allDataBelarusbank[index].nameType == title {
                indexResult = index
            }
            setRegion(coordinate: allDataBelarusbank[indexResult].coordinate)
            router?.routeToPreDetails(id: subtitleValue)
            mapView.deselectAnnotation(view.annotation, animated: false)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "ballonPin"
        let annotationBalloon = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let meTitle = "Я"

        if annotation.title == meTitle {
            annotationBalloon.glyphImage = UIImage(named: "Human")
            annotationBalloon.glyphTintColor = .white
        } else if annotation.title == ATM.typeNameATM {
            annotationBalloon.glyphImage = UIImage(named: "ATM")
            annotationBalloon.markerTintColor = UIColor(named: "Green")
        } else if annotation.title == InformationStand.typeNameInfoStand {
            annotationBalloon.glyphImage = UIImage(named: "InfoStand")
            annotationBalloon.markerTintColor = UIColor(named: "GreenTwo")
        } else if annotation.title == Bank.typeNameBank {
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
        return allDataBelarusbank.filter { $0.city == sectionCity[section] }.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cellData = allDataBelarusbank.filter { $0.city == sectionCity[indexPath.section] }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier,
                                                            for: indexPath) as? ListCell else {
            return ListCell()
        }

        if cellData[indexPath.row].nameType == ATM.typeNameATM {
            cell.dataAtmInCell(element: cellData[indexPath.row])
        } else if cellData[indexPath.row].nameType == InformationStand.typeNameInfoStand {
            cell.dataInfoStandInCell(element: cellData[indexPath.row])
        } else if cellData[indexPath.row].nameType == Bank.typeNameBank {
            cell.dataBankInCell(element: cellData[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reuserId, for: indexPath)
        guard let typedHeaderView = header as? HeaderCollectionReusableView else { return header }

        typedHeaderView.setTitleHeader(title: "\(sectionCity[indexPath.section])")
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellData = allDataBelarusbank.filter { $0.city == sectionCity[indexPath.section] }
        segmentControl.selectedSegmentIndex = 0
        segmentControlValueChanged(segmentControl)
        setRegion(coordinate: cellData[indexPath.row].coordinate)
        print(cellData[indexPath.row].installPlace)
        router?.routeToPreDetails(id: cellData[indexPath.row].id)
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
