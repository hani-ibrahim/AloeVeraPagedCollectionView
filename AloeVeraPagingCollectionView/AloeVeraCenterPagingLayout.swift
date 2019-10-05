//
//  AloeVeraCenterPagingLayout.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 05.10.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

/// Scroll to the visible center cell after changing the collection view bounds
public struct AloeVeraCenterPagingLayout: AloeVeraPagingLayouting {
    public init() {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, willChangeSizeTo newSize: CGSize) {
        guard let superview = collectionView.superview else {
            assertionFailure("CollectionView not in a view hierarchy")
            return
        }
        
        let collectionViewContentCenter = collectionView.contentCenter
        
        let visibleCells: [VisibleCell] = collectionView.visibleCells.compactMap { cell in
            guard let indexPath = collectionView.indexPath(for: cell) else {
                return nil
            }
            let centerInSuperview = collectionView.convert(cell.center, to: superview)
            let distance = collectionViewContentCenter.distance(to: centerInSuperview)
            return VisibleCell(indexPath: indexPath, center: centerInSuperview, distanceFromCollectionViewCenter: distance)
        }
        
        let tag = 100
        superview.viewWithTag(tag)?.removeFromSuperview()

        let debugView = DebugView(frame: superview.bounds)
        debugView.tag = tag
        debugView.backgroundColor = .clear
        debugView.isUserInteractionEnabled = false
        debugView.drawCenter = collectionViewContentCenter
        debugView.points = visibleCells.map { $0.center }
        superview.addSubview(debugView)
        
        print("\n\nvisibleCells:")
        visibleCells.sorted { $0.indexPath.row < $1.indexPath.row }.forEach {
            print("visibleCell: \($0.indexPath.item), distance: \($0.distanceFromCollectionViewCenter)")
        }
    }
}

private struct VisibleCell {
    let indexPath: IndexPath
    let center: CGPoint
    let distanceFromCollectionViewCenter: CGFloat
}

private final class DebugView: UIView {
    
    var drawCenter: CGPoint = .zero
    var points: [CGPoint] = []
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath()
        points.forEach { point in
            path.move(to: drawCenter)
            path.addLine(to: point)
        }
        
        UIColor.blue.set()
        path.lineWidth = 2
        path.stroke()
    }
}
