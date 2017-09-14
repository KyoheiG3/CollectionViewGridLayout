//
//  CollectionViewGridLayout.swift
//  CollectionViewGridLayout
//
//  Created by Kyohei Ito on 2017/07/25.
//  Copyright © 2017年 Kyohei Ito. All rights reserved.
//

import UIKit

protocol CollectionViewDelegateGridLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, widthForColumn column: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
}

class CollectionViewGridLayout: UICollectionViewLayout {
    private var itemAttributes: [[UICollectionViewLayoutAttributes]] = []
    private var contentSize: CGSize = .zero

    override func prepare() {
        guard let collectionView = collectionView, let delegate = collectionView.delegate as? CollectionViewDelegateGridLayout else {
            return
        }

        contentSize = .zero
        itemAttributes = [Int](0..<collectionView.numberOfColumns).map { column in
            let width = delegate.collectionView(collectionView, layout: self, widthForColumn: column)
            let numberOfItems = collectionView.numberOfItems(inColumn: column)
            var heightForColumn: CGFloat = 0

            defer {
                if contentSize.height < heightForColumn {
                    contentSize.height = heightForColumn
                }

                contentSize.width += width
            }

            return [Int](0..<numberOfItems).map { item in
                let indexPath = IndexPath(item: item, column: column)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let height = delegate.collectionView(collectionView, layout: self, heightForItemAt: indexPath)
                attribute.frame = CGRect(x: contentSize.width, y: heightForColumn, width: width, height: height)
                heightForColumn += height

                return attribute
            }
        }
    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.column][indexPath.item]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributes.flatMap { $0.filter { rect.intersects($0.frame) } }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
}
