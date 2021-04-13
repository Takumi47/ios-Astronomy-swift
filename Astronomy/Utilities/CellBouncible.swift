//
//  CellBouncible.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//

import UIKit

private let kHighlightedFactor: CGFloat = 0.86

protocol CellBouncible {}

extension CellBouncible where Self: UIView {
    func animate(isHighlighted: Bool, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [.allowUserInteraction],
            animations: {
                if isHighlighted {
                    self.transform = .init(scaleX: kHighlightedFactor, y: kHighlightedFactor)
                } else {
                    self.transform = .identity
                }
            },
            completion: completion)
    }
}
