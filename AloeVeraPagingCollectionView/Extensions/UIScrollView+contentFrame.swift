//
//  UIScrollView+contentFrame.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 05.10.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

extension UIScrollView {
    /// Same as `center` but taking into considiration the `contentInset` of the `scrollView`
    var contentCenter: CGPoint {
        let totalContentInset = UIEdgeInsets(
            top: contentInset.top + adjustedContentInset.top,
            left: contentInset.left + adjustedContentInset.left,
            bottom: contentInset.bottom + adjustedContentInset.bottom,
            right: contentInset.right + adjustedContentInset.right
        )
        
        let contentFrame = CGRect(
            x: frame.origin.x + totalContentInset.left,
            y: frame.origin.y + totalContentInset.top,
            width: frame.width - totalContentInset.left - totalContentInset.right,
            height: frame.height - totalContentInset.top - totalContentInset.bottom
        )
        
        return CGPoint(
            x: (contentFrame.minX + contentFrame.maxX) / 2,
            y: (contentFrame.minY + contentFrame.maxY) / 2
        )
    }
}
