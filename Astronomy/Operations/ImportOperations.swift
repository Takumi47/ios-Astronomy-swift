//
//  ImportOperations.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//

import Foundation

private let kAmountToImport = 5178

class ImportOperations {
    
    // MARK: - Properties
    
    private lazy var importQueue: OperationQueue = {
        $0.maxConcurrentOperationCount = 1
        return $0
    }(OperationQueue())
    
    // MARK: - Methods
    
    func importJSONFileIfNeeded(completion: ((Bool) -> Void)? = nil) {
        let operation = ImportOperation { isLoaded in
            DispatchQueue.main.async { completion?(isLoaded) }
        }
        
        importQueue.cancelAllOperations()
        importQueue.addOperation(operation)
    }
}

class ImportOperation: AsynchronousOperation {
    
    // MARK: - Properties
    
    private let completionHandler: ((Bool) -> Void)?
    
    // MARK: - Lifecycle
    
    init(completionHandler: ((Bool) -> Void)? = nil) {
        self.completionHandler = completionHandler
    }
    
    // MARK: - Private Implementation
    
    override func main() {
        let count = Astronomy.currentCount()
        print("▶️ count: \(count)")
        
        guard kAmountToImport != count else {
            completionHandler?(true)
            state = .finished
            return
        }
        
        Astronomy.deleteAll()

        JSONService.shared.getJSONObject(method: .post, url: GlobalConstants.jsonURL) { [weak self] jsonObj in
            defer { self?.state = .finished }
            
            guard let jsonArray = jsonObj else {
                self?.completionHandler?(false)
                return
            }
            
            var i: Int16 = 0
            for jsonDict in jsonArray {
                let title = jsonDict["title"] as! String
                let copyright = jsonDict["copyright"] as! String
                let mediaType = jsonDict["media_type"] as! String
                let description = jsonDict["description"] as! String
                let date = (jsonDict["date"] as! String).toDate()!
                
                let urlStr = (jsonDict["url"] as! String).components(separatedBy: .whitespaces).joined()
                let url = URL(string: urlStr)!
                
                let apodSiteStr = (jsonDict["apod_site"] as! String).components(separatedBy: .whitespaces).joined()
                let apodSite = URL(string: apodSiteStr)!
                
                let hdurlStr = (jsonDict["hdurl"] as! String).components(separatedBy: .whitespaces).joined()
                let hdurl = URL(string: hdurlStr)!
                
                let astronomy = Astronomy(context: CoreDataStack.apod.mainContext)
                astronomy.title = title
                astronomy.copyright = copyright
                astronomy.media_tyupe = mediaType
                astronomy.desc = description
                astronomy.date = date
                astronomy.url = url
                astronomy.apod_site = apodSite
                astronomy.hdurl = hdurl
                astronomy.picture = AstronomyPicture(context: CoreDataStack.apod.mainContext)
                astronomy.index = i
                
                i += 1
                if i % 20 == 0 {
                    CoreDataStack.apod.saveContext()
                    CoreDataStack.apod.mainContext.reset()
                }
            }
            
            CoreDataStack.apod.saveContext()
            CoreDataStack.apod.mainContext.reset()
            self?.completionHandler?(true)
        }
    }
}
