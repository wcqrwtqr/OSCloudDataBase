//
//  Certificate.swift
//  OS CloudBase
//
//  Created by mohammed al-batati on 1/11/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import Foundation

struct Certificate {
//    let assetCode : String
    let ID : String
    let Date : String
    let Notes : String
    let equipmentType : String
    let equipmentSN : String
    let expiry : String
    let type : String
    
    init?(id : String , dict : [String : Any]) {
        self.ID  = id
        guard let Date = dict["Date"] as? String,
            let Notes = dict["Notes"] as? String,
            let equipmentSN = dict["equipmentsn"] as? String,
            let equipmentType = dict["equipmentType"] as? String,
            let expiry = dict["expiry"] as? String,
            let type = dict["type"] as? String else {return nil}
    self.Date = Date
    self.Notes = Notes
    self.equipmentSN = equipmentSN
    self.equipmentType = equipmentType
    self.expiry = expiry
    self.type = type
    }
}
