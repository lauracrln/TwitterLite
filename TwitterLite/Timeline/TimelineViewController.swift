//
//  TimelineViewController.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 21/11/22.
//

import Foundation
import UIKit
import FirebaseAuth
import RxSwift
import SDWebImage


class TimelineViewController: UICollectionViewController {
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        return picker
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 16.0
        
        return stackView
    }()
    
    var viewModel: TimelineViewModel
    
    init(viewModel: TimelineViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    let commentFlowLayout = UICollectionViewFlowLayout()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
        fetchTweets()
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchTweets()
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80.0)
        self.navigationController?.navigationBar.backgroundColor = .green
        
        let addTweet = UIImage(named: "new_tweet")?.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: addTweet, style:.plain, target: self, action: #selector(addTweetTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutTapped))
        
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        let image = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        image.contentMode = .scaleAspectFit
        image.frame.size = CGSize(width: 32, height: 32)
        navigationItem.titleView = image
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor.systemBlue
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            self.navigationController?.edgesForExtendedLayout = []
        }
    }
    
    func setupUI() {
        
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: "TweetCell")
        collectionView.backgroundColor = .white
        
        collectionView.isScrollEnabled = true
        collectionView.isUserInteractionEnabled = true
        collectionView.alwaysBounceVertical = true

        commentFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        commentFlowLayout.minimumInteritemSpacing = 10
        commentFlowLayout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = commentFlowLayout
        
        configureRefreshControl()
    }
    
    func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTweets), for: .valueChanged)
    }

    @objc func refreshTweets() {
        fetchTweets()
    }
    
    func fetchTweets() {
        collectionView.refreshControl?.beginRefreshing()
        viewModel.fetchTweets { [weak self] tweets in
            guard let self = self else { return }
            
            self.tweets = tweets.sorted(by: { $0.timestamp > $1.timestamp })
            
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
      
    @objc func addTweetTapped() {
        let viewModel = NewPostViewModel()
        let vc = NewPostViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func signOutTapped() {
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] action in
            do{
                try Auth.auth().signOut()
                let loginViewController = LoginViewController(viewModel: LoginViewModel())
                self?.navigationController?.pushViewController(loginViewController, animated: true)
            }
            catch let error {
                print("Error Logging Out \(error.localizedDescription)")
                let alert = UIAlertController(title: "Sign out error", message: error.localizedDescription, preferredStyle: .alert)
                self?.present(alert, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(signOutAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
}

extension TimelineViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as? TweetCell else { return UICollectionViewCell() }
        
        let viewModel = TweetCellViewModel(tweet: tweets[indexPath.row])
        
        cell.configure(with: viewModel)
        cell.maxImageWidth = collectionView.frame.size.width
        cell.reloadSize = { [weak self] in
            self?.collectionView.reloadItems(at: [indexPath])
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = DetailPostViewModel()
        let vc = DetailPostViewController(tweet: tweets[indexPath.row], viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TimelineViewController: UIBarPositioningDelegate, UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
            return .topAttached
        }
}

