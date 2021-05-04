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
    @IBOutlet weak var mapIMage: UIImageView!
    
    var country: ConfirmedCasesByDay?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationView()
        mapView.isHidden = true
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
        let countryLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        guard let longitude = country?.lon, let latitude = country?.lat else {return}
        let coordinations = CLLocationCoordinate2D(latitude: Double(longitude)!,longitude: Double(latitude)!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        mapView.setRegion(region, animated: true)
        mapView.mapType = .standard
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(countryLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
//                label.location = "\(placemark.name!), \(placemark.administrativeArea!), \(placemark.country!)"
//                label.latitude = "\(coordinations.latitude)"
//                label.longtitude = "\(coordinations.longitude)"
            }
        }
        let options = MKMapSnapshotter.Options()
        options.region = mapView.region
        options.size = mapView.frame.size
        options.scale = UIScreen.main.scale
        let rect = mapIMage.bounds

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot else {
                print("Snapshot error: \(error!.localizedDescription)")
                return
            }
            let image = UIGraphicsImageRenderer(size: options.size).image { _ in
                snapshot.image.draw(at: .zero)
                let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                let pinImage = pinView.image
                var point = snapshot.point(for: countryLocation.coordinate)
                if rect.contains(point) {
                    point.x -= pinView.bounds.width / 2
                    point.y -= pinView.bounds.height / 10
                    point.x += pinView.centerOffset.x
                    point.y += pinView.centerOffset.y
                    pinImage?.draw(at: point)
                }
            }
            self.mapIMage.image = image
        }
    }
}

