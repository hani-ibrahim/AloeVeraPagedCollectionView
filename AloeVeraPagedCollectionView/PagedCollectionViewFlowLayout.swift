//
//  PagedCollectionViewFlowLayout.swift
//  AloeVeraPagedCollectionView
//
//  Created by Hani on 02.11.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

/// Changes the cells sizes during rotation to fill the whole collection view
/// You must call `willRotate()` before the rotation start ... call it from `UIViewController.viewWillTransition` function
open class PagedCollectionViewFlowLayout: CenteredItemCollectionViewFlowLayout {
    
    public var pageInsets: UIEdgeInsets = .zero
    public var pageSpacing: CGFloat = .zero
    public var shouldRespectAdjustedContentInset = true
    
    public override init() {
        super.init()
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    open override func prepare() {
        if let collectionView = collectionView {
            collectionView.contentInset = pageInsets
            if scrollDirection == .horizontal {
                minimumLineSpacing = pageInsets.horizontalEdges + pageSpacing
            } else {
                minimumLineSpacing = pageInsets.verticalEdges + pageSpacing
            }
            
            let contentInsets: UIEdgeInsets
            if shouldRespectAdjustedContentInset {
                contentInsets = collectionView.adjustedContentInset
                collectionView.contentInsetAdjustmentBehavior = .automatic
            } else {
                contentInsets = collectionView.contentInset
                collectionView.contentInsetAdjustmentBehavior = .never
            }
            
            itemSize = CGSize(
                width: collectionView.bounds.size.width - contentInsets.horizontalEdges,
                height: collectionView.bounds.size.height - contentInsets.verticalEdges
            )
        }
        super.prepare()
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView,
            let indexPath = centeredItemLocator.locateCenteredItem(in: collectionView),
            let contectOffset = centeredItemLocator.contentOffset(for: indexPath, toBeCenteredIn: collectionView) else {
                return proposedContentOffset
        }
        return contectOffset
    }
}

private extension PagedCollectionViewFlowLayout {
    func setup() {
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        sectionInset = .zero
    }
}

private extension UIEdgeInsets {
    var horizontalEdges: CGFloat {
        left + right
    }
    
    var verticalEdges: CGFloat {
        top + bottom
    }
}
