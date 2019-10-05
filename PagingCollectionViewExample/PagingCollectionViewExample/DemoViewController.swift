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

    @IBOutlet private var collectionView: AloeVeraPagingCollectionView!
    
    private let data = (0..<200).map { "Cell - \($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        (collectionView.collectionViewLayout as? AloeVeraPagingFlowLayout)?.pagingLayoutStyle = AloeVeraCenterPagingLayout()
        collectionView.pagingLayoutStyle = AloeVeraCenterPagingLayout()
    }
    
    @IBAction private func buttonTapped() {
        (collectionView.collectionViewLayout as? AloeVeraPagingFlowLayout)?.pagingLayoutStyle?.collectionView(collectionView, willChangeSizeTo: .zero)
        collectionView.pagingLayoutStyle?.collectionView(collectionView, willChangeSizeTo: .zero)
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

extension DemoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: Bool.random() ? 100 : 200, height: Bool.random() ? 100 : 200)
    }
}
