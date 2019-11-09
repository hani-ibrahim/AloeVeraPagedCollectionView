//
//  PagedCollectionViewFlowLayout.swift
//  AloeVeraPagedCollectionView
//
//  Created by Hani on 02.11.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

/// Changes the cells sizes during rotation to fill the whole collection view
/// ⚠️ You must call `collectionViewSizeWillChange()` before the rotation start ... call it from `UIViewController.viewWillTransition` function
open class PagedCollectionViewFlowLayout: CenteredItemCollectionViewFlowLayout {
    
    /// The insets for each page individual
    public var pageInsets: UIEdgeInsets = .zero
    
    /// The spacing between each page that is only visible during scrolling
    public var pageSpacing: CGFloat = .zero
    
    open override func collectionViewSizeWillChange() {
        super.collectionViewSizeWillChange()
        invalidateLayout()
    }
    
    open override func prepare() {
        defer {
            super.prepare()
        }
        
        guard let collectionView = collectionView else {
            return
        }
        
        minimumInteritemSpacing = 0
        sectionInset = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.decelerationRate = .fast
        collectionView.contentInset = pageInsets
        
        if scrollDirection == .horizontal {
            minimumLineSpacing = pageInsets.right + pageInsets.left + pageSpacing
        } else {
            minimumLineSpacing = pageInsets.top + pageInsets.bottom + pageSpacing
        }
        
        itemSize = collectionView.bounds.inset(by: collectionView.contentInset).size
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }
        
        var origin = collectionView.bounds.origin
        let speedThreshold: CGFloat = 0.5
        if scrollDirection == .horizontal {
            if velocity.x > speedThreshold {
                origin.x += collectionView.bounds.width
            } else if velocity.x < -speedThreshold {
                origin.x -= collectionView.bounds.width
            }
        } else {
            if velocity.y > speedThreshold {
                origin.y += collectionView.bounds.height
            } else if velocity.y < -speedThreshold {
                origin.y -= collectionView.bounds.height
            }
        }
        
        let bounds = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)
        guard let indexPath = centeredItemLocator.locateCenteredItem(in: collectionView, bounds: bounds),
            let contectOffset = centeredItemLocator.contentOffset(for: indexPath, toBeCenteredIn: collectionView) else {
                return proposedContentOffset
        }
        return contectOffset
    }
    
    override open func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView, let rotatingIndexPath = lastLocatedCenteredItemIndexPath, itemIndexPath != rotatingIndexPath else {
            return nil
        }
        
        // Sometimes there are overlapping cells appears during rotation
        // So hiding the unneeded cells by moving them far away
        let attributes = layoutAttributesForItem(at: itemIndexPath)
        if itemIndexPath < rotatingIndexPath {
            attributes?.frame.origin.x -= collectionView.bounds.width
            attributes?.frame.origin.y -= collectionView.bounds.height
        } else {
            attributes?.frame.origin.x += collectionView.bounds.width
            attributes?.frame.origin.y += collectionView.bounds.height
        }
        return attributes
    }
    
    override open func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        layoutAttributesForItem(at: itemIndexPath)
    }
}
