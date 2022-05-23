//
//  PasswordViewController.swift
//  ios-homework-documents
//
//  Created by a.agataev on 11.05.2022.
//

import UIKit
import SnapKit

final class PasswordViewController: UIViewController {
    
    private let viewModel: PasswordViewModel
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "enter password"
        textField.isSecureTextEntry = true
        textField.textContentType = .newPassword
        textField.backgroundColor = .systemGray6
        
        return textField
    }()
    
    private lazy var passwordButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Enter password", for: .normal)
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                passwordTextField,
                passwordButton
        ])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 3
        
        return stackView
    }()
    
    init(viewModel: PasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Экран ввода пароля"
    
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        setup()
        setupViewModel()
    }
    
    private func setup() {
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        passwordButton.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
    
    private func setupViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .createPassword:
                self.passwordButton.setTitle("Enter password", for: .normal)
                let password = self.passwordTextField.text
                self.viewModel.send(.createPassword(password ?? ""))
                self.passwordTextField.text = nil
            case .confirmPassword:
                self.passwordButton.setTitle("Confirm password", for: .normal)
                let password = self.passwordTextField.text
                self.viewModel.send(.confirmPassword(password ?? ""))
                self.passwordTextField.text = nil
            case .error(let error):
                CommonAlertError.present(vc: self, with: error.errorDescription)
                self.passwordTextField.text = nil
            case .home:
                self.goToHome()
            case .initial:
                print("initial")
            }
        }
    }
    
    private func goToHome() {
        let vc = HomeViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc
    func loginTapped() {
        viewModel.send(.loginTapped)
    }
}
