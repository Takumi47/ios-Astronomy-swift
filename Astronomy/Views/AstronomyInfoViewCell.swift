//
//  AstronomyInfoViewCell.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//

import UIKit

class AstronomyInfoViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseId = "\(AstronomyInfoViewCell.self)"
    
    fileprivate var vStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 10
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 10, left: 16, bottom: 20, right: 16)
        return $0
    }(UIStackView())
    
    fileprivate var titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return $0
    }(UILabel())
    
    fileprivate var copyrightLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15)
        return $0
    }(UILabel())
    
    fileprivate var descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.textAlignment = .justified
        $0.lineBreakMode = .byWordWrapping
        $0.font = UIFont.systemFont(ofSize: 17)
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
        layoutAttributes.bounds.size.height = vStack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    // MARK: - Private Implementation
    
    private func initUI() {
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(copyrightLabel)
        vStack.addArrangedSubview(descriptionLabel)
        
        contentView.addSubview(vStack)
        vStack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    private func clear() {
        titleLabel.text = ""
        copyrightLabel.text = ""
        descriptionLabel.text = ""
    }
}

// MARK: - Methods

extension AstronomyInfoViewCell {
    func configure(_ title: String?, _ copyright: String?, _ description: String?) {
        titleLabel.text = title
        
        if let copyright = copyright {
            copyrightLabel.text = "Credit & Copyright: \(copyright)"
        }
        
        descriptionLabel.text = description
    }
}
