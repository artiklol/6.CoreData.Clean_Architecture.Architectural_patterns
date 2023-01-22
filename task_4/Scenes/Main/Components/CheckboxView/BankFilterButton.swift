//
//  BankFilterButton.swift
//  task_4
//
//  Created by Artem Sulzhenko on 20.01.2023.
//

import UIKit

class BankFilterButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let checkedImage = UIImage(named: "CheckedCheckbox")?.withRenderingMode(.alwaysTemplate)
        setImage(checkedImage, for: .selected)
        let uncheckedImage = UIImage(named: "UncheckedCheckbox")?.withRenderingMode(.alwaysTemplate)
        setImage(uncheckedImage, for: .normal)
        tintColor = UIColor(named: "BlackWhite")
        backgroundColor = .none
        isSelected = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
