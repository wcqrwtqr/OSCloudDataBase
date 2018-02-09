//
//  EquipmentDetailsViewController.swift
//  OS CloudBase
//
//  Created by mohammed al-batati on 1/11/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit

class EquipmentDetailsViewController: UIViewController {

    
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var snTextField: UITextField!
    @IBOutlet weak var assetCodeTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var blTextField: UITextField!
    @IBOutlet weak var buTextField: UITextField!
    @IBOutlet weak var poTextField: UITextField!
    @IBOutlet weak var aquireCostTextField: UITextField!
    @IBOutlet weak var nbvTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    var type : String?
    var serialNo : String?
    var assetCode : String?
    var Details : String?
    var bl : String?
    var bu : String?
    var po : String?
    var aquireCost : String?
    var nbv : String?
    var location : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEnable(stat: false)
        typeTextField.text = type
        snTextField.text = serialNo
        assetCodeTextField.text = assetCode
        detailsTextField.text = Details
        blTextField.text = bl
        buTextField.text = bu
        poTextField.text = po
        aquireCostTextField.text = aquireCost
        nbvTextField.text = nbv
        locationTextField.text = location

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldEnable(stat : Bool) {
        typeTextField.isEnabled = stat
        snTextField.isEnabled = stat
        assetCodeTextField.isEnabled = stat
        detailsTextField.isEnabled = stat
        nbvTextField.isEnabled = stat
        aquireCostTextField.isEnabled = stat
        poTextField.isEnabled = stat
        blTextField.isEnabled = stat
        buTextField.isEnabled = stat
        locationTextField.isEnabled = stat
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Going to add certificates
        if segue.identifier == "toAddCertficiateSegue" {
            if let vc = segue.destination as? AddCertificateViewController{
                vc.assetCode = assetCode
                vc.equipmentSN = serialNo
                vc.equipmentType = type
            }
        }
        // Going to associated certificates
        if segue.identifier == "toShowCertificateForEquipmentSegue"{
            if let vc = segue.destination as? AssociatedCertificateViewController{
                vc.assetCode = assetCode
            }
            
        }
    }
    

}
