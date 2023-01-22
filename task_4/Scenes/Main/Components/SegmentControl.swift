//
//  SegmentControl.swift
//  task_4
//
//  Created by Artem Sulzhenko on 20.01.2023.
//

import UIKit

class SegmentControl: UISegmentedControl {

    override init(frame: CGRect) {
        super.init(frame: frame)

        ["Карта", "Список"].enumerated().forEach { index, title in
            insertSegment(withTitle: title, at: index, animated: false)
        }

        selectedSegmentIndex = 0
        backgroundColor = UIColor(named: "SegmentControlBackgroundColor")
        layer.borderColor =  UIColor(named: "Gray")?.cgColor
        selectedSegmentTintColor = UIColor(named: "Green")
        layer.borderWidth = 0.5

        let textAttributNormal = [NSAttributedString.Key.foregroundColor: UIColor(named: "BlackWhite")]
        setTitleTextAttributes(textAttributNormal as [NSAttributedString.Key: Any], for: .normal)

        let textAttributChange = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setTitleTextAttributes(textAttributChange, for: .selected)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
