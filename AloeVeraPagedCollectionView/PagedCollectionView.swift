//
//  PagedCollectionView.swift
//  AloeVeraPagedCollectionView
//
//  Created by Hani on 09.11.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

public class PagedCollectionView: UIView {
    
    public lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    public var pageSpacing: CGFloat = 0 {
        didSet {
            configure()
        }
    }
    
    public let collectionViewLayout = PagedCollectionViewFlowLayout()
    
    private var rightConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public func configure() {
        if collectionViewLayout.scrollDirection == .horizontal {
            collectionView.contentInset.right = pageSpacing
            collectionView.contentInset.bottom = 0
            rightConstraint?.constant = pageSpacing
            bottomConstraint?.constant = 0
        } else {
            collectionView.contentInset.right = 0
            collectionView.contentInset.bottom = pageSpacing
            rightConstraint?.constant = 0
            bottomConstraint?.constant = pageSpacing
        }
        collectionViewLayout.pageSpacing = pageSpacing
    }
}

private extension PagedCollectionView {
    func setup() {
        addSubview(collectionView)
        translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = backgroundColor
        
        rightConstraint = collectionView.rightAnchor.constraint(equalTo: rightAnchor)
        bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        NSLayoutConstraint.activate([
            rightConstraint,
            bottomConstraint,
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor)
        ])
        
        configure()
    }
}
