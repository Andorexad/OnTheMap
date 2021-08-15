//
//  ExtensionForVC.swift
//  OnTheMap
//
//  Created by Andi Xu on 7/29/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    func openLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showAlert(message: "Cannot open the link", title: "Please try again")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
    
    func presentAddLocVC(){
        
        let vc=storyboard?.instantiateViewController(identifier:  "AddLocViewController") as! AddLocViewController
        //self.navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true, completion: nil)
    }
    
    func logout(){
        Client.deleteSession { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
               // self.navigationController?.popViewController(animated: true)
               // let vc=self.storyboard?.instantiateViewController(identifier:  "LoginViewController") as! LoginViewController
             //   self.present(vc, animated: true, completion: nil)
                //self.navigationController?.popToRootViewController(animated: true)
                /*  let identifier = "backToLogin"
                self.performSegue(withIdentifier: identifier, sender: nil)
                let vc=self.storyboard?.instantiateViewController(identifier:  "LoginViewController") as! LoginViewController
                self.present(vc, animated: true, completion: nil)*/
            } else {
                self.showAlert(message: error?.localizedDescription ?? "", title: "Logout Failed")
            }
        }
        //Client.deleteSession(completion: handleLogoutResponse(success:error:))
    }
    

}

extension UITextFieldDelegate {
    func setupTextField(_ textField: UITextField, text: String) {
        textField.delegate = self
        textField.text=text
    }
}
