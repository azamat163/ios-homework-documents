//
//  DocumentCollectionViewCell.swift
//  ios-homework-documents
//
//  Created by a.agataev on 29.04.2022.
//

import UIKit
import SnapKit

class DocumentCollectionViewCell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(bounds.width)
        }
    }
}

extension DocumentCollectionViewCell {
    typealias Model = Document
    
    func configure(model: Model) {
        imageView.image = model.image
    }
}
