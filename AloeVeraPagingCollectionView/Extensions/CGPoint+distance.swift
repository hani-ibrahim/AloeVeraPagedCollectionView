//
//  CGPoint+distance.swift
//  AloeVeraPagingCollectionView
//
//  Created by Hani on 05.10.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let xDistance = x - point.x
        let yDistance = y - point.y
        return sqrt(xDistance * xDistance + yDistance * yDistance)
    }
}
