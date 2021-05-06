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
    fileprivate(set) var allCountries = [Country]()
    private var confirmedCasesCountries = [ConfirmedCasesByDay]()
    private let api = WebServices()
    
    var hud: JGProgressHUD?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        addNavigationView()
        setupGlobalHolder()
        getGlobalData()
        fetchCountries()
    }
    
    //MARK: - IB actions
    @IBAction func btnAddCountry(_ sender: UIButton) {
        performSegue(withIdentifier: "countriesSegue", sender: nil)
    }
    
    @IBAction func btnRetry(_ sender: UIButton) {
        getGlobalData()
    }
    
    func didTapButton(cell: CountryCollectionViewCell) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(identifier: "CountryDetailsViewController") as! CountryDetailsViewController
        controller.countryConfirmed = cell.countryDetailsConfirmed
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "countriesSegue" {
            let controller = segue.destination as! CountryPickerViewController
            controller.delegate = self
        }
    }
}

//MARK: - UI Configuration
private extension HomeViewController {
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 165, height: 70)
        }
    }
    
    func addNavigationView() {
        let navigationView = NavigationView(state: .onlyTitle, delegate: nil, title: "Dashboard")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupGlobalHolder() {
        globalHolderView.layer.cornerRadius = 8
        globalHolderView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        globalHolderView.layer.shadowOpacity = 1.0
        globalHolderView.layer.shadowRadius = 10
        globalHolderView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func setGlobalData(global: Global) {
        DispatchQueue.main.async { [self] in
            deaths.text = global.deaths.getFormattedNumber()
            recovered.text = (global.recovered).getFormattedNumber()
            confirmed.text = (global.confirmed).getFormattedNumber()
        }
        setFormattedLastUpdate()
    }
    
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
        DispatchQueue.main.async {
            self.lblConfirmedInfo.attributedText = attributed
        }
    }
}

//MARK: - Networking
private extension HomeViewController {
    func getGlobalData() {
        displayHud(true)
        api.request(GlobalAPI.getSummary) { [weak self] (_ result: Result<GlobalResponse, Error>) in
            DispatchQueue.main.async {
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
        }
    }
    
    func fetchCountries() {
        displayHud(true)
        api.request(CountriesAPI.getAllCountries) { (_ result: Result<[Country], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.showErrorAlert(error)
                    print(error.localizedDescription)
                case.success(let countries):
                    self.allCountries = countries
                    self.getConfirmedCasesForSelectedCountries()
                }
            }
        }
    }
    
    func getConfirmedCases(_ country: Country) {
        api.request(CountryAPI.getCases(country: country, startDate: Date().minus(days: 1), endDate: Date(), status: .confirmed)) { (_ result: Result<[ConfirmedCasesByDay], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let casesByDay):
                    guard casesByDay.count > 0 else { return }
                    let lastCase = casesByDay[casesByDay.count - 1]
                    self.confirmedCasesCountries.append(lastCase)
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

//MARK: - Extension Collection View data source
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryCell", for: indexPath) as! CountryCollectionViewCell
        cell.delegate = self
        cell.setupCell()
        let country = selectedCountries[indexPath.row]
        
        if let index = confirmedCasesCountries.firstIndex(where: { $0.countryCode == country.isoCode}) {
            let confirmedCase = confirmedCasesCountries[index]
            cell.configureCell(countryConfirmedCase: confirmedCase)
        } else {
            cell.configureCell(country: country)
        }
        return cell
    }
}

//MARK: - Extension Collection View FlowLayout delegate
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CountryCollectionViewCell
        if cell.retryBtn.isHidden {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let countryDetailsVC = storyBoard.instantiateViewController(identifier: "CountryDetailsViewController") as! CountryDetailsViewController
            countryDetailsVC.country = cell.country
            countryDetailsVC.countryConfirmed = cell.countryDetailsConfirmed
            navigationController?.pushViewController(countryDetailsVC, animated: true)
        }
    }
}

//MARK: - Extension Reload Data delegate
extension HomeViewController: ReloadDataDelegate {
    func getConfirmedCasesForSelectedCountries() {
        selectedCountries = allCountries.filter {$0.isSelected}
        collectionView.reloadData()
        selectedCountries.forEach { country in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.getConfirmedCases(country)
            }
        }
    }
    
    func didSelectCountry(_ country: Country) {
        selectedCountries = allCountries.filter {$0.isSelected}
        if !country.isSelected {
            confirmedCasesCountries.removeAll(where: {$0.countryCode == country.isoCode})
            collectionView.reloadData()
        } else {
            getConfirmedCases(country)
        }
    }
}

extension HomeViewController: CountryCellDelegate {
    func didAddLastCase(_ lastCase: ConfirmedCasesByDay, for country: Country) {
        confirmedCasesCountries.append(lastCase)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

