//
//  EquipmentsSnapshot.swift
//  OS CloudBase
//
//  Created by mohammed al-batati on 1/11/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import Foundation
import Firebase

struct EquipmentSnapshot {
    let equipments : [Equipments]
    
    init?(with snapshot: DataSnapshot) {
        var equipments = [Equipments]()
        guard let snapDict = snapshot.value as? [String : [String : Any]] else {return nil}
        for snap in snapDict{
            guard let equipmenti = Equipments(assetCode: snap.key, dict: snap.value) else { continue }
            equipments.append(equipmenti)
        }
        self.equipments = equipments
    }
}


