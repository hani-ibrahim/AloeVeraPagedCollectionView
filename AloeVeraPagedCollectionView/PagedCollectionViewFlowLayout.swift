//
//  PagedCollectionViewFlowLayout.swift
//  AloeVeraPagedCollectionView
//
//  Created by Hani on 02.11.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

/// Changes the cells sizes during rotation to fill the whole collection view
/// ⚠️ You must call `collectionViewSizeWillChange()` before the rotation start ... call it from `UIViewController.viewWillTransition` function
open class PagedCollectionViewFlowLayout: CenteredItemCollectionViewFlowLayout {
    
    public struct PageProperties {
        /// The insets for each individual page
        public let insets: UIEdgeInsets
        
        /// The spacing between each page that is only visible during scrolling
        public let spacing: CGFloat
        
        public init(insets: UIEdgeInsets, spacing: CGFloat) {
            self.insets = insets
            self.spacing = spacing
        }
    }
    
    /// Properties for the page, will trigger `invalidateLayout` when set
    public var pageProperties = PageProperties(insets: .zero, spacing: .zero) {
        didSet {
            shouldConfigurePage = true
            invalidateLayout()
        }
    }
    open override var scrollDirection: UICollectionView.ScrollDirection {
        didSet {
            shouldConfigurePage = true
        }
    }
    
    private var shouldConfigurePage = true
    
    open override func collectionViewSizeWillChange() {
        super.collectionViewSizeWillChange()
        invalidateLayout()
    }
    
    open override func prepare() {
        defer {
            super.prepare()
        }
        
        guard let collectionView = collectionView else {
            return
        }
        
        if shouldConfigurePage {
            minimumInteritemSpacing = 0
            sectionInset = .zero
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.contentInset = pageProperties.insets
            
            if scrollDirection == .horizontal {
                minimumLineSpacing = pageProperties.insets.right + pageProperties.insets.left + pageProperties.spacing
            } else {
                minimumLineSpacing = pageProperties.insets.top + pageProperties.insets.bottom + pageProperties.spacing
            }
            shouldConfigurePage = false
        }
        
        itemSize = collectionView.bounds.inset(by: collectionView.contentInset).size
    }
    
    open override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView, let rotatingIndexPath = lastLocatedCenteredItemIndexPath, itemIndexPath != rotatingIndexPath else {
            return nil
        }
        
        // Sometimes there are overlapping cells appears during rotation
        // So hiding the unneeded cells by moving them far away
        let attributes = layoutAttributesForItem(at: itemIndexPath)
        if itemIndexPath < rotatingIndexPath {
            attributes?.frame.origin.x -= collectionView.bounds.width
            attributes?.frame.origin.y -= collectionView.bounds.height
        } else {
            attributes?.frame.origin.x += collectionView.bounds.width
            attributes?.frame.origin.y += collectionView.bounds.height
        }
        return attributes
    }
    
    open override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        layoutAttributesForItem(at: itemIndexPath)
    }
}
