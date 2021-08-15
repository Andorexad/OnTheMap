//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Andi Xu on 7/27/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
   
    
    // ----- MARK: completion handler-------
    
    func handleStudentLocationsResponse(locations: [StudentLocation], error: Error?) {
        if error == nil {
            if self.mapView.annotations.count > 0 {
                self.mapView.removeAnnotations(self.mapView.annotations)
            }
            StudentLocationCollection.studentLocationCollection = locations
            addAnnotations(locations: locations)
        } else {
            showAlert(message: error?.localizedDescription ?? "", title: "Cannot get students' location.")
        }
    }
    
 
    
    
    // ----- MARK: helper methods-----
    private func refresh() {
        Client.getStudentLocation(limit: 100, order: "-updatedAt", completion: handleStudentLocationsResponse(locations:error:))
    }
    
    private func addAnnotations(locations: [StudentLocation]) {
            var annotations = [MKPointAnnotation]()
        
            for location in StudentLocationCollection.studentLocationCollection {
                let latitude = CLLocationDegrees(location.latitude!)
                let longitude = CLLocationDegrees(location.longitude!)
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                let firstName = location.firstName
                let lastName = location.lastName
                let mediaURL = location.mediaURL
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(firstName ?? "") \(lastName ?? "")"
                annotation.subtitle = mediaURL
                
                annotations.append(annotation)
            }
        self.mapView.addAnnotations(annotations)
    }
    
    
    
    
    
    // ----- MARK: functions for buttons-----
    
    @IBAction func logOut(_ sender: Any) {
        logout()
    }
    
  /*  @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        self.refresh()
    }*/

    @IBAction func addLocation(_ sender: Any) {
        if Client.Endpoints.Auth.objectID != ""{
            
            let alertVC =  UIAlertController (title:  "You have entered your location.", message:  "Do you want to overwrite your location？", preferredStyle: .alert )
            let cancelAction =  UIAlertAction (title:  "Cancel" , style: .cancel , handler: nil )
            let okAction =  UIAlertAction (title:  "Yes" , style: .default) { (pressOk) in
                self.presentAddLocVC()
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            present(alertVC, animated: true)
        }
        self.presentAddLocVC()
    }
    
    
        
        
    // ----- MARK: view setup-----
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
                
        Client.getStudentLocation(limit: 100, order: "-updatedAt", completion: handleStudentLocationsResponse(locations:error:))
                
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // opens the system browser to the URL specified in the annotationViews subtitle property
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            openLink((view.annotation?.subtitle!)!)
        }
    }

  
}
