//
//  CountryPickerViewController.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 7.4.21.
//

import UIKit

class CountryPickerViewController: UIViewController {
    
    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationView()
        setupTableView()
        fetchCountries()
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
    }
    
    private func fetchCountries() {
        APIManager.shared.getAllCountries { [weak self] result in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell")
        let country = countries[indexPath.row]
        cell?.textLabel?.text = country.name
        return cell!
    }
    
    
}
