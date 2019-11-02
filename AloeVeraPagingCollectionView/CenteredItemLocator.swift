//
//  CenteredItemLocator.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 07.10.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

/// Locate the current centered item in the collectionView and scroll to it
public final class CenteredItemLocator {
    
    /// Offset to the center point of the collection view
    /// Helpful when the collection view covered by some views
    public var centerOffset: CGPoint = .zero
    
    /// Helper function to exclude some items such as header or footer items
    /// Defaults to false (all items will be taken into account)
    public var shouldExcludeItemAt: ((IndexPath) -> Bool)? = nil
    
    private let collectionView: UICollectionView
    private var lastLocatedCenteredItemIndexPath: IndexPath? = nil
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    @discardableResult
    public func locateCenteredItem(in bounds: CGRect) -> IndexPath? {
        guard let layoutAttributesArray = collectionView.collectionViewLayout.layoutAttributesForElements(in: bounds) else {
            return nil
        }
        
        let centerShift = CGPoint(x: bounds.minX + centerOffset.x, y: bounds.minY + centerOffset.y)
        let visibleCenter = collectionView.adjustedCenter(shiftedBy: centerShift)
        
        lastLocatedCenteredItemIndexPath = layoutAttributesArray.filter { layoutAttributes in
            !(shouldExcludeItemAt?(layoutAttributes.indexPath) ?? false)
        }.map { layoutAttributes in
            (indexPath: layoutAttributes.indexPath, distanceToCenter: visibleCenter.distance(to: layoutAttributes.center))
        }.min {
            $0.distanceToCenter < $1.distanceToCenter
        }?.indexPath
        
        return lastLocatedCenteredItemIndexPath
    }
    
    public func scrollToCenteredItem(at indexPath: IndexPath? = nil) {
        guard let indexPath = indexPath ?? lastLocatedCenteredItemIndexPath,
            let layoutAttributes = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) else {
                return
        }
        
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        let visibleCenter = collectionView.adjustedCenter(shiftedBy: centerOffset)
        
        let proposedXPosition = layoutAttributes.center.x - visibleCenter.x
        let proposedYPosition = layoutAttributes.center.y - visibleCenter.y
        let maximumXPosition = contentSize.width - collectionView.bounds.size.width + collectionView.adjustedContentInset.right
        let maximumYPosition = contentSize.height - collectionView.bounds.size.height + collectionView.adjustedContentInset.top
        let minimumXPosition = -collectionView.adjustedContentInset.left
        let minimumYPosition = -collectionView.adjustedContentInset.top
        let xPosition = min(max(proposedXPosition, minimumXPosition), maximumXPosition)
        let yPosition = min(max(proposedYPosition, minimumYPosition), maximumYPosition)
        let contentOffset = CGPoint(x: xPosition, y: yPosition)
        
        collectionView.contentOffset = contentOffset
    }
}

private extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let xDistance = x - point.x
        let yDistance = y - point.y
        return sqrt(xDistance * xDistance + yDistance * yDistance)
    }
}

private extension UIScrollView {
    func adjustedCenter(shiftedBy shift: CGPoint) -> CGPoint {
        CGPoint(
            x: (bounds.size.width + adjustedContentInset.right - adjustedContentInset.left) / 2 + shift.x,
            y: (bounds.size.height + adjustedContentInset.top - adjustedContentInset.bottom) / 2 + shift.y
        )
    }
}
