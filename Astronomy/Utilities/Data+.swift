//
//  Data+.swift
//  Astronomy
//
//  Created by xander on 2021/4/13.
//

import UIKit

extension Data {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func imageData(withCompression quality: JPEGQuality) -> Data? {
        guard let image = UIImage(data: self) else { return nil }
        return image.jpegData(compressionQuality: quality.rawValue)
    }
}
