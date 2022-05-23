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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(bounds.width)
            make.bottom.equalTo(titleLabel.snp.top).offset(-5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
    }
}

extension DocumentCollectionViewCell {
    typealias Model = Document
    
    func configure(model: Model) {
        imageView.image = model.image
        titleLabel.text = model.title
    }
}
