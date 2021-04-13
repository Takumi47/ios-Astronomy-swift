//
//  AstronomyViewCell.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//

import UIKit

class AstronomyViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseId = "\(AstronomyViewCell.self)"
    
    fileprivate var imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = #imageLiteral(resourceName: "placeholder")
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    fileprivate var titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 3
        $0.textAlignment = .center
        $0.textColor = .cloudDancer
        $0.font = UIFont.systemFont(ofSize: 20)
        return $0
    }(UILabel())
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
    
    // MARK: - Private Implementation
    
    private func initUI() {
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func clear() {
        imageView.image = #imageLiteral(resourceName: "placeholder")
        titleLabel.text = ""
    }
}

// MARK: - CellBouncible

extension AstronomyViewCell: CellBouncible {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
}

// MARK: - Methods

extension AstronomyViewCell {
    func configure(_ title: String?, _ thumbnail: Data?) {
        titleLabel.text = title

        if let data = thumbnail {
            imageView.image = UIImage(data: data) ?? #imageLiteral(resourceName: "placeholder")
        }
    }
}
