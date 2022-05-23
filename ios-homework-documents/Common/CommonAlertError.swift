//
//  CommonAlertError.swift
//  ios-homework-documents
//
//  Created by a.agataev on 23.05.2022.
//

import Foundation
import UIKit

final class CommonAlertError {
    static func present(vc: UIViewController, with message: String) {
        let OkAlertAction = UIAlertAction(title: "Ok", style: .default)
        let alertVC = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .alert
        )
        alertVC.addAction(OkAlertAction)
        vc.present(alertVC, animated: true, completion: nil)
    }
}
