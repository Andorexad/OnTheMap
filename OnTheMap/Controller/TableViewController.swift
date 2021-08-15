//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Andi Xu on 7/27/21.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        Client.getStudentLocation(limit: 100, order: "-updatedAt", completion: handleStudentLocationsResponse(locations:error:))
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        logout()
    }
    
    
    
    @IBAction func addLocation(_ sender: Any) {
        self.presentAddLocVC()
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationCollection.studentLocationCollection.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        let student = StudentLocationCollection.studentLocationCollection[indexPath.row]
        cell.textLabel?.text = "\(student.firstName!)" + " " + "\(student.lastName!)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentLocationCollection.studentLocationCollection[indexPath.row]
        openLink(student.mediaURL ?? "")
    }

    
    
    func handleStudentLocationsResponse(locations: [StudentLocation], error: Error?) {
        if error == nil {
            StudentLocationCollection.studentLocationCollection = locations
            self.tableView.reloadData()
        } else {
            showAlert(message: error?.localizedDescription ?? "", title: "Cannot find location")
        }
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            showAlert(message: error?.localizedDescription ?? "", title: "Logout Failed")
        }
    }
    
    private func refresh() {
        Client.getStudentLocation(limit: 100, order: "-updatedAt", completion: handleStudentLocationsResponse(locations:error:))
    }
    
    
}
