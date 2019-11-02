//
//  CenteredItemCollectionViewFlowLayout.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 02.11.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

open class CenterItemCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    open override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        super.prepare(forAnimatedBoundsChange: oldBounds)
        (collectionView as? CenteredItemScrolling)?.scrollToCenteredItem()
    }
    
}
