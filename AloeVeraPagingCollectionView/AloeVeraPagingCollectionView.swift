//
//  AloeVeraPagingCollectionView.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 12.08.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

open class AloeVeraPagingCollectionView: UICollectionView {
    
    public var pagingLayout: AloeVeraPagingLayouting?
    
    open override var bounds: CGRect {
        didSet {
            guard bounds.size != oldValue.size else {
                return
            }
            if let indexPath = pagingLayout?.centeredVisibleItem(in: oldValue) {
                pagingLayout?.scrollToItem(at: indexPath, in: bounds)
            }
        }
    }
}
