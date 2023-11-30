//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Андрей on 28.11.2023.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAddress(_ address: String?)
}

class MapViewController: UIViewController {
    
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var place = Place()
    
    var isImageSet = false
    var incomeSegueIdentifier = ""
    var previousLocation: CLLocation? {
        didSet {
            mapManager.startTrackingUserLocation(for: mapView, and: previousLocation) { currentLocation in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.mapManager.showUserLocation(mapView: self.mapView, incomeSegueIdentifier: self.incomeSegueIdentifier, showAlert: self.showAlert)
                }
            }
        }
    }
    let annotationIdentifier = "annotationIdentifier"
    let mapManager = MapManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text = ""
        mapView.delegate = self
        setupMapView()
    }
    
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    @IBAction func centerViewInUserLocation() {
        
        mapManager.showUserLocation(mapView: mapView, incomeSegueIdentifier: incomeSegueIdentifier, showAlert: showAlert)
    }
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true)
    }
    @IBAction func goButtonPressed() {
        mapManager.getDirections(mapView: mapView, showAlert: showAlert) { location in
            self.previousLocation = location
        }
    }
    
    
    private func setupMapView() {
        
        mapManager.checkLocationServices(mapView: mapView,
                                         segueIdentifier: incomeSegueIdentifier,
                                         showAlert: showAlert,
                                         closure: {
                                            mapManager.locationManager.delegate = self})
        
        goButton.isHidden = true
        
        if incomeSegueIdentifier == "showPlace" {
            mapManager.setupPlacemark(place: place, mapView: mapView)
            mapPinImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
    
    private func setupLocationManager() {
        mapManager.locationManager.delegate = self
        mapManager.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Упс!🤬",
                                                message: "Мы не сможем проложить маршрут до места пока вы не разрешите MyPlaces доступ к вашей геолокации в настройках!🦧",
                                                preferredStyle: .alert)
        
        
        
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { _ in
            Task {
                await self.openSettings()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(settingsAction)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func openSettings() async {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            await UIApplication.shared.open(url)
        }
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        guard isImageSet else { return annotationView }
        
        if let imageData = place.imageData{
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if incomeSegueIdentifier == "showPlace" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManager.showUserLocation(mapView: mapView, incomeSegueIdentifier: self.incomeSegueIdentifier, showAlert: self.showAlert)
            }
        }
        
        geocoder.cancelGeocode()
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare
            let buildingNumber = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                if streetName != nil && buildingNumber != nil {
                    self.addressLabel.text = "\(streetName!), \(buildingNumber!)"
                } else if streetName != nil {
                    self.addressLabel.text = "\(streetName!)"
                } else {
                    self.addressLabel.text = ""
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        mapManager.checkLocationAuthorization(incomeSegueIdentifier: incomeSegueIdentifier, mapView: mapView, showAlert: showAlert)
    }
}
