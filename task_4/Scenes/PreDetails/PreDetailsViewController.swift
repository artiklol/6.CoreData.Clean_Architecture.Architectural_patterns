//
//  PreDetailsViewController.swift
//  task_4
//
//  Created by Artem Sulzhenko on 19.01.2023.
//

import UIKit

protocol PreDetailsDisplayLogic: AnyObject {
    func displayData(viewModel: PreDetails.FetchData.ViewModel)
}

class PreDetailsViewController: UIViewController, PreDetailsDisplayLogic {

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

    var interactor: PreDetailsBusinessLogic?
    var router: (NSObjectProtocol & PreDetailsRoutingLogic & PreDetailsDataPassing)?
    private var data: MainDataStore?

    func configure(viewModel: MainDataStore) {
        self.data = viewModel
    }
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        PreDetailsConfigurator.shared.configure(with: self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        PreDetailsConfigurator.shared.configure(with: self)
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")

        addUIContent()
        setConstraint()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            if let sheet = self.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersEdgeAttachedInCompactHeight = true
            }
        } else {
            if let sheet = self.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersEdgeAttachedInCompactHeight = false
            }
        }
    }

    // MARK: Do something
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

    func doSomething() {
        let request = PreDetails.FetchData.Request()
        interactor?.fetchData(request: request)
    }

    func displayData(viewModel: PreDetails.FetchData.ViewModel) {
        nameObjectLabel.text = viewModel.displayedData.installPlace
        workTimeTitleLabel.text = "Режим работы"
        workTimeLabel.text = viewModel.displayedData.workTime

        if viewModel.displayedData.currency != nil {
            firstTitleLabel.text = "Валюта"
            firstLabel.text = viewModel.displayedData.currency
        } else {
            firstTitleLabel.text = "Адрес"
            firstLabel.text = viewModel.displayedData.fullAddress
        }

        if viewModel.displayedData.cashIn != nil {
            secondTitleLabel.text = "Наличие cash in"
            secondLabel.text = viewModel.displayedData.cashIn
        } else {
            secondTitleLabel.text = "Телефон"
            secondLabel.text = viewModel.displayedData.phone
        }

    }

    @objc func detailButtonTap() {
        router?.routeToDetails()
    }
}
