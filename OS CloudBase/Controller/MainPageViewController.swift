//
//  MainPageViewController.swift
//  OS CloudBase
//
//  Created by mohammed al-batati on 1/9/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit
import Firebase

class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndiecator: UIActivityIndicatorView!
    
    var equipmentList = [Equipments]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredEquipmentList = [Equipments]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting the search controller
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        // Setting the activity contorller
        activityIndiecator.isHidden = false
        activityIndiecator.startAnimating()
        // Calling the data from Fire Base
        let ref = Database.database().reference()
            ref.child("equipment").observe(.value) { (snapshot) in
                guard let equipmentSnapshot = EquipmentSnapshot(with: snapshot) else {return print("no non")}
                self.equipmentList = equipmentSnapshot.equipments
                // sorting the equipment list
                self.equipmentList.sort(by: { $0.type.compare($1.type) == .orderedAscending })
                // adding the filtered list
                self.filteredEquipmentList = self.equipmentList
                self.tableView.reloadData()
                // Stopping the activity controllre
                self.activityIndiecator.isHidden = true
                self.activityIndiecator.stopAnimating()
                self.navigationItem.title = "Equipment : \(self.filteredEquipmentList.count)"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Equipment : \(filteredEquipmentList.count)"
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController.dismiss(animated: true, completion: nil)
    }
    

    // MARK:- Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return equipmentList.count
        return filteredEquipmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainPageTableViewCell{
            // with Filtering using the search bar
            cell.assetCodeLabel.text = filteredEquipmentList[indexPath.row].assetcode
            cell.snLabel.text = filteredEquipmentList[indexPath.row].serialnumber
            cell.typeLabel.text = filteredEquipmentList[indexPath.row].type
            // without the fitlering
//            cell.assetCodeLabel.text = equipmentList[indexPath.row].assetcode
//            cell.snLabel.text = equipmentList[indexPath.row].serialnumber
//            cell.typeLabel.text = equipmentList[indexPath.row].type
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let ref = Database.database().reference().child("equipment")
            // this code below before using the search bar
//            ref.child(equipmentList[indexPath.row].assetcode).removeValue()
            ref.child(filteredEquipmentList[indexPath.row].assetcode).removeValue()
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    


    // MARK:- Buttons
    
    @IBAction func logoutPressed(_ sender: Any) {
   
        do {
            try Auth.auth().signOut()
        } catch  {
            print("Couldn't sign out")
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Functions
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text , !searchText.isEmpty {
            let lowerCase = searchText.lowercased()
            filteredEquipmentList = equipmentList.filter({ (newEquipment) -> Bool in
                navigationItem.title = "Equipment: \(filteredEquipmentList.count)"
                return (newEquipment.type.lowercased().contains(lowerCase))
            })
        } else {
            filteredEquipmentList = equipmentList
            navigationItem.title = "Equipment: \(filteredEquipmentList.count)"
        }
        tableView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsSegue" {
            let selectedIndex = tableView.indexPathForSelectedRow
            if let vc = segue.destination as? EquipmentDetailsViewController {
                if let myIndex = selectedIndex{
                    let value = filteredEquipmentList[myIndex.row]
                    vc.aquireCost = value.aquirecost
                    vc.assetCode = value.assetcode
                    vc.bl = value.bl
                    vc.bu = value.bu
                    vc.Details = value.notes
                    vc.location = value.location
                    vc.nbv = value.nbv
                    vc.po = value.po
                    vc.serialNo = value.serialnumber
                    vc.type = value.type
                }
                
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    
    

}

















