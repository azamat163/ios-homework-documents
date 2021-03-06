//
//  DocumentListViewModel.swift
//  ios-homework-documents
//
//  Created by a.agataev on 29.04.2022.
//

import Foundation
import UIKit

struct Document {
    let id: Int
    let image: UIImage
}

final class DocumentListViewModel {
    var onStateCHanged: ((State) -> Void)?
    
    private(set) var state: State = .initial {
        didSet {
            onStateCHanged?(state)
        }
    }

    private let fileManager = FileManager.default
    private(set) var documents = [Document]()
    
    func send(_ action: Action) {
        switch action {
        case .viewIsReady:
            state = .loading
            fetchDocuments()
        }
    }
    
    private func fetchDocuments() {
        var docs = [Document]()
        let directoryContents = try! fileManager.contentsOfDirectory(at: URL.documents, includingPropertiesForKeys: nil)
        for (index, imageURL) in directoryContents.enumerated() where imageURL.pathExtension == "png" {
            let image = UIImage(contentsOfFile: imageURL.path)
            guard let image = image else { return }
            docs.append(Document(
                id: index,
                image: image
            ))
        }
        documents = docs.sorted(by: { $0.id > $1.id })
        state = .loaded
    }
    
    func saveImageInDocuments(image: UIImage?) {
        let url = URL.documents.appendingPathComponent("new_image_\(image.hashValue).png")
        
        if let data = image?.pngData() {
            do {
                try data.write(to: url)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

extension DocumentListViewModel {
    enum Action {
        case viewIsReady
    }
    
    enum State {
        case initial
        case loading
        case loaded
    }
}

extension URL {
    static var documents: URL {
        return FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
