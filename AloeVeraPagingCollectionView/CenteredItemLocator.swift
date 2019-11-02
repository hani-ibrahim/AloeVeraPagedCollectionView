//
//  CenteredItemLocator.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 07.10.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

public protocol CenteredItemLocating {
    @discardableResult
    func locateCenteredItem(in bounds: CGRect) -> IndexPath?
}

public protocol CenteredItemScrolling {
    func scrollToCenteredItem(at indexPath: IndexPath?)
}

extension CenteredItemScrolling {
    func scrollToCenteredItem() {
        scrollToCenteredItem(at: nil)
    }
}

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
}

extension CenteredItemLocator: CenteredItemLocating {
    @discardableResult
    public func locateCenteredItem(in bounds: CGRect) -> IndexPath? {
        guard let layoutAttributesArray = collectionView.collectionViewLayout.layoutAttributesForElements(in: bounds) else {
            return nil
        }
        
        let visibleCenter = CGPoint(
            x: (bounds.minX + bounds.maxX) / 2 + centerOffset.x,
            y: (bounds.minY + bounds.maxY) / 2 + centerOffset.y
        )
        
        lastLocatedCenteredItemIndexPath = layoutAttributesArray.filter { layoutAttributes in
            !(shouldExcludeItemAt?(layoutAttributes.indexPath) ?? false)
        }.map { layoutAttributes in
            (indexPath: layoutAttributes.indexPath, distanceToCenter: visibleCenter.distance(to: layoutAttributes.center))
        }.min {
            $0.distanceToCenter < $1.distanceToCenter
        }?.indexPath
        
        return lastLocatedCenteredItemIndexPath
    }
}

extension CenteredItemLocator: CenteredItemScrolling {
    public func scrollToCenteredItem(at indexPath: IndexPath?) {
        guard let indexPath = indexPath ?? lastLocatedCenteredItemIndexPath,
            let layoutAttributes = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) else {
                return
        }
        
        print("scrollToCenteredItem: \(indexPath.item)")
        print("center: \(layoutAttributes.center)")
        
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        print("contentSize: \(contentSize)")
        let proposedXPosition = layoutAttributes.center.x + centerOffset.x - collectionView.bounds.size.width / 2
        let proposedYPosition = layoutAttributes.center.y + centerOffset.y - collectionView.bounds.size.height / 2
        let maximumXPosition = contentSize.width - collectionView.bounds.size.width
        let maximumYPosition = contentSize.height - collectionView.bounds.size.height
        let xPosition = min(max(proposedXPosition, 0), maximumXPosition)
        let yPosition = min(max(proposedYPosition, 0), maximumYPosition)
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
