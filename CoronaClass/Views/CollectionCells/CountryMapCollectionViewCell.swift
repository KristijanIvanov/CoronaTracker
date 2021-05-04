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
        image.backgroundColor = .blue
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
        button.titleLabel?.text = "View country map"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        
        return layoutAttributes
    }
    
    // fixing cell width
    override func awakeFromNib() {
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        verticalStackView.addArrangedSubview(label)
        verticalStackView.addArrangedSubview(button)
        contentView.addSubview(flagImage)
        contentView.addSubview(verticalStackView)

        flagImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(verticalStackView)
            make.height.width.equalTo(38)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.leading.equalTo(flagImage)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(38)
//            make.top.bottom.equalToSuperview()
        }
    }
    
    @objc func onMap() {
        delegate?.showMap()
    }
}
