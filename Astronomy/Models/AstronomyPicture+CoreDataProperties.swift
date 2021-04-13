//
//  AstronomyPicture+CoreDataProperties.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//
//

import Foundation
import CoreData


extension AstronomyPicture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AstronomyPicture> {
        return NSFetchRequest<AstronomyPicture>(entityName: "AstronomyPicture")
    }

    @NSManaged public var picture: Data?
    @NSManaged public var astronomy: Astronomy?

}

extension AstronomyPicture : Identifiable {}
