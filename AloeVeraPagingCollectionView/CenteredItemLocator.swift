//
//  CenteredItemLocator.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 07.10.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

public protocol CenteredItemLocatorDelegate: AnyObject {
    func centerOffset(for locator: CenteredItemLocator) -> CGPoint
    func centeredItemLocator(_ locator: CenteredItemLocator, shouldExcludeItemAt indexPath: IndexPath) -> Bool
    func centeredItemLocator(_ locator: CenteredItemLocator, shouldScrollTo contentOffset: CGPoint) -> Bool
}

/// Locate the current centered item in the collectionView and scroll to it
public final class CenteredItemLocator {
    
    public weak var delegate: CenteredItemLocatorDelegate?
    
    public init() {
        
    }
    
    public func locateCenteredItem(in collectionView: UICollectionView) -> IndexPath? {
        guard let layoutAttributesArray = collectionView.collectionViewLayout.layoutAttributesForElements(in: collectionView.bounds) else {
            return nil
        }
        
        let adjustedCenter = collectionView.adjustedCenter
        let centerOffset = delegate?.centerOffset(for: self) ?? .zero
        let visibleCenter = CGPoint(
            x: adjustedCenter.x + centerOffset.x + collectionView.bounds.minX,
            y: adjustedCenter.y + centerOffset.y + collectionView.bounds.minY
        )

        return layoutAttributesArray.filter { layoutAttributes in
            !(delegate?.centeredItemLocator(self, shouldExcludeItemAt: layoutAttributes.indexPath) ?? false)
        }.map { layoutAttributes in
            (indexPath: layoutAttributes.indexPath, distanceToCenter: visibleCenter.distance(to: layoutAttributes.center))
        }.min {
            $0.distanceToCenter < $1.distanceToCenter
        }?.indexPath
    }
    
    public func scrollToItem(at indexPath: IndexPath, toBeCenteredIn collectionView: UICollectionView) {
        guard let layoutAttributes = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) else {
            return
        }
        
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        let adjustedCenter = collectionView.adjustedCenter
        let centerOffset = delegate?.centerOffset(for: self) ?? .zero
        let visibleCenter = CGPoint(
            x: adjustedCenter.x + centerOffset.x,
            y: adjustedCenter.y + centerOffset.y
        )
        
        let proposedXPosition = layoutAttributes.center.x - visibleCenter.x
        let proposedYPosition = layoutAttributes.center.y - visibleCenter.y
        let maximumXPosition = contentSize.width - collectionView.bounds.size.width + collectionView.adjustedContentInset.right
        let maximumYPosition = contentSize.height - collectionView.bounds.size.height + collectionView.adjustedContentInset.top
        let minimumXPosition = -collectionView.adjustedContentInset.left
        let minimumYPosition = -collectionView.adjustedContentInset.top
        let xPosition = min(max(proposedXPosition, minimumXPosition), maximumXPosition)
        let yPosition = min(max(proposedYPosition, minimumYPosition), maximumYPosition)
        let contentOffset = CGPoint(x: xPosition, y: yPosition)
        
        if delegate?.centeredItemLocator(self, shouldScrollTo: contentOffset) != false {
            collectionView.contentOffset = contentOffset
        }
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
    var adjustedCenter: CGPoint {
        CGPoint(
            x: (bounds.size.width + adjustedContentInset.right - adjustedContentInset.left) / 2,
            y: (bounds.size.height + adjustedContentInset.top - adjustedContentInset.bottom) / 2
        )
    }
}
