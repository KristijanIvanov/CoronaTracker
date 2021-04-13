//
//  CountryPickerViewController.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 7.4.21.
//

import UIKit
import JGProgressHUD

class CountryPickerViewController: UIViewController, DisplayHudProtocol {

    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentControl: CustomSegmentedControl!
    
    private var countries = [Country]()
    var hud: JGProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationView()
        setupTableView()
        fetchCountries()
        segmentControl.setButtonTitles(buttonTitles: ["Track countries", "Manage countries"])
        segmentControl.delegate = self
    }
    
    private func addNavigationView() {
        let navigationView = NavigationView(state: .backAndTitle, delegate: self, title: "Add Country")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.separatorColor = UIColor(hex: "EDEDED")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.reuseIdentifier)
    }
    
    private func fetchCountries() {
        displayHud(true)
        APIManager.shared.getAllCountries { [weak self] result in
            self?.displayHud(false)
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let countries):
                self?.countries = countries.sorted(by: {$0.name < $1.name})
                self?.tableView.reloadData()
            }
        }
    }
}

extension CountryPickerViewController: NavigationViewDelegate {
    func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension CountryPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.reuseIdentifier) as! CountryTableViewCell
        let country = countries[indexPath.row]
        cell.delegate = self
        cell.setupCellData(country: country)
        return cell
    }
}

extension CountryPickerViewController: CountrySelectionDelegate {
    func didChangeValue(country: Country) {
        guard let index = countries.firstIndex(where: {$0.isoCode == country.isoCode}) else {return}
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
    }
}

extension CountryPickerViewController: CustomSegmentedControlDelegate {
    func selectedIndex(_ index: Int) {
        debugPrint("kur")
    }
}
