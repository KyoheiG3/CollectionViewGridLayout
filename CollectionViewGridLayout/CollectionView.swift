//
//  CollectionView.swift
//  CollectionViewGridLayout
//
//  Created by Kyohei Ito on 2017/07/25.
//  Copyright © 2017年 Kyohei Ito. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {
    var isInfinitable = true
    internal private(set) lazy var factor: Int = self.isInfinitable ? 2 : 1

    override func layoutSubviews() {
        super.layoutSubviews()

        guard isInfinitable else {
            return
        }

        let factor = CGFloat(self.factor)
        let size = CGSize(width: contentSize.width / factor, height: contentSize.height)
        if contentOffset.x < 0 {
            contentOffset.x += size.width
        } else if contentOffset.x >= size.width {
            contentOffset.x -= size.width
        }

        contentInset.right = -size.width + bounds.width
        layoutIfNeeded()
    }

}

extension UICollectionView {
    var numberOfColumns: Int {
        return numberOfSections
    }

    func numberOfItems(inColumn column: Int) -> Int {
        return numberOfItems(inSection: column)
    }
}
