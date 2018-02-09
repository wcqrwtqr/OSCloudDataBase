//
//  DetailAssociatedCertificateViewController.swift
//  OS CloudBase
//
//  Created by mohammed al-batati on 1/12/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit

class DetailAssociatedCertificateViewController: UIViewController {

    @IBOutlet weak var equipmentTypeTextField: UITextField!
    @IBOutlet weak var equipmentSNTextField: UITextField!
    @IBOutlet weak var equipmentAssetCodeTextField: UITextField!
    @IBOutlet weak var certificateTypeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var expiryDateTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    
    
    var ID : String?
    var date : String?
    var notes : String?
    var equipmentType : String?
    var equipmentSN : String?
    var expiry : String?
    var certificatetype : String?
    var assetCode : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEnable(stat: false)
        equipmentTypeTextField.text = equipmentType
        equipmentSNTextField.text = equipmentSN
        equipmentAssetCodeTextField.text = assetCode
        certificateTypeTextField.text = certificatetype
        dateTextField.text = date
        expiryDateTextField.text = expiry
        notesTextField.text = notes
        
    }

    func textFieldEnable(stat : Bool) {
        equipmentTypeTextField.isEnabled = stat
        equipmentSNTextField.isEnabled = stat
        equipmentAssetCodeTextField.isEnabled = stat
        certificateTypeTextField.isEnabled = stat
        dateTextField.isEnabled = stat
        expiryDateTextField.isEnabled = stat
        notesTextField.isEnabled = stat
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
