//
//  ImageListViewController.swift
//  Astronomy
//
//  Created by xander on 2021/4/11.
//

import UIKit
import CoreData

private let kNumberOfItemsInARow: CGFloat = 4
private let kItemHorizontalOffset: CGFloat = 0
private let kItemHeightByWidthRatio: CGFloat = 1.0/1
private let kMinimumLineSpacing: CGFloat = 2
private let kMinimumInteritemSpacing: CGFloat = 2

class ImageListViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Astronomy> = {
        let fetchRequest: NSFetchRequest<Astronomy> = Astronomy.fetchRequest()
        let indexSort = NSSortDescriptor(key: #keyPath(Astronomy.index), ascending: true)
        fetchRequest.fetchBatchSize = 60
        fetchRequest.sortDescriptors = [indexSort]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataStack.apod.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    fileprivate let networkImageOperations = NetworkImageOperations()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    // MARK: - Private Implementation
    
    private func initUI() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = kMinimumLineSpacing
            layout.minimumInteritemSpacing = kMinimumInteritemSpacing
            layout.sectionInset = .init()
        }
        collectionView.delaysContentTouches = false
        collectionView.register(AstronomyViewCell.self, forCellWithReuseIdentifier: AstronomyViewCell.reuseId)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let err as NSError {
            print("Fetching error: \(err), \(err.userInfo)")
        }
    }
}

// MARK: - Navigation

extension ImageListViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case detail
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? ImageDetailViewController,
              let idx = sender as? IndexPath else { return }
        
        let astronomy = fetchedResultsController.object(at: idx)
        dest.astronomy = astronomy
    }
}

// MARK: - UIScrollViewDelegate

extension ImageListViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        networkImageOperations.suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            startDownloadForVisibleCells()
            networkImageOperations.resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        networkImageOperations.resumeAllOperations()
    }
    
    private func startDownloadForVisibleCells() {
        let visibles = collectionView.indexPathsForVisibleItems
        let toBeStarted = networkImageOperations.indexpathsForLatestOperations(visibles)
        for idx in toBeStarted { startDownloadIfNeeded(at: idx) }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpace = 2 * kItemHorizontalOffset + kNumberOfItemsInARow * kMinimumInteritemSpacing
        let refWidth = (collectionView.bounds.width - totalSpace) / kNumberOfItemsInARow
        let refHeight = refWidth * kItemHeightByWidthRatio
        return .init(width: refWidth, height: refHeight)
    }
}

// MARK: - UICollectionViewDataSource

extension ImageListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: AstronomyViewCell.reuseId, for: indexPath)
    }
}

// MARK: - UICollectionViewDelegate

extension ImageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: .detail, sender: indexPath)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ImageListViewController: NSFetchedResultsControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? AstronomyViewCell else { return }
        let astronomy = fetchedResultsController.object(at: indexPath)
        cell.configure(astronomy.title, astronomy.pictureThumbnail)
        
        startDownloadIfNeeded(at: indexPath)
    }
    
    private func startDownloadIfNeeded(at indexPath: IndexPath) {
        let astronomy = fetchedResultsController.object(at: indexPath)
        guard astronomy.pictureThumbnail == nil else { return }
        
        guard let url = astronomy.url, let title = astronomy.title else { return }
        networkImageOperations.startDownload(url, at: indexPath) { [weak self] thumbnail in
            guard let cell = self?.collectionView.cellForItem(at: indexPath) as? AstronomyViewCell else { return }
            
            cell.configure(title, thumbnail)
            astronomy.updateThumbnail(thumbnail)
        }
    }
}
