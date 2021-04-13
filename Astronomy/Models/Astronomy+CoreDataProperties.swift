//
//  Astronomy+CoreDataProperties.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//
//

import Foundation
import CoreData


extension Astronomy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Astronomy> {
        return NSFetchRequest<Astronomy>(entityName: "Astronomy")
    }

    @NSManaged public var title: String?
    @NSManaged public var pictureThumbnail: Data?
    @NSManaged public var hdurl: URL?
    @NSManaged public var apod_site: URL?
    @NSManaged public var url: URL?
    @NSManaged public var copyright: String?
    @NSManaged public var desc: String?
    @NSManaged public var date: Date?
    @NSManaged public var media_tyupe: String?
    @NSManaged public var index: Int16
    @NSManaged public var picture: AstronomyPicture?

}

extension Astronomy : Identifiable {}
