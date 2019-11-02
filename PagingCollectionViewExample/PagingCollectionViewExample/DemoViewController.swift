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

    @IBOutlet private var collectionView: CenteredItemCollectionView!
    
    private let screenCenterView = UIView()
    private let visibleCenterView = UIView()
    private let data = (0..<1000).map { String($0) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCenterViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.centeredItemLocator.centerOffset = CGPoint(x: 0, y: view.safeAreaInsets.top / 2)
        screenCenterView.center = view.center
        visibleCenterView.center = CGPoint(x: view.center.x, y: view.center.y + view.safeAreaInsets.top / 2)
    }
}

extension DemoViewController {
    func setupCenterViews() {
        screenCenterView.frame.size = CGSize(width: 10, height: 10)
        screenCenterView.backgroundColor = .blue
        screenCenterView.layer.cornerRadius = 5
        view.addSubview(screenCenterView)
        
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

extension DemoViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("bounds: \(scrollView.bounds)")
    }
}
