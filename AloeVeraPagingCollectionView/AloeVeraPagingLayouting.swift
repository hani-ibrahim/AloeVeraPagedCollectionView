//
//  AloeVeraPagingLayouting.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 12.08.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

public protocol AloeVeraPagingLayouting {
    var collectionView: UICollectionView? { get }
    
    func centeredVisibleItem(in bounds: CGRect) -> IndexPath?
    func scrollToItem(at indexPath: IndexPath, in bounds: CGRect)
}

extension AloeVeraPagingLayouting {
    /// Same as `layoutAttributesForElements` method in `UICollectionViewLayout`
    /// But modifying the collection view bounds to match the required size to get correct results
    public func layoutAttributesForElements(in bounds: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            return nil
        }
        let currentBounds = collectionView.bounds
        collectionView.bounds = bounds
        let layoutAttributes = collectionView.collectionViewLayout.layoutAttributesForElements(in: bounds)
        collectionView.bounds = currentBounds
        return layoutAttributes
    }
    
    /// Same as `layoutAttributesForItem` method in `UICollectionViewLayout`
    /// But modifying the collection view bounds to match the required size to get correct results
    public func layoutAttributesForItem(at indexPath: IndexPath, in bounds: CGRect) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            return nil
        }
        let currentBounds = collectionView.bounds
        collectionView.bounds = bounds
        let layoutAttributes = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath)
        collectionView.bounds = currentBounds
        return layoutAttributes
    }
}
