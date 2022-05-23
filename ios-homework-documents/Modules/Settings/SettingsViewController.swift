//
//  SettingsViewController.swift
//  ios-homework-documents
//
//  Created by a.agataev on 16.05.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Change password", for: .normal)
        button.addTarget(self, action: #selector(changePasswordTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var sortSwitch: UISwitch = {
        let sortSwitch = UISwitch(frame: .zero)
        sortSwitch.addTarget(self, action: #selector(changeSort), for: .valueChanged)
        return sortSwitch
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                changePasswordButton,
                sortSwitch
        ])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 3
        
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        setup()
        
        let ud = UserDefaults.standard
        let isSortAsc: Bool = ud.bool(forKey: .isSortAsc)
        sortSwitch.setOn(isSortAsc, animated: false)
    }
    
    private func setup() {
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        changePasswordButton.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        sortSwitch.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
    
    @objc
    func changePasswordTapped() {
        let vc = PasswordViewController(viewModel: PasswordViewModel())
        present(vc, animated: true)
    }
    
    @objc func changeSort() {
        let ud = UserDefaults.standard
        
        if sortSwitch.isOn {
            ud.set(true, forKey: .isSortAsc)
        } else {
            ud.set(false, forKey: .isSortAsc)
        }
    }
}

extension String {
    static let isSortAsc = "isSortAsc"
}
