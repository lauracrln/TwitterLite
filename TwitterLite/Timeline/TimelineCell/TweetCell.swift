//
//  TweetCell.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 22/11/22.
//

import Foundation
import RxCocoa
import UIKit
import Firebase
import SDWebImage

class TweetCell: UICollectionViewCell {
    
    public let reuseID = "TweetCell"
    
    private var tweet: Tweet?
    private var imageHeightConstraint: NSLayoutConstraint?
    private var imageContentWidthConstraint: NSLayoutConstraint?
    private var contentLabelHeightConstraint: NSLayoutConstraint?
    
    var maxImageWidth: CGFloat = 100
    
    var reloadSize: (() -> Void)?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 10 , height: 10)
        imageView.layer.cornerRadius = 10/2
        imageView.layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var imageContent: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = UIStackView.Alignment.leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.0
        
        return stackView
    }()
    
    private lazy var imageContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 12.0
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubview(imageContentStackView)
        imageContentStackView.addArrangedSubview(profileImageView)
        imageContentStackView.addArrangedSubview(contentStackView)
        contentStackView.addArrangedSubview(usernameLabel)
        contentStackView.addArrangedSubview(contentLabel)
        contentStackView.addArrangedSubview(imageContent)
        imageContentStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        imageContent.widthAnchor.constraint(lessThanOrEqualTo: contentStackView.widthAnchor).isActive = true
        
        imageContentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageContentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10).isActive = true
        imageContentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
        imageContentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        imageContentWidthConstraint = imageContent.widthAnchor.constraint(equalToConstant: 100)
        imageContentWidthConstraint?.isActive = true
        
        imageHeightConstraint = imageContent.heightAnchor.constraint(equalToConstant: 100)
        imageHeightConstraint?.isActive = true
        
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    public func configure(with viewModel: TweetCellViewModel) {
        
        profileImageView.image = viewModel.profileImage
        
        usernameLabel.attributedText = viewModel.userInfo
        let unconstrainedSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        usernameLabel.heightAnchor.constraint(equalToConstant: usernameLabel.sizeThatFits(unconstrainedSize).height).isActive = true
        
        if let content = viewModel.content {
            contentLabel.text = content
            contentLabel.heightAnchor.constraint(equalToConstant: Helper().getLabelHeight(text: content, width: imageContentStackView.frame.size.width)).isActive = true
        } else {
            contentLabel.isHidden = true
        }
        if let image = viewModel.imageContent {
            imageContent.sd_setImage(with: image) { [weak self] image, error, cache, url  in
                if error == nil {
                    
                    let originalImageWidth = self?.imageContent.image?.size.width ?? 100
                    
                    let imageWidth = min((self?.maxImageWidth ?? 100) - 88, originalImageWidth)
                    
                    let ratio = imageWidth/originalImageWidth
                    
                    var imageHeight = self?.imageContent.image?.size.height ?? 100
                    imageHeight = imageHeight * ratio
                    
                    self?.imageContentWidthConstraint?.constant = imageWidth
                    self?.imageHeightConstraint?.constant = imageHeight
                    self?.reloadSize?()
                }
            }
        } else {
            imageContent.isHidden = true
        }
    }
}

