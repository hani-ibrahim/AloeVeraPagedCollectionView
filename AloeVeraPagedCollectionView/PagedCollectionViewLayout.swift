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
    open var pageInsets: UIEdgeInsets = .zero
    open var shouldRespectAdjustedContentInset = true
    open var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    
    private var actualItemSize: CGSize = .zero
    private var actualItemSpacing: CGFloat = 0
    private var actualInsets: UIEdgeInsets = .zero
    
    private var cachedCollectionViewSize: CGSize = .zero
    private var cachedIndexedAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var cachedFlatAttributes: [UICollectionViewLayoutAttributes] = []
    private var cachedContentSize: CGSize = .zero
    
    open override var collectionViewContentSize: CGSize {
        cachedContentSize
    }
    
    open override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        clearCachedData()
        updateActualData(in: collectionView)
        updateCachedData(in: collectionView)
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var elementsFound = false
        var foundElements: [UICollectionViewLayoutAttributes] = []
        if scrollDirection == .horizontal {
            for attributes in cachedFlatAttributes where !elementsFound {
                if attributes.frame.minX < rect.maxX && attributes.frame.maxX > rect.minX {
                    foundElements.append(attributes)
                    elementsFound = true
                } else if elementsFound {
                    break
                }
            }
        } else {
            for attributes in cachedFlatAttributes where !elementsFound {
                if attributes.frame.minY < rect.maxY && attributes.frame.maxY > rect.minY {
                    foundElements.append(attributes)
                    elementsFound = true
                } else if elementsFound {
                    break
                }
            }
        }
        return foundElements
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedIndexedAttributes[indexPath]
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        newBounds.size != cachedCollectionViewSize
    }
}

private extension PagedCollectionViewLayout {
    func clearCachedData() {
        cachedIndexedAttributes.removeAll()
        cachedFlatAttributes.removeAll()
    }
    
    func updateActualData(in collectionView: UICollectionView) {
        collectionView.contentInsetAdjustmentBehavior = .automatic
        let contentInsets = shouldRespectAdjustedContentInset ? collectionView.adjustedContentInset : collectionView.contentInset
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = .zero
        
        actualInsets = UIEdgeInsets(
            top: contentInsets.top + pageInsets.top,
            left: contentInsets.left + pageInsets.left,
            bottom: contentInsets.bottom + pageInsets.bottom,
            right: contentInsets.right + pageInsets.right
        )
        
        actualItemSize = collectionView.bounds.inset(by: actualInsets).size
        
        if scrollDirection == .horizontal {
            actualItemSpacing = collectionView.bounds.size.width - actualItemSize.width + pageSpacing
        } else {
            actualItemSpacing = collectionView.bounds.size.height - actualItemSize.height + pageSpacing
        }
    }
    
    func updateCachedData(in collectionView: UICollectionView) {
        cachedCollectionViewSize = collectionView.bounds.size
        
        if let dataSource = collectionView.dataSource {
            let numberOfSections = dataSource.numberOfSections?(in: collectionView) ?? 1
            (0 ..< numberOfSections).forEach { section in
                let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
                (0 ..< numberOfItems).forEach { item in
                    let indexPath = IndexPath(item: item, section: section)
                    let absoluteItemIndex = CGFloat(cachedFlatAttributes.count)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    if scrollDirection == .horizontal {
                        attributes.frame = CGRect(
                            origin: CGPoint(
                                x: actualInsets.left + absoluteItemIndex * (actualItemSize.width + actualItemSpacing),
                                y: actualInsets.top
                            ),
                            size: actualItemSize
                        )
                    } else {
                        attributes.frame = CGRect(
                            origin: CGPoint(
                                x: actualInsets.left,
                                y: actualInsets.top + absoluteItemIndex * (actualItemSize.height + actualItemSpacing)
                            ),
                            size: actualItemSize
                        )
                    }
                    cachedIndexedAttributes[indexPath] = attributes
                    cachedFlatAttributes.append(attributes)
                }
            }
        }
        
        let numberOfItems = CGFloat(cachedFlatAttributes.count)
        if scrollDirection == .horizontal {
            cachedContentSize = CGSize(
                width: numberOfItems * (actualItemSize.width + actualItemSpacing) - actualItemSpacing + actualInsets.right + actualInsets.left,
                height: collectionView.bounds.size.height
            )
        } else {
            cachedContentSize = CGSize(
                width: collectionView.bounds.size.width,
                height: numberOfItems * (actualItemSize.height + actualItemSpacing) - actualItemSpacing + actualInsets.top + actualInsets.bottom
            )
        }
    }
}
