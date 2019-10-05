//
//  DemoViewController.swift
//  PagingCollectionViewExample
//
//  Created by Hani on 12.08.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit
//import AloeVeraPagingCollectionView

final class DemoViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!
    
    private let data = (0..<200).map { "Cell - \($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
