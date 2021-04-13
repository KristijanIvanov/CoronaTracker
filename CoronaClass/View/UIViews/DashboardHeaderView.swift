//
//  DashboardHeaderView.swift
//  CoronaClass
//
//  Created by Kristijan Ivanov on 4/9/21.
//

import UIKit

class DashboardHeaderView: UICollectionReusableView {
    
    private lazy var titleLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "Confirmed Cases"
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    private lazy var lastUpdatedLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Last Updated on 31/03/2020, 8:00 AM"
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        backgroundColor = UIColor(hex: "F5F5F5")
        addSubview(titleLbl)
        addSubview(lastUpdatedLbl)
        
        titleLbl.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        lastUpdatedLbl.snp.makeConstraints { (make) in
            make.top.equalTo(titleLbl.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
    }
}
