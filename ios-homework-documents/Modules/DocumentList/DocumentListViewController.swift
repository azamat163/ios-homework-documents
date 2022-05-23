//
//  DocumentListViewController.swift
//  ios-homework-documents
//
//  Created by a.agataev on 29.04.2022.
//

import UIKit
import SnapKit

final class DocumentListViewController: UIViewController {
    private let viewModel: DocumentListViewModel
    
    private lazy var collectionView: UICollectionView = {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.dataSource = self
        collectionView.register(DocumentCollectionViewCell.self, forCellWithReuseIdentifier: DocumentCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var spinnerView: UIActivityIndicatorView = {
        spinnerView = UIActivityIndicatorView(style: .large)
        spinnerView.color = .lightGray
        return spinnerView
    }()

    init(viewModel: DocumentListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
        setupNavigationBar()
        setup()
        
        setupViewModel()
        viewModel.send(.viewIsReady)
    }

    private func setup() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(spinnerView)
        
        spinnerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add photo", style: .plain, target: self, action: #selector(addPhotoTapped))
    }
    
    @objc
    private func addPhotoTapped() {
        let alertVc = UIAlertController(title: "Pick a photo", message: "Choose a picture from Library or camera", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] action in
            guard let self = self else { return }
            let cameraImagePickerVc = self.imagePickerVc(sourceType: .camera)
            cameraImagePickerVc.delegate = self
            self.present(cameraImagePickerVc, animated: true)
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] action in
            guard let self = self else { return }
            let libraryImagePickerVc = self.imagePickerVc(sourceType: .photoLibrary)
            libraryImagePickerVc.delegate = self
            self.present(libraryImagePickerVc, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVc.addAction(cameraAction)
        alertVc.addAction(libraryAction)
        alertVc.addAction(cancelAction)
        
        present(alertVc, animated: true)
    }
    
    private func setupViewModel() {
        viewModel.onStateChanged = { [weak self] state in
                    guard let self = self else { return }
                    switch state {
                    case .initial:
                        self.hideContent()
                        self.spinnerView.startAnimating()
                    case .loading:
                        self.hideContent()
                        self.spinnerView.startAnimating()
                    case .loaded:
                        self.spinnerView.stopAnimating()
                        self.showContent()
                        self.collectionView.reloadData()
                    }
                }
    }
    
    private func showContent() {
        UIView.animate(withDuration: 0.25) {
            self.collectionView.alpha = 1
        }
    }
    
    private func hideContent() {
        UIView.animate(withDuration: 0.25) {
            self.collectionView.alpha = 0
        }
    }
}

extension DocumentListViewController {
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(225))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(225))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        section.interGroupSpacing = 8
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension DocumentListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocumentCollectionViewCell.identifier, for: indexPath) as? DocumentCollectionViewCell else { return UICollectionViewCell() }
        
        let model = viewModel.documents[indexPath.row]
        cell.configure(model: model)
        
        return cell
    }
}

extension DocumentListViewController {
    private func imagePickerVc(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        return imagePickerController
    }
}

extension DocumentListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        viewModel.saveImageInDocuments(image: image)
        self.dismiss(animated: true, completion: { [weak self] in
            self?.viewModel.send(.viewIsReady)
        })
    }
}
