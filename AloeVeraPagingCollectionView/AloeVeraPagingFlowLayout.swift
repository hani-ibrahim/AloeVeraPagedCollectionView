//
//  AloeVeraPagingFlowLayout.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 12.08.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

open class AloeVeraPagingFlowLayout: UICollectionViewFlowLayout {
    
    public var pagingLayoutStyle: AloeVeraPagingLayouting?
    
    open override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        pagingLayoutStyle?.collectionView(collectionView, willChangeSizeTo: collectionView.bounds.size)
    }
}
