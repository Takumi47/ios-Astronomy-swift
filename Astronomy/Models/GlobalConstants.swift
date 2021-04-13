//
//  GlobalConstants.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//

import Foundation

private let kJSONUrlStr = "https://raw.githubusercontent.com/cmmobile/NasaDataSet/main/apod.json"

struct GlobalConstants {
    static let jsonURL = URL(string: kJSONUrlStr)!
}
