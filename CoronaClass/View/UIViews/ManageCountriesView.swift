//
//  ManageCountriesView.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 11.4.21.
//

import Foundation
import UIKit
import SnapKit

protocol buttonPressedDelegate: AnyObject {
    func buttonPressed()
}

class ManageCountriesView: UIView {
    
    private lazy var trackCountries: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.titleLabel?.text = "Track countries"
        button.titleLabel?.textAlignment = .center
        if button.isSelected {
            button.backgroundColor = UIColor(hex: "#5AC7AA")
            button.titleLabel?.textColor = UIColor(hex: "#FFFFFF")
        } else if !button.isSelected {
            button.backgroundColor = UIColor(hex: "#EDEDED")
            button.titleLabel?.textColor = UIColor(hex: "#3C3C3C")
        }
        button.addTarget(self, action: #selector(isPressed), for: .touchUpOutside)
        return button
    }()
    
    private lazy var manageCountries: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.titleLabel?.text = "Manage countries"
        button.titleLabel?.textAlignment = .center
        if button.isSelected {
            button.backgroundColor = UIColor(hex: "#5AC7AA")
            button.titleLabel?.textColor = UIColor(hex: "#FFFFFF")
        } else if !button.isSelected {
            button.backgroundColor = UIColor(hex: "#EDEDED")
            button.titleLabel?.textColor = UIColor(hex: "#3C3C3C")
        }
        button.addTarget(self, action: #selector(isPressed), for: .touchUpOutside)
        return button
    }()
    
    private lazy var horizontalStack: UIStackView = {
        let hStack = UIStackView()
        hStack.addArrangedSubview(trackCountries)
        hStack.addArrangedSubview(manageCountries)
        hStack.axis = .horizontal
        hStack.alignment = .fill
        hStack.distribution = .fillEqually
        hStack.spacing = 34
        return hStack
    }()
    
    weak var delegate: buttonPressedDelegate?
    
    init(delegate: buttonPressedDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(horizontalStack)
        horizontalStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.leading.equalToSuperview().inset(18)
            make.height.equalTo(38)
        }
        setupButtons(button: trackCountries)
        setupButtons(button: manageCountries)
    }
    
    private func setupButtons(button: UIButton) {
        button.snp.makeConstraints { make in
            make.height.equalTo(38)
        }
    }

    @objc private func isPressed() {
        
    }
}
