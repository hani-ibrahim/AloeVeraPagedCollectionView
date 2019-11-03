//
//  CenteredItemCollectionViewFlowLayout.swift
//  AloeVeraPagedCollectionView
//
//  Created by Hani on 02.11.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

/// FlowLayout that uses `CenteredItemLocator` to scroll to the centered item after device rotation
/// You must call `willRotate()` before the rotation start ... call it from `UIViewController.viewWillTransition` function
open class CenteredItemCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    public let centeredItemLocator = CenteredItemLocator()
    
    private var lastLocatedCenteredItemIndexPath: IndexPath? = nil
    
    open override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        super.prepare(forAnimatedBoundsChange: oldBounds)
        if let collectionView = collectionView, let indexPath = lastLocatedCenteredItemIndexPath {
            centeredItemLocator.scrollToItem(at: indexPath, toBeCenteredIn: collectionView)
        }
    }
    
    public func willRotate() {
        if let collectionView = collectionView {
            lastLocatedCenteredItemIndexPath = centeredItemLocator.locateCenteredItem(in: collectionView, bounds: collectionView.bounds)
        }
    }
}
