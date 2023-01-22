//
//  ListCollectionView.swift
//  task_4
//
//  Created by Artem Sulzhenko on 17.01.2023.
//

import UIKit
import CoreLocation

class ListCollectionView: UICollectionView {

    init(frame: CGRect) {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        super.init(frame: .zero, collectionViewLayout: viewLayout)

        isHidden = true
        backgroundColor = UIColor(named: "ViewBackgroundColor")

        register(ListCell.self,
                 forCellWithReuseIdentifier: ListCell.identifier)
        register(HeaderCollectionReusableView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: HeaderCollectionReusableView.reuserId)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
