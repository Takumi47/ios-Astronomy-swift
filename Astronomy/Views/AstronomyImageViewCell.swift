//
//  AstronomyImageViewCell.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//

import UIKit

private let kImageHeightByWidthRatio: CGFloat = 234.0/318

class AstronomyImageViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseId = "\(AstronomyImageViewCell.self)"
    
    fileprivate var vStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 10
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 10, left: 0, bottom: 10, right: 0)
        return $0
    }(UIStackView())
    
    fileprivate var dateLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 17)
        return $0
    }(UILabel())
    
    fileprivate var imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = #imageLiteral(resourceName: "image_placeholder")
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
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
        layoutAttributes.bounds.size.height = vStack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    // MARK: - Private Implementation
    
    private func initUI() {
        vStack.addArrangedSubview(dateLabel)
        vStack.addArrangedSubview(imageView)
        let w = contentView.bounds.width
        let h = w * kImageHeightByWidthRatio
        imageView.widthAnchor.constraint(equalToConstant: w).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: h).isActive = true
        
        contentView.addSubview(vStack)
        vStack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func clear() {
        dateLabel.text = ""
        imageView.image = #imageLiteral(resourceName: "image_placeholder")
    }
}

// MARK: - Methods

extension AstronomyImageViewCell {
    func configure(_ date: Date?, _ picture: Data?) {
        dateLabel.text = date?.toDateString()
        
        if let data = picture {
            imageView.image = UIImage(data: data) ?? #imageLiteral(resourceName: "image_placeholder")
        }
    }
}
