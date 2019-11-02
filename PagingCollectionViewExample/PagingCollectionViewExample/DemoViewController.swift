//
//  DemoViewController.swift
//  PagingCollectionViewExample
//
//  Created by Hani on 12.08.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit
import AloeVeraPagingCollectionView

final class DemoViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var collectionViewLayout: CenteredItemCollectionViewFlowLayout!
    
    private let visibleCenterView = UIView()
    private let data = (0..<1000).map { String($0) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCenterView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let offset = collectionView.adjustedContentInset.top / 2 - collectionView.adjustedContentInset.bottom / 2
        visibleCenterView.center = CGPoint(x: collectionView.center.x, y: collectionView.center.y + offset)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionViewLayout.willRotate()
    }
}

extension DemoViewController {
    func setupCenterView() {
        visibleCenterView.frame.size = CGSize(width: 10, height: 10)
        visibleCenterView.backgroundColor = .green
        visibleCenterView.layer.cornerRadius = 5
        view.addSubview(visibleCenterView)
    }
}

extension DemoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: DemoCollectionViewCell.self, at: indexPath)
        cell.titleLabel.text = data[indexPath.row]
        return cell
    }
}
