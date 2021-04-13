//
//  Astronomy+CoreDataClass.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//
//

import Foundation
import CoreData

@objc(Astronomy)
public class Astronomy: NSManagedObject {
    
    public class func currentCount() -> Int {
        let fetchRequest: NSFetchRequest<Astronomy> = Astronomy.fetchRequest()
        return (try? CoreDataStack.apod.mainContext.count(for: fetchRequest)) ?? 0
    }
    
    public class func deleteAll() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Astronomy.fetchRequest())
        deleteRequest.resultType = .resultTypeCount
        
        do {
            let resultBox = try CoreDataStack.apod.mainContext.execute(deleteRequest) as! NSBatchDeleteResult
            let count = resultBox.result as! Int
            print("Removed \(count) objects.")
        } catch let err as NSError {
            print("ERROR: \(err.localizedDescription)")
        }
        
        CoreDataStack.apod.saveContext()
    }
    
    func updateThumbnail(_ thumbnail: Data?) {
        self.pictureThumbnail = thumbnail
        CoreDataStack.apod.saveContext()
    }
    
    func updatePicture(_ pic: Data?) {
        self.picture?.picture = pic
        CoreDataStack.apod.saveContext()
    }
}
