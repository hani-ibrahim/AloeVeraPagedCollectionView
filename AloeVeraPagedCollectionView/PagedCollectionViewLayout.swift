//
//  PagedCollectionViewLayout.swift
//  AloeVeraPagedCollectionView
//
//  Created by Hani on 10.11.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

open class PagedCollectionViewLayout: UICollectionViewLayout {
    
    open var pageSpacing: CGFloat = 0
    open var pageInset: UIEdgeInsets = .zero
    open var contentInset: UIEdgeInsets = .zero
    open var shouldRespectAdjustedContentInset = true
    open var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    
    private var properties: Properties = .empty
    private var cache: Cache = .empty
    
    open override func prepare() {
        if let collectionView = collectionView {
            properties = properties(for: collectionView, bounds: collectionView.bounds)
            cache = cache(for: collectionView)
        }
        super.prepare()
    }
    
    open override var collectionViewContentSize: CGSize {
        cache.contentSize
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cache.attributes.values.filter { $0.frame.intersects(rect) }
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache.attributes[indexPath]
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        newBounds.size != cache.collectionViewSize
    }
}

private extension PagedCollectionViewLayout {
    struct Properties {
        static let empty = Properties(itemSize: .zero, itemSpacing: 0, contentInset: .zero)
        
        let itemSize: CGSize
        let itemSpacing: CGFloat
        let contentInset: UIEdgeInsets
    }
    
    struct Cache {
        static let empty = Cache(collectionViewSize: .zero, attributes: [:], contentSize: .zero)
        
        let collectionViewSize: CGSize
        let attributes: [IndexPath: UICollectionViewLayoutAttributes]
        let contentSize: CGSize
    }
}

private extension PagedCollectionViewLayout {
    func properties(for collectionView: UICollectionView, bounds: CGRect) -> Properties {
        let adjustedContentInset = collectionView.adjustedContentInset(shouldRespect: shouldRespectAdjustedContentInset)
        let finalContentInset = UIEdgeInsets(
            top: adjustedContentInset.top + pageInset.top + contentInset.top,
            left: adjustedContentInset.left + pageInset.left + contentInset.left,
            bottom: adjustedContentInset.bottom + pageInset.bottom + contentInset.bottom,
            right: adjustedContentInset.right + pageInset.right + contentInset.right
        )
        
        let itemSize = bounds.inset(by: finalContentInset).size
        let itemSpacingInPage = scrollDirection == .horizontal ? bounds.size.width - itemSize.width : bounds.size.height - itemSize.height
        let itemSpacing = itemSpacingInPage + pageSpacing
        
        return Properties(itemSize: itemSize, itemSpacing: itemSpacing, contentInset: finalContentInset)
    }
    
    func cache(for collectionView: UICollectionView) -> Cache {
        guard let dataSource = collectionView.dataSource else {
            return .empty
        }
        
        let numberOfSections = dataSource.numberOfSections?(in: collectionView) ?? 1
        var attributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
        (0 ..< numberOfSections).forEach { section in
            let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
            (0 ..< numberOfItems).forEach { item in
                let indexPath = IndexPath(item: item, section: section)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                itemAttributes.frame = properties.frame(forItemAtAbsoluteIndex: attributes.count, scrollDirection: scrollDirection)
                attributes[indexPath] = itemAttributes
            }
        }
        
        let collectionViewSize = collectionView.bounds.size
        let contentSize = properties.contentSize(forCollectionViewSize: collectionViewSize, numberOfItems: attributes.count, scrollDirection: scrollDirection)
        return Cache(collectionViewSize: collectionViewSize, attributes: attributes, contentSize: contentSize)
    }
}

private extension UICollectionView {
    func adjustedContentInset(shouldRespect: Bool) -> UIEdgeInsets {
        if contentInset != .zero {
            print("PagedCollectionViewLayout: Neglecting (UICollectionView.contentInset) value of (\(contentInset)), please use (PagedCollectionViewLayout.contentInset) instead.")
            contentInset = .zero
        }
        
        contentInsetAdjustmentBehavior = .automatic
        let finalAdjustedContentInset = shouldRespect ? adjustedContentInset : .zero
        contentInsetAdjustmentBehavior = .never
        return finalAdjustedContentInset
    }
}

private extension PagedCollectionViewLayout.Properties {
    func frame(forItemAtAbsoluteIndex index: Int, scrollDirection: UICollectionView.ScrollDirection) -> CGRect {
        let origin: CGPoint
        if scrollDirection == .horizontal {
            origin = CGPoint(
                x: contentInset.left + CGFloat(index) * (itemSize.width + itemSpacing),
                y: contentInset.top
            )
        } else {
            origin = CGPoint(
                x: contentInset.left,
                y: contentInset.top + CGFloat(index) * (itemSize.height + itemSpacing)
            )
        }
        return CGRect(origin: origin, size: itemSize)
    }
    
    func contentSize(forCollectionViewSize collectionViewSize: CGSize, numberOfItems: Int, scrollDirection: UICollectionView.ScrollDirection) -> CGSize {
        if scrollDirection == .horizontal {
            return CGSize(
                width: CGFloat(numberOfItems) * (itemSize.width + itemSpacing) - itemSpacing + contentInset.right + contentInset.left,
                height: collectionViewSize.height
            )
        } else {
            return CGSize(
                width: collectionViewSize.width,
                height: CGFloat(numberOfItems) * (itemSize.height + itemSpacing) - itemSpacing + contentInset.top + contentInset.bottom
            )
        }
    }
}
