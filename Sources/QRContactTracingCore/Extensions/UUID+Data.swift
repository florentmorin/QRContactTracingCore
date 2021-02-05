//
//  UUID+Data.swift
//  
//
//  Created by Florent Morin on 05/02/2021.
//

import Foundation

extension UUID {
        
    /// Build UUID from data
    ///
    /// - parameter data: Input data (16 bytes)
    init(data: Data) {
        precondition(data.count == 16, "UUID data must be 16 bytes in length")
        
        let a = [UInt8](data)
        let uuid = (a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15])
        
        self.init(uuid: uuid)
    }
    
    /// Data from UUID bytes
    var data: Data {
        withUnsafeBytes(of: uuid, { Data($0) } )
    }
}
