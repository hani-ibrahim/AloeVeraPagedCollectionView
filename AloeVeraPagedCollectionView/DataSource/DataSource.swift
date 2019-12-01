//
//  DataSource.swift
//  AloeVeraPagedCollectionView
//
//  Created by Hani on 01.12.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

public final class DataSource: NSObject {
    
    private let sections: [SectionConfiguring]
    
    public init(sections: [SectionConfiguring]) {
        self.sections = sections
    }
    
    public func registerCells(in collectionView: UICollectionView) {
        sections.forEach { $0.registerCell(in: collectionView) }
    }
}

extension DataSource: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].numberOfCells
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        sections[indexPath.section].dequeueCell(for: collectionView, at: indexPath)
    }
}

extension DataSource {
    public var totalNumberOfItems: Int {
        sections.reduce(into: 0) { result, section in
            result += section.numberOfCells
        }
    }
    
    public func absoluteIndex(forItemAt indexPath: IndexPath) -> Int {
        (0..<sections.count).reduce(into: 0) { result, sectionIndex in
            if sectionIndex < indexPath.section {
                result += sections[sectionIndex].numberOfCells
            } else if sectionIndex == indexPath.section {
                result += indexPath.item
            }
        }
    }
}
