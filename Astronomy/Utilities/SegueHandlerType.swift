//
//  SegueHandlerType.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//

import UIKit

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any? = nil) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier: \(String(describing: segue.identifier))")
        }
        return segueIdentifier
    }
}
