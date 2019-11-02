//
//  CenteredItemCollectionView.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 07.10.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

/// CollectionView that is using `CenteredItemLocator` to scroll to the centered item during rotation of the device
/// Use it along with `CenteredItemCollectionViewFlowLayout`
open class CenteredItemCollectionView: UICollectionView {
    
    public private(set) lazy var centeredItemLocator = CenteredItemLocator(collectionView: self)
    
    private var lastBounds: CGRect = .zero
    
    open override var bounds: CGRect {
        willSet {
            if bounds.size != newValue.size {
                /// Collection view set the origin of the collectionView first and then the size
                /// So to get the last real bounds we can't use the `bounds`
                print("\nboundsWillSet:")
                print("lastBounds: \(lastBounds)")
                centeredItemLocator.locateCenteredItem(in: lastBounds)
                
            }
            lastBounds = bounds
        }
    }
}

extension CenteredItemCollectionView: CenteredItemScrolling {
    public func scrollToCenteredItem(at indexPath: IndexPath?) {
        centeredItemLocator.scrollToCenteredItem(at: indexPath)
    }
}
