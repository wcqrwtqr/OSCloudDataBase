//
//  CertificateSnapshot.swift
//  OS CloudBase
//
//  Created by mohammed al-batati on 1/11/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import Foundation
import Firebase

struct CertificateSnapshot {
    let certificates : [Certificate]
    
    init?(with snapshot : DataSnapshot) {
        var certificates = [Certificate]()
        guard let snapDict = snapshot.value as? [String : [String : Any]] else {return nil}
        for snap in snapDict{
            guard let certificatei = Certificate(id: snap.key, dict: snap.value) else {continue}
            certificates.append(certificatei)
        }
        self.certificates = certificates
    }
}
