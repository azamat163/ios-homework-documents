//
//  PasswordViewModel.swift
//  ios-homework-documents
//
//  Created by a.agataev on 16.05.2022.
//

import Foundation

final class PasswordViewModel {
    var onStateChanged: ((State) -> Void)?
    private(set) var state: State = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    private let keyChain = KeyChain()
    private let key = "aagataevKey"
    private let minCountPassword = 4
    private var currentPassword: String = ""
    
    func send(_ action: Action) {
        switch action {
        case .createPassword(let enterPassword):
            if enterPassword.count < minCountPassword {
                state = .error(.rulePassword)
                return
            }
            currentPassword = enterPassword
            state = .confirmPassword
        case .confirmPassword(let enterPassword):
            if currentPassword != enterPassword {
                state = .error(.wrongConfirmPassword)
            } else {
                savePassword(password: currentPassword)
                state = .home
            }
        case .loginTapped:
            guard let password = getPassword() else {
                state = .createPassword
                return
            }
            currentPassword = password
            state = .confirmPassword
        }
    }
    
    private func savePassword(password: String) {
        guard let data = password.data(using: .utf8) else { return }
        keyChain.save(key: key, data: data)
    }
    
    private func getPassword() -> String? {
        guard let data = keyChain.read(key: key) else { return nil }
        guard let password = String(data: data, encoding: .utf8) else { return nil }
        return password
    }
}

extension PasswordViewModel {
    enum State {
        case initial
        case createPassword
        case confirmPassword
        case error(PasswordError)
        case home
    }
    
    enum Action {
        case createPassword(String)
        case confirmPassword(String)
        case loginTapped
    }
}

enum PasswordError: Error {
    case notFound
    case rulePassword
    case wrongPassword
    case wrongConfirmPassword
}

extension PasswordError {
    var errorDescription: String {
        switch self {
        case .notFound:
            return "Пароль не найден"
        case .rulePassword:
            return "Пароль минимум должен из 4-х символов"
        case .wrongPassword:
            return "Неверный пароль"
        case .wrongConfirmPassword:
            return "Пароли не совпадают. Повторите попытку."
        }
    }
}
