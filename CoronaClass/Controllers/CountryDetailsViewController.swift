//
//  CountryDetailsViewController.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 25.4.21.
//

import UIKit
import Kingfisher

class CountryDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
<<<<<<< Updated upstream
    var countryConfirmed: ConfirmedCasesByDay?
    var countryRecovered: ConfirmedCasesByDay?
    var countryDeaths: ConfirmedCasesByDay?
=======
    var country: Country?
    var api = WebServices()
    
    var countryConfirmed: ConfirmedCasesByDay? 
    var countryRecovered: ConfirmedCasesByDay?
    {
        didSet {
            collectionView.reloadData()
        }
    }

    var countryDeaths: ConfirmedCasesByDay?
    {
        didSet {
            collectionView.reloadData()
        }
    }
>>>>>>> Stashed changes

    override func viewDidLoad() {
        super.viewDidLoad()
        if let country = countryConfirmed {
            title = country.countryName
        }
        registerCell()
        addNavigationView()
    }
}

//MARK: - UI Configuration
extension CountryDetailsViewController {
    func addNavigationView() {
        let navigationView = NavigationView(state: .backAndTitle, delegate: self, title: "\(countryConfirmed!.countryName)")
        navigationHolderView.addSubview(navigationView)
    }
    
    func registerCell() {
        collectionView.register(UINib(nibName: "CountryDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CountryDetailsCollectionViewCell")
        collectionView.register(UINib(nibName: "MapViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MapViewCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryDetailsCollectionViewCell", for: indexPath) as! CountryDetailsCollectionViewCell
<<<<<<< Updated upstream
            guard let countryConfirmed = countryConfirmed, let countryRecovered = countryRecovered, let countryDeaths = countryDeaths else {return cellA}
            cellA.lblConfirmeCases.text = "\(countryConfirmed.cases.getFormattedNumber())"
            cellA.lblRecoveredCase.text = "\(countryRecovered.cases.getFormattedNumber())"
            cellA.lblDeathsCases.text = "\(countryDeaths.cases.getFormattedNumber())"
=======
            
            if let confirmed = countryConfirmed, let recovered = countryRecovered, let deaths = countryDeaths {
            cellA.lblConfirmeCases.text = "\(confirmed.cases.getFormattedNumber())"
            cellA.lblRecoveredCase.text = "\(recovered.cases.getFormattedNumber())"
            cellA.lblDeathsCases.text = "\(deaths.cases.getFormattedNumber())"
            }
>>>>>>> Stashed changes
            return cellA
        } else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "MapViewCollectionViewCell", for: indexPath) as! MapViewCollectionViewCell
            cellB.delegate = self
            guard let countryConfirmed = countryConfirmed else {return cellB}
            cellB.flagImage.kf.setImage(with: URL(string: "http://www.geonames.org/flags/x/\(countryConfirmed.countryCode.lowercased()).gif"))
            return cellB
        }
    }
}

//MARK: - Extension Navigation View delegate
extension CountryDetailsViewController: NavigationViewDelegate {
    func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension CountryDetailsViewController: didClickOnMapDelegate {
    func showMap() {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(identifier: "MapViewController") as! MapViewController
            controller.country = countryConfirmed
            navigationController?.pushViewController(controller, animated: true)
    }
}
