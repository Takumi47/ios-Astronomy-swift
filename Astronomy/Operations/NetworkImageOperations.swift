//
//  NetworkImageOperations.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//

import UIKit

class NetworkImageOperations {
    
    // MARK: - Properties
    
    private lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    
    private lazy var downloadQueue: OperationQueue = {
        $0.maxConcurrentOperationCount = 10
        return $0
    }(OperationQueue())
    
    // MARK: - Methods
    
    func suspendAllOperations() {
        downloadQueue.isSuspended = true
        
        if downloadQueue.operationCount > 200 {
            downloadQueue.cancelAllOperations()
            downloadsInProgress.removeAll()
        }
    }
    
    func resumeAllOperations() {
        downloadQueue.isSuspended = false
    }
    
    func startDownload(_ url: URL, at indexPath: IndexPath, completion: ((Data?) -> Void)? = nil) {
        let completionInMainThread = { [weak self] (imgData: Data?) in
            DispatchQueue.main.async {
                let imgDataLow = imgData?.imageData(withCompression: .low)
                self?.downloadsInProgress.removeValue(forKey: indexPath)
                completion?(imgDataLow)
            }
        }
        
        guard downloadsInProgress[indexPath] == nil else {
            completionInMainThread(nil)
            return
        }
        
        let operation = NetworkImageOperation(url) { completionInMainThread($0) }
        downloadsInProgress[indexPath] = operation
        downloadQueue.addOperation(operation)
    }
    
    func indexpathsForLatestOperations(_ indexpaths: [IndexPath]) -> [IndexPath] {
        let allOperations = Set(downloadsInProgress.keys)
        
        var toBeCancelled = allOperations
        let visibles = Set(indexpaths)
        toBeCancelled.subtract(visibles)
        
        var toBeStarted = visibles
        toBeStarted.subtract(allOperations)
        
        for idx in toBeCancelled {
            downloadsInProgress[idx]?.cancel()
            downloadsInProgress.removeValue(forKey: idx)
        }
        
        return Array(toBeStarted)
    }
}

class NetworkImageOperation: AsynchronousOperation {
    
    // MARK: - Properties
    
    private let url: URL
    private let completionHandler: ((Data?) -> Void)?

    private var task: URLSessionDataTask?
    
    // MARK: - Lifecycle
    
    init(_ url: URL, completionHandler: ((Data?) -> Void)? = nil) {
        self.url = url
        self.completionHandler = completionHandler
    }
    
    // MARK: - Override
    
    override func main() {
        task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            defer { self?.state = .finished }
            guard let this = self, !this.isCancelled else {
                self?.completionHandler?(nil)
                return
            }
            
            guard error == nil, let data = data else {
                self?.completionHandler?(nil)
                return
            }
            
            self?.completionHandler?(data)
        }
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
}
