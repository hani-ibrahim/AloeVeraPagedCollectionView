//
//  SectionConfigurator.swift
//  AloeVeraPagedCollectionView
//
//  Created by Hani on 01.12.19.
//  Copyright © 2019 Hani. All rights reserved.
//

import UIKit

public protocol CellConfigurable {
    associatedtype ViewModel
    func configure(with viewModel: ViewModel)
}

public protocol SectionConfiguring {
    var numberOfCells: Int { get }
    func registerCell(in collectionView: UICollectionView)
    func dequeueCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
}

public struct SectionConfigurator<Cell: UICollectionViewCell & CellConfigurable, ViewModel> where Cell.ViewModel == ViewModel {
    private let cellSource: CellSource
    private var viewModels: [ViewModel]
    
    public init(cellSource: CellSource, viewModels: [ViewModel] = []) {
        self.cellSource = cellSource
        self.viewModels = viewModels
    }
    
    public mutating func update(cellAt index: Int, with viewModel: ViewModel) {
        guard viewModels.count > index else {
            assertionFailure("SectionConfigurator: updating cell at index: \(index) that doesn't exists")
            return
        }
        viewModels[index] = viewModel
    }
    
    public mutating func update(with viewModels: [ViewModel]) {
        self.viewModels = viewModels
    }
}

extension SectionConfigurator {
    public enum CellSource {
        case storyboard
        case xib
        case code
    }
}

extension SectionConfigurator: SectionConfiguring {
    public var numberOfCells: Int {
        viewModels.count
    }
    
    public func registerCell(in collectionView: UICollectionView) {
        switch cellSource {
        case .storyboard:
            print("SectionConfigurator: skipping registering cell from storyboard as it is already registered")
        case .xib:
            collectionView.register(UINib(nibName: Cell.cellIdentifier, bundle: Bundle(for: Cell.self)), forCellWithReuseIdentifier: Cell.cellIdentifier)
        case .code:
            collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.cellIdentifier)
        }
    }
    
    public func dequeueCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.cellIdentifier, for: indexPath) as! Cell
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}

extension CellConfigurable where Self: UICollectionViewCell {
    public typealias Section = SectionConfigurator<Self, ViewModel>
}
