//
//  AloeVeraPagingCollectionView.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 12.08.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

open class AloeVeraPagingCollectionView: UICollectionView {
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: AloeVeraPagingFlowLayout())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        flow
    }
}
