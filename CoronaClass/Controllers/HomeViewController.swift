//
//  HomeViewController.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 7.4.21.
//

import UIKit
import SnapKit

struct GlobalData {
    var totalRecovered: Double? = 1000
    var totalDeaths: Double? = 300
    
    var totalConfirmed: Double? {
        guard let totalRecovered = totalRecovered, let totalDeaths = totalDeaths else {
            return nil
        }
        return totalRecovered + totalDeaths
    }
}

struct Contry {
    var name = "Macedonia"
}

enum CollectionData: Equatable {
    case global(GlobalData)
    case countries([Contry])
    
    static func == (lhs: CollectionData, rhs: CollectionData) -> Bool {
        switch  (lhs, rhs) {
        case (.global, .global):
            return true
        case (.countries(_), .countries(_)):
            return true
        default:
            return false
        }
    }
}

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var addCountry: UIButton!
    
    //MARK: - Variables
    var collectionData: [CollectionData] = [.global(GlobalData()), .countries([])]
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationView()
    }
    
    //MARK: - IBActions
    @IBAction func btnAddCountry(_ sender: UIButton) {
        performSegue(withIdentifier: "countriesSegue", sender: nil)
    }
    
}

//MARK: - UI config
extension HomeViewController {
    private func addNavigationView() {
        let navigationView = NavigationView(state: .onlyTitle, delegate: nil, title: "Dashboard")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

