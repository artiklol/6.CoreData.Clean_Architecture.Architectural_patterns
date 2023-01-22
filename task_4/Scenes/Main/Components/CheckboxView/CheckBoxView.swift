//
//  CheckBoxView.swift
//  task_4
//
//  Created by Artem Sulzhenko on 20.01.2023.
//

import UIKit
import SnapKit

class CheckBoxView: UIView {

    private lazy var checkboxStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.layer.cornerRadius = 10
        stackView.backgroundColor = .none
        return stackView
    }()

    private lazy var atmFilterLabel = UILabel()
    private lazy var atmFilterStackView = UIStackView()
    private lazy var infoStandFilterLabel = UILabel()
    private lazy var infoStandFilterStackView = UIStackView()
    private lazy var bankFilterLabel = UILabel()
    private lazy var bankFilterStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        isHidden = true
        backgroundColor = UIColor(named: "ViewBackgroundColor")
        layer.cornerRadius = 10
        layer.borderColor =  UIColor(named: "Gray")?.cgColor
        layer.borderWidth = 0.5

        addSubview(checkboxStackView)

        setButtonAndTitleInStackView(label: atmFilterLabel, title: ATM.typeNameATM, color: "Green",
                                     stackView: atmFilterStackView)
        setButtonAndTitleInStackView(label: infoStandFilterLabel, title: InformationStand.typeNameInfoStand,
                                     color: "GreenTwo", stackView: infoStandFilterStackView)
        setButtonAndTitleInStackView(label: bankFilterLabel, title: Bank.typeNameBank, color: "GreenThree",
                                     stackView: bankFilterStackView)

        checkboxStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalTo(self)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setButtonAndTitleInStackView(label: UILabel, title: String,
                                              color: String, stackView: UIStackView) {

        label.font = label.font.withSize(17)
        label.text = title
        label.textColor = UIColor(named: color)
        label.textAlignment = .left

        stackView.axis = .horizontal
        stackView.spacing = 2

        checkboxStackView.addArrangedSubview(stackView)
    }

    func addAtmButton(button: UIButton) {
        atmFilterStackView.addArrangedSubview(button)
        atmFilterStackView.addArrangedSubview(atmFilterLabel)

        button.snp.makeConstraints { maker in
            maker.left.equalTo(self).inset(4)
            maker.height.width.equalTo(30)
        }
    }

    func addInfoStandFilterButton(button: UIButton) {
        infoStandFilterStackView.addArrangedSubview(button)
        infoStandFilterStackView.addArrangedSubview(infoStandFilterLabel)

        button.snp.makeConstraints { maker in
            maker.left.equalTo(self).inset(4)
            maker.height.width.equalTo(30)
        }
    }

    func addBankFilterButton(button: UIButton) {
        bankFilterStackView.addArrangedSubview(button)
        bankFilterStackView.addArrangedSubview(bankFilterLabel)

        button.snp.makeConstraints { maker in
            maker.left.equalTo(self).inset(4)
            maker.height.width.equalTo(30)
        }
    }
}
