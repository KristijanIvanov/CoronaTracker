//
//  CountryMapCollectionViewCell.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 26.4.21.
//

import UIKit
import SnapKit

protocol didClickOnMap: AnyObject {
    func showMap()
}

class CountryMapCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: didClickOnMap?
    
    lazy var flagImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
       return image
    }()
 
    lazy var label: UILabel = {
        var label = UILabel()
        label.text = "Total cases by DHB"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
       return label
    }()
    
    lazy var button: UIButton = {
        var button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitle("View Country Map", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(onMap), for: .touchUpInside)
       return button
    }()
    
    private var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(63)
        }
        verticalStackView.addArrangedSubview(label)
        verticalStackView.addArrangedSubview(button)
        contentView.addSubview(flagImage)
        contentView.addSubview(verticalStackView)

        flagImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.top.bottom.equalToSuperview().offset(2)
//            make.trailing.equalTo(verticalStackView)
            make.height.width.equalTo(32)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.leading.equalTo(flagImage).offset(5)
//            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(38)
//            make.top.bottom.equalToSuperview()
        }
    }
    
    @objc func onMap() {
        delegate?.showMap()
    }
}
