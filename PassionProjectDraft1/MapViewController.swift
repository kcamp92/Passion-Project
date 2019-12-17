//
//  MapViewController.swift
//  PassionProjectDraft1
//
//  Created by Krystal Campbell on 11/18/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    // let mapView = MKMapView(frame: UIScreen.main.bounds)
    let initialLocation = CLLocationCoordinate2D(latitude: 40.742054, longitude: -73.769417)
    let searchRadius: CLLocationDistance = 2000
    
    
    lazy var locationSearchBar: UISearchBar = {
        let sb =  UISearchBar()
        sb.placeholder = "Search Venue"
        sb.searchBarStyle = UISearchBar.Style.prominent
        sb.backgroundColor = .systemTeal
        sb.isTranslucent = false
        sb.sizeToFit()
        sb.delegate = self
        sb.tag = 0
        return sb
    }()
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        return mv
    }()
    
    private var signs = [Feature]() {
        didSet {
            replacesMapAnnotationswithSearch()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setUpConstraints()
        locationManager.delegate = self
        mapView.delegate = self
        mapLoadFunc()
        mapView.userTrackingMode = .follow
        requestLocationAndAuthorizeIfNeeded()
      
    }
    
    func loadData() {
        
        guard let pathToData = Bundle.main.path(forResource: "austell2", ofType: "json")
            else {
                fatalError("austell.json file not found")
        }
        let internalUrl = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: internalUrl)
            let signsFromJSON = try
                signs = Welcome.getStreetSigns()
        } catch {
            print(error)
        }
    }
  
    
    private func addSubviews() {
          view.addSubview(locationSearchBar)
          view.addSubview(mapView)
    }
    
    private func requestLocationAndAuthorizeIfNeeded() {
          switch CLLocationManager.authorizationStatus() {
          case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            zoomIntoUserLocation()
          case .denied:
            zoomIntoInitialLocation()
          default:
              locationManager.requestWhenInUseAuthorization()
            
          }
      }

    private func mapLoadFunc(){
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func replacesMapAnnotationswithSearch(){
        let mapAnnotations = mapView.annotations
        mapView.removeAnnotations(mapAnnotations)
        for i in signs {
            let newMapAnnotation = MKPointAnnotation()
            newMapAnnotation.coordinate = CLLocationCoordinate2D(latitude: i.geometry.coordinates[1] /*?? 40.742054*/, longitude: i.geometry.coordinates[0] /*?? -73.769417*/)
            newMapAnnotation.title = i.properties.signDescription
            mapView.addAnnotation(newMapAnnotation)
            newMapAnnotation.subtitle = i.properties.signSubtype
        }
        mapView.reloadInputViews()
    }
    
    private func setUpConstraints(){
           
        locationSearchBar.translatesAutoresizingMaskIntoConstraints = false
        locationSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        locationSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        locationSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        locationSearchBar.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.075).isActive = true
           
    
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: locationSearchBar.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("New location: \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            //Call a function to get the current location
            
        default:
            break
        }
    }
    private func zoomIntoUserLocation() {
           if let userLocation = locationManager.location?.coordinate {
               let coordinateRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: searchRadius, longitudinalMeters: searchRadius)
               mapView.setRegion(coordinateRegion, animated: true)
           }
       }
       
       private func zoomIntoInitialLocation() {
           let initialRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: searchRadius, longitudinalMeters: searchRadius)
           mapView.setRegion(initialRegion, animated: true)
       }
       
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}

extension MapViewController: MKMapViewDelegate {
    
}

extension MapViewController: UISearchBarDelegate {
  
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        locationSearchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        locationSearchBar.showsCancelButton = false
        locationSearchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            
            if response == nil {
                print(error)
            } else {
                //remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                //get data
                let latitud = response?.boundingRegion.center.latitude
                let longitud = response?.boundingRegion.center.longitude
                
                let newAnnotation = MKPointAnnotation()
               // newAnnotation.title = searchBar.text
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitud!, longitude: longitud!)
                self.mapView.addAnnotation(newAnnotation)
                
                //to zoom in the annotation
                let coordinateRegion = MKCoordinateRegion.init(center: newAnnotation.coordinate, latitudinalMeters: self.searchRadius * 2.0, longitudinalMeters: self.searchRadius * 2.0)
                self.mapView.setRegion(coordinateRegion, animated: true)
                self.loadData()
               
            }
        }
        
    }
}
