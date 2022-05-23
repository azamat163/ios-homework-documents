//
//  HomeViewController.swift
//  ios-homework-documents
//
//  Created by a.agataev on 16.05.2022.
//

import UIKit

class HomeViewController: UITabBarController {
    
    private enum Constants {
        static let files = UIImage(systemName: "list.bullet.rectangle")
        static let settings = UIImage(systemName: "gearshape")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.tintColor = .black
        
        setupVCs()
    }
    
    //MARK: - setup viewControllers
    
    func setupVCs() {
        viewControllers = [
            createNavController(
                for: DocumentListViewController(viewModel: DocumentListViewModel()),
                title: "Document List",
                image: Constants.files!
            ),
            createNavController(
                for: SettingsViewController(),
                title: "Settings",
                image: Constants.settings!
            )
        ]
    }
    
    private func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = image.withTintColor(.purple, renderingMode: .automatic)
        navController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title
        return navController
    }
}
