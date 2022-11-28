//
//  DetailPostViewController.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 27/11/22.
//

import Foundation
import UIKit

class DetailPostViewController: UIViewController {
    
    private var maxImageWidth: CGFloat = 100
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 10 , height: 10)
        imageView.layer.cornerRadius = 10/2
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
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
        label.lineBreakMode = .byWordWrapping
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
    
    private var imageContentHeightConstraint: NSLayoutConstraint?
    private var imageContentWidthConstraint: NSLayoutConstraint?
    private var contentLabelHeightConstraint: NSLayoutConstraint?
    
    private var tweet: Tweet
    private var viewModel: DetailPostViewModel
    
    init(tweet: Tweet, viewModel: DetailPostViewModel) {
        self.tweet = tweet
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    func setupUI() {
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete Post", style: .plain, target: self, action: #selector(deletePostTapped))
        view.backgroundColor = .white
        view.addSubview(imageContentStackView)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        imageContentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        imageContentStackView.addArrangedSubview(profileImageView)
        imageContentStackView.addArrangedSubview(contentStackView)
        contentStackView.addArrangedSubview(usernameLabel)
        contentStackView.addArrangedSubview(contentLabel)
        contentStackView.addArrangedSubview(imageContent)
    
        imageContentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        imageContentStackView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageContentStackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        imageContent.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor).isActive = true
        imageContentWidthConstraint = imageContent.widthAnchor.constraint(equalToConstant: 100)
        imageContentWidthConstraint?.isActive = true
        
        imageContentHeightConstraint = imageContent.heightAnchor.constraint(equalToConstant: 100)
        imageContentHeightConstraint?.isActive = true
        
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        contentLabel.heightAnchor.constraint(equalToConstant: Helper().getLabelHeight(text: tweet.content ?? "", width: view.frame.size.width)).isActive = true
    }
    
    func configure() {
        profileImageView.image = tweet.profileImage
        
        usernameLabel.attributedText = getInfoAttributedString()
        let unconstrainedSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        usernameLabel.heightAnchor.constraint(equalToConstant: usernameLabel.sizeThatFits(unconstrainedSize).height).isActive = true
        
        if let content = tweet.content {
            contentLabel.text = content
        } else {
            contentLabel.isHidden = true
        }
        
        if let image = tweet.imageUrl {
            imageContent.sd_setImage(with: image) { [weak self] image, error, cache, url  in
                if error == nil {
                    
                    let originalImageWidth = self?.imageContent.image?.size.width ?? 100
                    let imageWidth = min((self?.view.frame.size.width ?? 100) - 88, originalImageWidth)
                    
                    let ratio = imageWidth/originalImageWidth
                    
                    var imageHeight = self?.imageContent.image?.size.height ?? 100
                    imageHeight = imageHeight * ratio
                    
                    self?.imageContentWidthConstraint?.constant = imageWidth
                    self?.imageContentHeightConstraint?.constant = imageHeight
                }
            }
        } else {
            imageContent.isHidden = true
        }
    }
    
    func getInfoAttributedString() -> NSAttributedString {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let timeStamp = formatter.string(from: tweet.timestamp, to: Date()) ?? "2m"
        
        let title = NSMutableAttributedString(string: "@\(tweet.username)", attributes: [.font: UIFont.systemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " ·\(timeStamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    @objc func deletePostTapped() {
        let deletePostAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
            self?.viewModel.deleteTweet(tweetId: self?.tweet.tweetId ?? "")
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(deletePostAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}
