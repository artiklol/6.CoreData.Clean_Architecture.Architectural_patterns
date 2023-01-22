//
//  CollectionViewCell.swift
//  task_4
//
//  Created by Artem Sulzhenko on 02.01.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    static let identifier = "BelarusbankList"

    private lazy var nameObjectLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    private lazy var workTimeTitleLabel = UILabel()
    private lazy var workTimeLabel = UILabel()
    private lazy var otherTitleLabel = UILabel()
    private lazy var otherLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 10

        contentView.addSubview(nameObjectLabel)
        setTitleAndInfo(titleLabel: workTimeTitleLabel, titleText: "Режим работы", infoLabel: workTimeLabel)
        setTitleAndInfo(titleLabel: otherTitleLabel, titleText: "Валюта", infoLabel: otherLabel)

        setConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraint() {
        nameObjectLabel.snp.makeConstraints { maker in
            maker.top.left.right.equalTo(contentView).inset(5)
        }
        workTimeTitleLabel.snp.makeConstraints { maker in
            maker.left.right.equalTo(contentView).inset(5)
            maker.bottom.equalTo(workTimeLabel.snp.top).inset(3)
        }
        workTimeLabel.snp.makeConstraints { maker in
            maker.left.right.bottom.equalTo(contentView).inset(5)
            maker.bottom.equalTo(contentView).inset(25)
        }
        otherTitleLabel.snp.makeConstraints { maker in
            maker.left.right.equalTo(contentView).inset(5)
            maker.bottom.equalTo(contentView).inset(15)
        }
        otherLabel.snp.makeConstraints { maker in
            maker.left.right.bottom.equalTo(contentView).inset(5)
        }
    }

    private func setTitleAndInfo(titleLabel: UILabel, titleText: String, infoLabel: UILabel) {
        titleLabel.text = titleText
        titleLabel.font = .boldSystemFont(ofSize: 10)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        infoLabel.font = infoLabel.font.withSize(10)
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 5
        infoLabel.textAlignment = .center

        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
    }

    func dataAtmInCell(element: ATM) {
        contentView.backgroundColor = UIColor(named: "Green")

        nameObjectLabel.text = element.installPlace
        workTimeLabel.text = element.workTime
        otherTitleLabel.text = "Валюта"
        otherLabel.text = element.fixCurrency.rawValue
    }

    func dataInfoStandInCell(element: InformationStand) {
        contentView.backgroundColor = UIColor(named: "GreenTwo")

        nameObjectLabel.text = element.installPlace
        workTimeLabel.text = element.workTime
        otherTitleLabel.text = "Валюта"
        otherLabel.text = element.fixCurrency.rawValue
    }

    func dataBankInCell(element: Bank) {
        contentView.backgroundColor = UIColor(named: "GreenThree")

        nameObjectLabel.text = element.filialName
        workTimeLabel.text = element.infoWorktime
        otherTitleLabel.text = "Телефон"
        otherLabel.text = element.phoneInfo
    }

}
