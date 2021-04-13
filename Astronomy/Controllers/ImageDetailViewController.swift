//
//  ImageDetailViewController.swift
//  Astronomy
//
//  Created by xander on 2021/4/11.
//

import UIKit

private let kMinimumLineSpacing: CGFloat = 10
private let kMinimumInteritemSpacing: CGFloat = 0

class ImageDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum CellType {
        case image // IndexPath(row: 0, section: 0)
        case info  // IndexPath(row: 1, section: 0)
        
        var reuseId: String {
            switch self {
            case .image: return AstronomyImageViewCell.reuseId
            case .info : return AstronomyInfoViewCell.reuseId
            }
        }
    }
    
    var astronomy: Astronomy?
    
    fileprivate let networkImageOperations = NetworkImageOperations()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        startDownloadIfNeeded()
    }
    
    // MARK: - Private Implementation
    
    private func initUI() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = kMinimumLineSpacing
            layout.minimumInteritemSpacing = kMinimumInteritemSpacing
            layout.sectionInset = .init()
        }
        collectionView.alwaysBounceVertical = true
        collectionView.register(AstronomyImageViewCell.self,
                                forCellWithReuseIdentifier: AstronomyImageViewCell.reuseId)
        collectionView.register(AstronomyInfoViewCell.self,
                                forCellWithReuseIdentifier: AstronomyInfoViewCell.reuseId)
    }
    
    private func checkCellType(by indexpath: IndexPath) -> CellType {
        if indexpath.row == 0 {
            return .image
        } else {
            return .info
        }
    }
    
    private func startDownloadIfNeeded() {
        guard astronomy?.picture?.picture == nil else { return }
        guard let url = astronomy?.hdurl, let idx = astronomy?.index else { return }
        let indexPath = IndexPath(row: Int(idx), section: 0)
        networkImageOperations.startDownload(url, at: indexPath) { [weak self] imgData in
            self?.astronomy?.updatePicture(imgData)
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let refHeight: CGFloat = 300 // Approximate height of the cell
        let refWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
            - sectionInset.left
            - sectionInset.right
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        return .init(width: refWidth, height: refHeight)
    }
}

// MARK: - UICollectionViewDataSource

extension ImageDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = checkCellType(by: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath)
        switch cellType {
        case .image:
            if let cell = cell as? AstronomyImageViewCell {
                cell.configure(astronomy?.date, astronomy?.picture?.picture)
            }
        case .info:
            if let cell = cell as? AstronomyInfoViewCell {
                cell.configure(astronomy?.title, astronomy?.copyright, astronomy?.desc)
            }
        }
        return cell
    }
}
