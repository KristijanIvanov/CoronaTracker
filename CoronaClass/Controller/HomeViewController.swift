//
//  HomeViewController.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 7.4.21.
//

import UIKit
import SnapKit
import JGProgressHUD

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

struct MockCountry {
    var name = "Macedonia"
    var totalConfirmed = 1000
}

enum CollectionData: Equatable {
    case countries([MockCountry])
    
    static func == (lhs: CollectionData, rhs: CollectionData) -> Bool {
        switch  (lhs, rhs) {
        case (.countries(_), .countries(_)):
            return true
        }
    }
}

class HomeViewController: UIViewController, DisplayHudProtocol {

    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var addCountry: UIButton!
    @IBOutlet weak var globalStatisticHolderView: UIView!
    @IBOutlet weak var lblTotalConfirmedNumber: UILabel!
    @IBOutlet weak var lblTotalDeathsNumber: UILabel!
    @IBOutlet weak var lblTotalRecoveredNumber: UILabel!
    
    //MARK: - Variables
    var collectionData: [CollectionData] = [.countries([])]
    var global = GlobalData()
    var hud: JGProgressHUD?

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationView()
        configureCollectionView()
        appendCountries()
        fetchGlobalData()
        reloadInputViews()
    }
    
    //This is the check
    
    //MARK: - IBActions
    @IBAction func btnAddCountry(_ sender: UIButton) {
        performSegue(withIdentifier: "countriesSegue", sender: nil)
    }
}

//MARK: - Data manager/Network
extension HomeViewController {
    func appendCountries() {
        let macedonia = MockCountry(name: "Macedonia", totalConfirmed: 10000)
        let spain = MockCountry(name: "Spain", totalConfirmed: 23000)
        let italy = MockCountry(name: "Italy", totalConfirmed: 30000)
        let germany = MockCountry(name: "Spain", totalConfirmed: 40000)
        collectionData.removeAll()
        collectionData.append(.countries([macedonia, spain, italy, germany]))
    }
    
    func fetchGlobalData() {
        displayHud(true)
        APIManager.shared.getGlobalData { [weak self] (data, error) in
            self?.displayHud(false)
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data {
                guard let totalConfirmed = data.global.totalConfirmed, let totalDeaths = data.global.totalDeaths, let totalRecovered = data.global.totalRecovered  else {return}
                self?.lblTotalConfirmedNumber.text = "\(totalConfirmed.withCommas())"
                self?.lblTotalDeathsNumber.text = "\(totalDeaths.withCommas())"
                self?.lblTotalRecoveredNumber.text = "\(totalRecovered.withCommas())"
            }
        }
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
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CountryCell", bundle: nil), forCellWithReuseIdentifier: "CountryCell")
        collectionView.register(DashboardHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DashboardHeaderView.self))
        configureFlowLayout()
    }
    
    private func configureFlowLayout() {
        let numberOfItemsInRow: CGFloat = 2
        let minimumSpacing: CGFloat = 13
        let customContentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let edgeInsetPadding = customContentInset.left + customContentInset.right
        let width = (UIScreen.main.bounds.size.width - (numberOfItemsInRow - 1) * minimumSpacing - edgeInsetPadding) / numberOfItemsInRow

        layout.minimumLineSpacing = minimumSpacing
        layout.minimumInteritemSpacing = minimumSpacing
        layout.itemSize = CGSize(width: width, height: 72)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 60)
        layout.sectionHeadersPinToVisibleBounds = true
        collectionView.contentInset = customContentInset
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let dashboardHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DashboardHeaderView.self), for: indexPath) as! DashboardHeaderView
            return dashboardHeaderView
        default:
            return UICollectionReusableView()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collectionDataItem = collectionData[section]
        switch collectionDataItem {
        case .countries(let countries):
            return countries.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryCell", for: indexPath) as! CountryCell
        let collectionDataItem = collectionData[indexPath.section]
        
        switch collectionDataItem {
        case .countries(let countries):
            let country = countries[indexPath.row]
            cell.configureCell(with: country)
            return cell
        }
    }
}
