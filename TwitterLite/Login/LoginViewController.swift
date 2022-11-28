//
//  ViewController.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 14/11/22.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TweetLite"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .white
        
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.allowsEditingTextAttributes = true
        txtField.contentVerticalAlignment = .center
        txtField.placeholder = "Email Address"
        txtField.backgroundColor = .white
        txtField.borderStyle = .roundedRect
        txtField.autocapitalizationType = .none
        
        return txtField
    }()
    
    lazy var passwordTextField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.allowsEditingTextAttributes = true
        txtField.contentVerticalAlignment = .center
        txtField.placeholder = "Password"
        txtField.backgroundColor = .white
        txtField.borderStyle = .roundedRect
        txtField.autocapitalizationType = .none
        //        txtField.delegate = self
        
        return txtField
    }()
    
    //TODO: Change title to attributted string
    lazy var signUpButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.00)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("Sign up", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 15
        
        return btn
    }()
    
    //TODO: Change title to attributted string
    lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.00)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("Login", for: .normal)
        btn.layer.cornerRadius = 15
        
        return btn
    }()
    
    lazy var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "O R"
        label.textColor = .black
        
        return label
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
    
    var password: String = ""
    var email: String = ""
    
    var handle: AuthStateDidChangeListenerHandle?
    
    let viewModel: LoginViewModel
    let disposeBag: DisposeBag = DisposeBag()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupConstraints()
        setupViews()
//        configureLoginAction()
//        configureSignUpAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 0.11, green: 0.63, blue: 0.95, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        self.handle = Auth.auth().addStateDidChangeListener { auth, user in
            // ...
            if let user = user {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                let uid = user.uid
                let email = user.email
                let photoURL = user.photoURL
                var multiFactorString = "MultiFactor: "
                for info in user.multiFactor.enrolledFactors {
                    multiFactorString += info.displayName ?? "[DispayName]"
                    multiFactorString += " "
                }
                // ...
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        Auth.auth().removeStateDidChangeListener(self.handle!)
    }
    
    func setupViews() {
        signUpButton.addTarget(self, action: #selector(didTapSignup), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    
    func setupConstraints() {
        self.view.addSubview(stackView)
        self.stackView.addArrangedSubview(titleLabel)
        self.stackView.addArrangedSubview(emailTextField)
        self.stackView.addArrangedSubview(passwordTextField)
        self.stackView.addArrangedSubview(signUpButton)
        self.stackView.addArrangedSubview(orLabel)
        self.stackView.addArrangedSubview(loginButton)
        
        
        titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20).isActive = true
        
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        orLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 10).isActive = true
        orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        orLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        loginButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 10).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc func didTapSignup(button: UIButton) {
        viewModel.signUp(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] error in
            let title = error == nil ? self?.viewModel.successSignUpTitle : self?.viewModel.configureSignupAlertTitle(error: error ?? .unknown)
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self?.present(alert, animated: true)
        }
    }
    
    @objc func didTapLogin(button: UIButton) {
        
        viewModel.auth(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] error in
            guard let error = error else {
                let vm = TimelineViewModel()
                let vc = TimelineViewController(viewModel: vm)
                vc.modalPresentationStyle = .fullScreen
                vc.navigationItem.hidesBackButton = true
                self?.navigationController?.pushViewController(vc, animated: true)
                print("Navigate to home")
                return
            }

            let alert = UIAlertController(title: self?.viewModel.configureLoginAlertTitle(error: error), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(alert, animated: true)
        }
    }
}


