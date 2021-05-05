//
//  MapViewController.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 3.5.21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var confirmedCasesLbl: UILabel!
    
    var country: ConfirmedCasesByDay?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationView()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        confirmedCasesLbl.text = "\(country!.cases.getFormattedNumber())"
    }
}

//MARK: - Extension Navigation View delegate
extension MapViewController: NavigationViewDelegate {
    func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func addNavigationView() {
        let navigationView = NavigationView(state: .backAndTitle, delegate: self, title: "Country name")
        navigationHolderView.addSubview(navigationView)
    }
}

//MARK: - Fetch country's location
extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latitude = country?.lat, let longitude = country?.lon else {return}
        let coordinations = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
        let span = MKCoordinateSpan(latitudeDelta: 3.5,longitudeDelta: 3.5)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        mapView.setRegion(region, animated: false)
    }
}

