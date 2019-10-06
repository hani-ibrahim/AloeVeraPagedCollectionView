//
//  AloeVeraCenterItemScroller.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 06.10.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

public class AloeVeraCenterItemScroller {
    
    /// Offset to the center point of the collection view
    public var centerOffset: CGPoint = .zero
    
    private let collectionView: UICollectionView
    
    private var observation: NSKeyValueObservation?
    private var inProgress = false
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        addObserver()
    }
}

private extension AloeVeraCenterItemScroller {
    func addObserver() {
        observation = collectionView.observe(\.bounds, options: [.new, .old]) { [weak self] _, change in
            guard let oldBounds = change.oldValue, let newBounds = change.newValue, oldBounds.size != newBounds.size else {
                return
            }
            self?.scrollToCenteredVisibleItem(atOldBounds: oldBounds, toNewBounds: newBounds)
        }
    }
    
    func scrollToCenteredVisibleItem(atOldBounds oldBounds: CGRect, toNewBounds newBounds: CGRect) {
        /// We need the `inProgress` flag as we are modifying the bounds in this function
        /// Without `inProgress` we will enter an infinite loop
        guard !inProgress else {
            return
        }
        inProgress = true
        defer {
            inProgress = false
        }
        
        /// Getting the `[UICollectionViewLayoutAttributes]` for the `newBounds` for the items that was visible in the `oldBounds`
        /// The `indexPathsForVisibleItems` are the items that was visible in `oldBounds`
        /// However `layoutAttributesForItem` gives `UICollectionViewLayoutAttributes` for the `newBounds`
        /// As the `UICollectionView` already has the `newBounds`, but it didn't update its cells yet
        let oldBoundsVisibleItems = collectionView.indexPathsForVisibleItems
        let newBoundsLayoutAttributes = oldBoundsVisibleItems.compactMap { collectionView.layoutAttributesForItem(at: $0) }
        let newContentSize = collectionView.collectionViewLayout.collectionViewContentSize // we need to get it now before changing the bounds later
        
        /// Getting the `[UICollectionViewLayoutAttributes]` for the `oldBounds`
        /// By setting the `UICollectionView` bounds to the `oldBounds` to get correct result
        /// As we want the calculations to be done on the size of the `oldBounds`
        let currentBounds = collectionView.bounds
        collectionView.bounds = oldBounds
        let layoutAttributes = collectionView.collectionViewLayout.layoutAttributesForElements(in: oldBounds)
        collectionView.bounds = currentBounds
        guard let oldBoundsLayoutAttributes = layoutAttributes else {
            return
        }
        
        /// Getting the closest item to the center of the `oldBounds`
        let visibleOldCenter = CGPoint(
            x: (oldBounds.minX + oldBounds.maxX) / 2,
            y: (oldBounds.minY + oldBounds.maxY) / 2
        )
        typealias IndexPathDistanceToCenterPair = (indexPath: IndexPath, distanceToCenter: CGFloat)
        let indexPathDistanceToCenterPair = oldBoundsLayoutAttributes.map { layoutAttributes in
            IndexPathDistanceToCenterPair(
                indexPath: layoutAttributes.indexPath,
                distanceToCenter: visibleOldCenter.distance(to: layoutAttributes.center)
            )
        }
        guard let oldCenteredIndexPath = indexPathDistanceToCenterPair.min(by: { $0.distanceToCenter < $1.distanceToCenter })?.indexPath,
            let newCenteredLayoutAttributes = newBoundsLayoutAttributes.first(where: { $0.indexPath == oldCenteredIndexPath}) else {
                return
        }
        print("indexPath: \(newCenteredLayoutAttributes.indexPath), center: \(newCenteredLayoutAttributes.center), contentSize: \(newContentSize)")
        /// Scroll the centered indexPath in the `newBounds`
        let proposedXPosition = newCenteredLayoutAttributes.center.x - newBounds.size.width / 2
        let proposedYPosition = newCenteredLayoutAttributes.center.y - newBounds.size.height / 2
        let maximumXPosition = newContentSize.width - newBounds.size.width / 2
        let maximumYPosition = newContentSize.height - newBounds.size.height / 2
        let xPosition = min(max(proposedXPosition, 0), maximumXPosition)
        let yPosition = min(max(proposedYPosition, 0), maximumYPosition)
        collectionView.contentOffset = CGPoint(x: xPosition, y: yPosition)
    }
}

private extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let xDistance = x - point.x
        let yDistance = y - point.y
        return sqrt(xDistance * xDistance + yDistance * yDistance)
    }
}

