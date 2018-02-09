//
//  Equipments.swift
//  OS CloudBase
//
//  Created by mohammed al-batati on 1/11/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import Foundation

struct Equipments {
    let aquirecost : String
    let assetcode : String
    let bl : String
    let bu : String
    let location : String
    let nbv : String
    let notes : String
    let po : String
    let serialnumber : String
    let type : String
    
    init?(assetCode : String , dict : [String : Any]) {
        self.assetcode = assetCode
        guard let aquirecost = dict["aquirecost"] as? String,
            let bl = dict["bl"] as? String,
            let bu = dict["bu"] as? String,
            let location = dict["location"] as? String,
            let nbv = dict["nbv"] as? String,
            let notes = dict["notes"] as? String,
            let po = dict["po"] as? String,
            let serialnumber = dict["serialNumber"] as? String,
            let type = dict["type"] as? String  else {return nil}
        
        self.aquirecost = aquirecost
        self.bl = bl
        self.bu = bu
        self.location = location
        self.nbv = nbv
        self.notes = notes
        self.po = po
        self.serialnumber = serialnumber
        self.type = type
        
    }
}
