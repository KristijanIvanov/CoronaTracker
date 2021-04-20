//
//  HomeViewController.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 7.4.21.
//

import UIKit
import SnapKit
import JGProgressHUD

class HomeViewController: UIViewController, DisplayHudProtocol, Alertable {
    //MARK: - UI navigation elements
    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var globalHolderView: UIView!
    @IBOutlet weak var confirmed: UILabel!
    @IBOutlet weak var deaths: UILabel!
    @IBOutlet weak var recovered: UILabel!
    @IBOutlet weak var buttonRetry: UIButton!
    @IBOutlet weak var lblConfirmedInfo: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addCountry: UIButton!
    
    //MARK: - Variables
    private var selectedCountries = [Country]()
    private(set) var allCountries = [Country]()
    private let api = WebServices()
    
    var hud: JGProgressHUD?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationView()
        setupGlobalHolder()
        getGlobalData()
        collectionView.delegate = self
        collectionView.dataSource = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 165, height: 70)
        }
        fetchCountries()
    }
    
    //MARK: - UI elements setup
    private func addNavigationView() {
        let navigationView = NavigationView(state: .onlyTitle, delegate: nil, title: "Dashboard")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupGlobalHolder() {
        globalHolderView.layer.cornerRadius = 8
        globalHolderView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        globalHolderView.layer.shadowOpacity = 1.0
        globalHolderView.layer.shadowRadius = 10
        globalHolderView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Fetch global data
    private func getGlobalData() {
        displayHud(true)
        api.request(GlobalAPI.getSummary) { [weak self] (_ result: Result<GlobalResponse, Error>) in
            self?.displayHud(false)
            switch result {
            case .failure(let error):
                self?.buttonRetry.isHidden = false
                self?.showErrorAlert(error)
            case .success(let globalResponse):
                self?.buttonRetry.isHidden = true
                self?.setGlobalData(global: globalResponse.global)
            }
        }
        
//        APIManager.shared.getGlobalInfo { [weak self] result in
//            guard let self = self else {return}
//            switch result {
//            case .failure(let error):
//                self.buttonRetry.isHidden = false
//                self.showErrorAlert(error)
//            case .success(let global):
//                self.buttonRetry.isHidden = true
//                self.setGlobalData(global: global)
//            }
//        }
    }
    
    //MARK: - Fetch countries data
    private func fetchCountries() {
        displayHud(true)
        APIManager.shared.getAllCountries { [weak self] result in
            self?.displayHud(false)
            switch result {
            case .failure(let error):
                self?.showErrorAlert(error)
            case .success(let countries):
                self?.allCountries = countries
                self?.reloadCountriesData()
            }
        }
    }
    
    //MARK: - Feeding UI elements with data
    private func setGlobalData(global: Global) {
        deaths.text = global.deaths.getFormattedNumber()
        recovered.text = (global.recovered).getFormattedNumber()
        confirmed.text = (global.confirmed).getFormattedNumber()
        setFormattedLastUpdate()
    }
    
    //MARK: - Date formater setup
    private func setFormattedLastUpdate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, h:mm a"
        let formattedDate = dateFormatter.string(from: date)
        let updated = "Last updated on " + formattedDate
        let text = "Confirmed cases\n" + updated
        
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor(hex: "3C3C3C")], range: (text as NSString).range(of: text))
        attributed.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .regular), .foregroundColor: UIColor(hex: "707070")], range: (text as NSString).range(of: updated))
        lblConfirmedInfo.attributedText = attributed
    }
    
    //MARK: - Buttons actions
    @IBAction func btnAddCountry(_ sender: UIButton) {
        performSegue(withIdentifier: "countriesSegue", sender: nil)
    }
    
    @IBAction func btnRetry(_ sender: UIButton) {
        getGlobalData()
    }
    
    //MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "countriesSegue" {
            let controller = segue.destination as! CountryPickerViewController
            controller.delegate = self
        }
    }
}

//MARK: - Extension Reload Data delegata
extension HomeViewController: ReloadDataDelegate {
    func reloadCountriesData() {
        selectedCountries = allCountries.filter {$0.isSelected}
        collectionView.reloadData()
    }
}

//MARK: - Extension Collection View data source
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryCell", for: indexPath) as! CountryCollectionViewCell
        let country = selectedCountries[indexPath.row]
        cell.setupCell()
        cell.setCountryData(country)
        return cell
    }
}

//MARK: - Extension Collection View FlowLayout delegata
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
