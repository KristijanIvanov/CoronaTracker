//
//  CountryTableViewCell.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 10.4.21.
//

import UIKit
import SnapKit

protocol CountrySelectionDelegate: AnyObject {
    func didChangeValue(country: Country)
}

class CountryTableViewCell: UITableViewCell {
    
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(hex: "3C3C3C")
        return label
    }()
    
    private lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor(hex: "5AC7AA")
        switchControl.addTarget(self, action: #selector(onSwitch), for: .valueChanged)
        return switchControl
    }()
    
    weak var delegate: CountrySelectionDelegate?
    private var country: Country?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(lblTitle)
        contentView.addSubview(switchControl)
        
        lblTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(switchControl.snp.leading).inset(15)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        
        switchControl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    func setupCellData(country: Country) {
        self.country = country
        lblTitle.text = country.name
        switchControl.isOn = country.isSelected
    }
    
    @objc private func onSwitch() {
        guard let country = country else {return}
        if switchControl.isOn {
            country.save()
        } else {
            country.delete()
        }
        delegate?.didChangeValue(country: country)
    }

}


