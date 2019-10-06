//
//  AloeVeraCenterPagingLayout.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 05.10.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

private typealias VisibleLayoutAttributes = (layoutAttributes: UICollectionViewLayoutAttributes, distanceFromCenter: CGFloat)

/// Scroll to the visible center cell after changing the collection view bounds
public class AloeVeraCenterPagingLayout: AloeVeraPagingLayouting {
    
    public let collectionView: UICollectionView?
    
    private var inProgress = false
    
    public init(collectionView: UICollectionView?) {
        self.collectionView = collectionView
    }
    
    public func centeredVisibleItem(in bounds: CGRect) -> IndexPath? {
        guard !inProgress else {
            return nil
        }
        inProgress = true
        let visibleCenter = CGPoint(
            x: (bounds.minX + bounds.maxX) / 2,
            y: (bounds.minY + bounds.maxY) / 2
        )
        let visibleLayoutAttributes = layoutAttributesForElements(in: bounds)?.map { layoutAttributes in
            (layoutAttributes: layoutAttributes, distanceFromCenter: visibleCenter.distance(to: layoutAttributes.center))
        }
        let centeredIndexPath = visibleLayoutAttributes?.min { $0.distanceFromCenter < $1.distanceFromCenter }?.layoutAttributes.indexPath
        inProgress = false
        return centeredIndexPath
    }
    
    public func scrollToItem(at indexPath: IndexPath, in bounds: CGRect) {
        print("indexPath: \(indexPath.item)")
//        collectionView?.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard !self.inProgress,
                let collectionView = self.collectionView,
                let layoutAttributes = self.layoutAttributesForItem(at: indexPath, in: bounds) else {
                    return
            }
            self.inProgress = true
            let proposedXPosition = layoutAttributes.center.x - bounds.size.width / 2
            let proposedYPosition = layoutAttributes.center.y - bounds.size.height / 2
            let maximumXPosition = collectionView.contentSize.width - bounds.size.width / 2
            let maximumYPosition = collectionView.contentSize.height - bounds.size.height / 2
            let xPosition = min(max(proposedXPosition, 0), maximumXPosition)
            let yPosition = min(max(proposedYPosition, 0), maximumYPosition)
            collectionView.contentOffset = CGPoint(x: xPosition, y: yPosition)
            self.inProgress = false
        }
        
        
        
    }
//
//        let tag = 100
//        superview.viewWithTag(tag)?.removeFromSuperview()
//
//        let debugView = DebugView(frame: superview.bounds)
//        debugView.tag = tag
//        debugView.backgroundColor = .clear
//        debugView.isUserInteractionEnabled = false
//        debugView.drawCenter = collectionViewContentCenter
//        debugView.points = visibleCells.map { $0.center }
//        superview.addSubview(debugView)
//
//        print("\n\nvisibleCells:")
//        visibleCells.sorted { $0.indexPath.row < $1.indexPath.row }.forEach {
//            print("visibleCell: \($0.indexPath.item), distance: \($0.distanceFromCollectionViewCenter)")
//        }
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
