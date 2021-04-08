//
//  NavigationView.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 7.4.21.
//

import Foundation
import SnapKit
import UIKit

protocol NavigationViewDelegate: AnyObject {
    func didTapBack()
}

class NavigationView: UIView {
    

    enum NavigationState {
        case onlyTitle
        case backAndTitle
    }
    
    private weak var delegate: NavigationViewDelegate?
    private var gradientLayer: CAGradientLayer?
    
    private lazy var btnBack: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let state: NavigationState
    
    init(state: NavigationState, delegate: NavigationViewDelegate?, title: String) {
        self.state = state
        super.init(frame: .zero)
        self.delegate = delegate
        lblTitle.text = title
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupGradient()
        switch state {
        case .onlyTitle:
            addSubview(lblTitle)
            lblTitle.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.leading.equalToSuperview().offset(16)
                make.top.equalToSuperview().inset(61)
                make.trailing.equalToSuperview().inset(16)
            }
        case .backAndTitle:
            addSubview(btnBack)
            addSubview(lblTitle)
            btnBack.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(13)
                make.top.equalToSuperview().inset(59)
                make.width.equalTo(20)
                make.height.equalTo(26)
            }
            
            lblTitle.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.leading.equalTo(btnBack.snp.trailing).offset(30)
                make.top.equalToSuperview().inset(61)
                make.trailing.equalToSuperview().inset(16)
            }
        }
    }
    
    private func setupGradient() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [UIColor(hex: "5AC7AA").cgColor, UIColor(hex: "9ADCB9").cgColor]
        gradientLayer?.startPoint = CGPoint(x: 0 , y: 0.5)
        gradientLayer?.startPoint = CGPoint(x: 1 , y: 0.5)
        gradientLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 124)
        layer.addSublayer(gradientLayer!)
    }
    

    @objc private func onBack() {
        delegate?.didTapBack()
    }
}
