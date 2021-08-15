//
//  AddWebsiteViewController.swift
//  OnTheMap
//
//  Created by Andi Xu on 7/29/21.
//

import UIKit
import MapKit
import CoreLocation

// show the location
// submit : when clicked, 1) store the data; 2) update the map & tableview
// cancel: exit the adding page
// enter the url link & save

class AddWebsiteViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var urlTextField: UITextField!
    
    var location: String = ""
   // var urlString: String = ""
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    
    var urlErrorMsg: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.text="\n\n\nEnter the link you want to share.\n\n\n"
        showLocation();
    }
    
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        
        if !isMediaURLFormat() {
            showAlert(message: urlErrorMsg , title: "Please re-enter your url")
        }else{
            let ispost = Client.Endpoints.Auth.objectID == ""
            Client.postOrPutLocation(post: ispost, objectId: Client.Endpoints.Auth.objectID, firstName: Client.Endpoints.Auth.firstName, lastName: Client.Endpoints.Auth.lastName, mapString: location, mediaURL: urlTextField.text!, latitude: latitude, longitude: longitude, completion: handlePostStudentResponse(success:error:))
        }
    }
    
    
    
    
    func showLocation() {
        
        let lat = CLLocationDegrees(self.latitude)
        let long = CLLocationDegrees(self.latitude)
            
        // create a CLLocationCoordinates2D instance
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
            
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(annotation.coordinate, animated: true)
        let region = MKCoordinateRegion(center: annotation.coordinate, span:MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        
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
    
    
        
    func handlePostStudentResponse(success: Bool, error: Error?) {
        if success {
            //self.navigationController?.popToRootViewController(animated: true)
            
            let vc=(storyboard?.instantiateViewController(withIdentifier: "tabBarController")) as! UITabBarController
            //vc.
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            //vc.dismiss(animated: true , completion: nil)
        } else {
            showAlert(message: error?.localizedDescription ?? "", title: "Cannot save your post.")
        }
    }
    
    // MARK: textfield property
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text=""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: helper method
    private func isMediaURLFormat() -> Bool {
        if let typedURL = urlTextField.text, !typedURL.isEmpty {
            if typedURL.starts(with: "https://") {
                
                if verifyUrl(urlString: typedURL) {
                    return true
                } else {
                    urlErrorMsg = "URL provided does not work."
                    return false
                }
            } else {
                urlErrorMsg = "URL must begin with 'https://'"
                return false
            }
        } else {
            urlErrorMsg = "Please Add a Link."
            return false
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    

}
