//
//  PagedCollectionView.swift
//  AloeVeraPagedCollectionView
//
//  Created by Hani on 09.11.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

open class PagedCollectionView: UIView {
    
    open var collectionView = UICollectionView() {
        didSet {
            collectionView.collectionViewLayout = collectionViewLayout
            setup()
        }
    }
    open var collectionViewLayout = PagedCollectionViewFlowLayout() {
        didSet {
            collectionView.collectionViewLayout = collectionViewLayout
            configure()
        }
    }
    
    private var rightConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    open func configure() {
        if collectionViewLayout.scrollDirection == .horizontal {
            collectionView.contentInset.right = collectionViewLayout.pageSpacing
            collectionView.contentInset.bottom = 0
            rightConstraint?.constant = collectionViewLayout.pageSpacing
            bottomConstraint?.constant = 0
        } else {
            collectionView.contentInset.right = 0
            collectionView.contentInset.bottom = collectionViewLayout.pageSpacing
            rightConstraint?.constant = 0
            bottomConstraint?.constant = collectionViewLayout.pageSpacing
        }
    }
}

private extension PagedCollectionView {
    func setup() {
        subviews.forEach { $0.removeFromSuperview() }
        addSubview(collectionView)
        
        rightConstraint = collectionView.rightAnchor.constraint(equalTo: rightAnchor)
        bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        NSLayoutConstraint.activate([
            rightConstraint!,
            bottomConstraint!,
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor)
        ])
        
        configure()
    }
}
