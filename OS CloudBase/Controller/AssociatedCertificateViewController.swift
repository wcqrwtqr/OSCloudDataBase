//
//  AssociatedCertificateViewController.swift
//  OS CloudBase
//
//  Created by mohammed al-batati on 1/11/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit
import Firebase

class AssociatedCertificateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var assetCode : String?
    var certifcate = [Certificate]()
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Views
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child("certificates").child(assetCode!)
        ref.observe(.value) { (snapshot) in
            if let certificateSnapshot = CertificateSnapshot(with: snapshot){
                self.certifcate = certificateSnapshot.certificates
                self.certifcate.sort(by: { $0.Date.compare($1.Date) == .orderedDescending })
                self.tableView.reloadData()
            }
        }
    }

    // MARK- Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return certifcate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = certifcate[indexPath.row].type
        cell.detailTextLabel?.text = certifcate[indexPath.row].Date
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ref = Database.database().reference().child("certificates").child(assetCode!)
            ref.child(certifcate[indexPath.row].ID).removeValue()
            self.tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCertificateDetailsSegue" {
            let selectedIndex = tableView.indexPathForSelectedRow
            if let vc = segue.destination as? DetailAssociatedCertificateViewController{
                vc.assetCode = assetCode
                if let myIndex = selectedIndex{
                    let value = certifcate[myIndex.row]
                    vc.date = value.Date
                    vc.certificatetype = value.type
                    vc.equipmentSN = value.equipmentSN
                    vc.equipmentType = value.equipmentType
                    vc.expiry = value.expiry
                    vc.ID = value.ID
                }
            }
        }
    }
    

}
