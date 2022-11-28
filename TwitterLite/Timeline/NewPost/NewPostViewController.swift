//
//  NewPostViewController.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 25/11/22.
//

import Foundation
import UIKit

class NewPostViewController: UIViewController {
    
    private lazy var addTweetButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle("Add Tweet", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(addTweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        return button
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        return picker
    }()
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle("Add Image", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var successUploadLabel: UILabel = {
        let label = UILabel()
        label.text = "Image Successfully Uploaded !"
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    private let captionTextView = ContentTextView()
    private var imageContent: UIImage?
    private let viewModel: NewPostViewModel
    
    init(viewModel: NewPostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        imagePicker.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: addTweetButton), UIBarButtonItem(customView: addImageButton)]
        
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        successUploadLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(captionTextView)
        view.addSubview(successUploadLabel)
        
        captionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        captionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        captionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        captionTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        captionTextView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        successUploadLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        successUploadLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        successUploadLabel.topAnchor.constraint(equalTo: captionTextView.bottomAnchor).isActive = true
        successUploadLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        successUploadLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        successUploadLabel.isHidden = true
        
    }
    
    @objc func addTweetTapped() {
        guard let caption = captionTextView.text else { return }
        
        if caption == "" && self.imageContent == nil {
            let alert = UIAlertController(title: "Please write or upload something", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(alert, animated: true)
        } else {
            let imageData = self.imageContent?.jpegData(compressionQuality: 0.3) ?? nil
            viewModel.uploadTweet(content: caption, image: imageData) { (error) in
                if let error = error {
                    print("Error Uploading Tweet \(error.localizedDescription)")
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func addImageTapped() {
        present(imagePicker, animated: true)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        self.imageContent = image
        successUploadLabel.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
}
