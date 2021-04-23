//
//  CountryPickerViewController.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 7.4.21.
//

import UIKit
import JGProgressHUD

protocol ReloadDataDelegate: AnyObject {
    func didSelectCountry(_ country: Country)
}

class CountryPickerViewController: UIViewController, DisplayHudProtocol, Alertable, UISearchControllerDelegate {
    
    //MARK: - UI elements
    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmenControl: UISegmentedControl!
    @IBOutlet weak var searchHolderView: UIView!
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    //This is the same as APIManager Class
    private let api = WebServices()
    
    //MARK: - Variable delegate
    weak var delegate: ReloadDataDelegate?
    
    //MARK: - Variables
    private var countries = [Country]()
    var hud: JGProgressHUD?
    var userDidTapSearch = false
    
    //MARK: - Country data source variable
    var countriesDataSource: [Country] {
        if segmenControl.selectedSegmentIndex == 0 {
            guard let searchText = searchController.searchBar.text else {
                return  countries
            }
            return countries.filter {$0.name.lowercased().hasPrefix(searchText.lowercased())}
        } else {
            guard let searchText = searchController.searchBar.text else {
                return  countries.filter{$0.isSelected}
            }
            return countries.filter {$0.isSelected && $0.name.lowercased().hasPrefix(searchText.lowercased())}
        }
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationView()
        setupTableView()
        fetchCountries()
        configureSegmentControl()
        setupSearchController()
    }
    
    //MARK: - Segment control action
    @IBAction func onSegmentChanged(_ segmentControl: UISegmentedControl) {
        tableView.reloadData()
    }
}

//MARK: - UI Configuration
private extension CountryPickerViewController {
    func addNavigationView() {
        let navigationView = NavigationView(state: .backAndTitle, delegate: self, title: "Add Country")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureSegmentControl() {
        segmenControl.setBackgroundImage(nil, for: .normal, barMetrics: .compact)
        segmenControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmenControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.separatorColor = UIColor(hex: "EDEDED")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.keyboardDismissMode = .onDrag
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.reuseIdentifier)
    }
    
    func setupSearchController() {
        searchHolderView.layer.cornerRadius = 25
        searchHolderView.layer.masksToBounds = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Countries"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.definesPresentationContext = true
        searchController.extendedLayoutIncludesOpaqueBars = true
        searchHolderView.addSubview(searchController.searchBar)
        searchController.delegate = self
        searchHolderView.clipsToBounds = true    }
}

//MARK: - Networking
extension CountryPickerViewController {
    private func fetchCountries() {
        displayHud(true)
        api.request(CountriesAPI.getAllCountries) { (_ result: Result<[Country], Error>) in
            DispatchQueue.main.async {
                self.displayHud(false)
                switch result {
                case .failure(let error):
                    self.showErrorAlert(error)
                case .success(let countries):
                    self.countries = countries.sorted(by: {$0.name < $1.name})
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - Extension Navigation View delegate
extension CountryPickerViewController: NavigationViewDelegate {
    func didTapBack() {
        searchController.isActive = false
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Extension Data Source
extension CountryPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countriesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.reuseIdentifier) as! CountryTableViewCell
        if indexPath.row >= countriesDataSource.count {
            return cell
        }
        let country = countriesDataSource[indexPath.row]
        cell.setupCellData(country: country)
        cell.delegate = self
        return cell
    }
}

//MARK: - Extension Country Selection Protocol
extension CountryPickerViewController: CountrySelectionDelegate {
    func didChangeValueOn(country: Country) {
        delegate?.didSelectCountry(country)
        guard let index = countriesDataSource.firstIndex(where: {$0.isoCode == country.isoCode}) else {
            return
        }
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
    }
}

//MARK: - Extension SearchController result update
extension CountryPickerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
}
