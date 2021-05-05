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
    
    var countryConfirmed: ConfirmedCasesByDay?
    var countryRecovered: ConfirmedCasesByDay?
    var countryDeaths: ConfirmedCasesByDay?

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
        collectionView.register(CountryMapCollectionViewCell.self, forCellWithReuseIdentifier: "CountryMapCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryDetailsCollectionViewCell", for: indexPath) as! CountryDetailsCollectionViewCell
            guard let countryConfirmed = countryConfirmed, let countryRecovered = countryRecovered, let countryDeaths = countryDeaths else {return cellA}
            cellA.lblConfirmeCases.text = "\(countryConfirmed.cases.getFormattedNumber())"
            cellA.lblRecoveredCase.text = "\(countryRecovered.cases.getFormattedNumber())"
            cellA.lblDeathsCases.text = "\(countryDeaths.cases.getFormattedNumber())"
            return cellA
        } else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryMapCollectionViewCell", for: indexPath) as! CountryMapCollectionViewCell
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

extension CountryDetailsViewController: didClickOnMap {
    func showMap() {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(identifier: "MapViewController") as! MapViewController
            controller.country = countryConfirmed
            navigationController?.pushViewController(controller, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "countryDetailsSegue" {
            let controller = segue.destination as! CountryDetailsViewController
        }
    }
}
