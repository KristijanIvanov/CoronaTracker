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
    var totalConfirmed = 1000
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
    @IBOutlet weak var globalStatisticHolderView: UIView!
    @IBOutlet weak var lblGlobally: UILabel!
    @IBOutlet weak var lblTotalConfirmed: UILabel!
    @IBOutlet weak var lblTotalDeaths: UILabel!
    @IBOutlet weak var lblTotalRecovered: UILabel!
    @IBOutlet weak var lblTotalConfirmedNumber: UILabel!
    @IBOutlet weak var lblTotalDeathsNumber: UILabel!
    @IBOutlet weak var lblTotalRecoveredNumber: UILabel!
    @IBOutlet weak var lblCVHeaderLastUpdatedOn: UILabel!
    
    //MARK: - Variables
    var collectionData: [CollectionData] = [.global(GlobalData()), .countries([])]
    var country = [Contry]()
    var global = GlobalData()
    //TEST variables
    var macedonia = Contry(name: "Macedonia", totalConfirmed: 10000)
    var spain = Contry(name: "Spain", totalConfirmed: 23000)
    
    func appendCountries() {
        self.country.append(macedonia)
        self.country.append(spain)
    }
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appendCountries()
        addNavigationView()
        setupCell()
        setupGlobalStatistic()
    }
    
    func setupGlobalStatistic() {
        guard let confirmed = global.totalConfirmed, let deaths = global.totalDeaths, let recovered = global.totalRecovered else {return}
        lblTotalConfirmedNumber.text = "\(confirmed.withCommas())"
        lblTotalDeathsNumber.text = "\(deaths.withCommas())"
        lblTotalRecoveredNumber.text = "\(recovered.withCommas())"


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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func setupCell() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CountryConfirmedCasesCollectionViewCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CountryConfirmedCasesCollectionViewCellCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        return headerView
    }
    

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        country.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding:CGFloat = 80
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize / 2 , height: collectionViewSize / 3)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryConfirmedCasesCollectionViewCellCollectionViewCell", for: indexPath) as! CountryConfirmedCasesCollectionViewCellCollectionViewCell
        let displayedCell = country[indexPath.row]
        cell.lblCountry.text = displayedCell.name
        cell.lblCountryConfirmedNumber.text = "\(displayedCell.totalConfirmed)"
        return cell
    }
    
    
    
    
}
