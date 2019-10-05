//
//  AloeVeraPagingCollectionView.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 12.08.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

open class AloeVeraPagingCollectionView: UICollectionView {
    
    public var pagingLayoutStyle: AloeVeraPagingLayouting?
    
    open override var bounds: CGRect {
        willSet {
            guard bounds.size != newValue.size else {
                return
            }
            pagingLayoutStyle?.collectionView(self, willChangeSizeTo: newValue.size)
        }
    }
}
