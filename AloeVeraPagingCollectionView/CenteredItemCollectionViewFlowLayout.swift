//
//  CenteredItemCollectionViewFlowLayout.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 02.11.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

open class CenteredItemCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    public private(set) var centeredItemLocator: CenteredItemLocator?
    
    open override func prepare() {
        super.prepare()
        
        if centeredItemLocator == nil, let collectionView = collectionView {
            centeredItemLocator = CenteredItemLocator(collectionView: collectionView)
        }
    }
    
    open override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        super.prepare(forAnimatedBoundsChange: oldBounds)
        centeredItemLocator?.scrollToCenteredItem()
    }
    
    public func willRotate() {
        centeredItemLocator?.locateCenteredItem()
    }
}
