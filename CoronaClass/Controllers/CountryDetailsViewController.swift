//
//  CountryDetailsViewController.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 25.4.21.
//

import UIKit
import Kingfisher

class CountryDetailsViewController: UIViewController {
    
    enum EdgeContentInset {
        static let top: CGFloat = -25
        static let bottom: CGFloat = 50
        static let left: CGFloat = 16
        static let right: CGFloat = 16
        static let contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: - Variables
    var country: Country?
    var countryConfirmed: ConfirmedCasesByDay? 
    private var countryRecovered: ConfirmedCasesByDay?
    private var countryDeaths: ConfirmedCasesByDay?
    private var dispatchGroup = DispatchGroup()
    private var api = WebServices()
    
    //MARK: - ViewLife cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
}

//MARK: - UI Configuration
private extension CountryDetailsViewController {
    func setupUI() {
        registerCell()
        addNavigationView()
    }
    
    func addNavigationView() {
        let navigationView = NavigationView(state: .backAndTitle, delegate: self, title: "\(countryConfirmed!.countryName)")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func registerCell() {
        collectionView.register(UINib(nibName: "CountryDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CountryDetailsCollectionViewCell")
        collectionView.register(UINib(nibName: "MapViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MapViewCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = false
    }
}

//MARK: - UICollectionView delegate
extension CountryDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: (collectionView.frame.width) - (2 * EdgeContentInset.left), height: 520)
        case 1:
            return CGSize(width: (collectionView.frame.width) - (2 * EdgeContentInset.left), height: 65)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return EdgeContentInset.contentInset
    }
}

//MARK: - UICollectionView datasource
extension CountryDetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 2 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            return createCountryDetailsCell(at: indexPath)
        case 1:
            return createMapViewCell(at: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    private func createCountryDetailsCell(at indexPath: IndexPath) -> CountryDetailsCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryDetailsCollectionViewCell", for: indexPath) as! CountryDetailsCollectionViewCell
        
        if let confirmed = countryConfirmed, let recovered = countryRecovered, let deaths = countryDeaths {
            cell.configureCell(confirmed: confirmed, recovered: recovered, deaths: deaths)
        }
        return cell
    }
    
    private func createMapViewCell(at indexPath: IndexPath) -> MapViewCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapViewCollectionViewCell", for: indexPath) as! MapViewCollectionViewCell
        cell.delegate = self
        guard let countryConfirmed = countryConfirmed else { return cell }
        cell.flagImage.kf.setImage(with: URL(string: "http://www.geonames.org/flags/x/\(countryConfirmed.countryCode.lowercased()).gif"))
        return cell
    }
}

//MARK: - NavigationViewDelegate
extension CountryDetailsViewController: NavigationViewDelegate {
    func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - MapViewCollectionCellDelegate
extension CountryDetailsViewController: MapViewCollectionCellDelegate {
    func didPressMapButton() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(identifier: "MapViewController") as! MapViewController
        controller.country = countryConfirmed
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - Fetching data
extension CountryDetailsViewController {
    private func fetchData() {
        fetchDataForSelectedCountryWith(status: .recovered)
        fetchDataForSelectedCountryWith(status: .deaths)
        
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
    
    private func fetchDataForSelectedCountryWith(status: Status) {
        guard let country = country else { return }
        dispatchGroup.enter()
        api.request(CountryAPI.getCases(country: country, startDate: Date(), endDate: Date(), status: status)) {[weak self] (_ result: Result<[ConfirmedCasesByDay], Error>) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let casesByDay):
                guard casesByDay.count > 0 else { return }
                let lastCase = casesByDay[casesByDay.count - 1]
                switch status {
                case .recovered:
                    self.countryRecovered = lastCase
                case .deaths:
                    self.countryDeaths = lastCase
                default:
                    break
                }
                self.dispatchGroup.leave()
            }
        }
    }
}
