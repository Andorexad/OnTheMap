//
//  AddLocViewController.swift
//  OnTheMap
//
//  Created by Andi Xu on 7/29/21.
//

import UIKit
import MapKit
import CoreLocation

class AddLocViewController: UIViewController , UITextFieldDelegate{

    
    
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var presentingController: UIViewController?
    var geocoder = CLGeocoder()
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var keyboardIsVisible = false
    var pinnedLocation: String!
    
    override func viewDidLoad() {
        locationTextField.text = "Example: New York City, New York"
        self.activityIndicator.isHidden = true
        self.activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func findOnMapButtonTapped(_ sender: Any) {
        if locationTextField.text!.isEmpty {
            showAlert(message: "No location entered.", title: "Please try again.")
        } else {
            handleActivityIndicator(true)
            geocoder.geocodeAddressString(locationTextField.text ?? "") { placemarks, error in
                self.handlePlacemarkResponse(placemarks: placemarks, error: error)
            }
        }
    }
    
    func handlePlacemarkResponse(placemarks: [CLPlacemark]?, error: Error?) {
            if error != nil {
                handleActivityIndicator(false)
                showAlert(message: "Location cannot be found.", title: "Please try again.")
                return
            } else {
                if let placemarks = placemarks, placemarks.count > 0 {
                    let location = (placemarks.first?.location)! as CLLocation
                    self.latitude = Float(location.coordinate.latitude)
                    self.longitude = Float(location.coordinate.longitude)
                    
                    
                    let vc = storyboard?.instantiateViewController(identifier: "AddWebsiteViewController") as! AddWebsiteViewController
                    vc.location = locationTextField.text ?? ""
                    vc.latitude = Float(location.coordinate.latitude)
                    vc.longitude = Float(location.coordinate.longitude)
                    
                    handleActivityIndicator(false)
                    self.present(vc, animated: true, completion: nil)
                    
                    
                } else {
                    handleActivityIndicator(false)
                    showAlert(message: "Location cannot be found.", title: "Please try again.")
                }
            }
        }
    
    func handleActivityIndicator(_ beginFinding: Bool) {
        if beginFinding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
