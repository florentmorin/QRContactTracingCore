//
//  LocalKey.swift
//  
//
//  Created by Florent Morin on 05/02/2021.
//

import Foundation
import CommonCrypto


/**
 
 Local content represent content stored locally.
 
 Local content comes from a `code` or raw data.
 
 Raw data can be stored into local database.
 
 */
public struct LocalContent {
    
    /// Unique identifier is transportable key
    ///
    /// Transportable key is based on code id + date
    public var id: Data {
        transportableKey
    }
    
    /// Code ID
    ///
    /// - SeeAlso: `Code.id`
    public let codeId: UUID
    
    /// Date when code was entered
    public let date: Date
    
    /// Date offset
    public let dateOffset: Int?
    
    /// Transportable key calculated from code id + date
    public let transportableKey: Data
    
    /// A date formatter used for encryption
    @inline(__always)
    fileprivate static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        return df
    }()
    /// Initializer
    ///
    /// - parameter codeId: Code ID (see `Code.id`)
    /// - parameter date: Date when code was entered (default: now)
    /// - parameter dateOffset: Custom date offset to specify each part of the day is concerned (default: nil)
    /// - parameter transportableKey: Transportable key calculated from code id + date + date offset
    public init(codeId: UUID, date: Date = Date(), dateOffset: Int? = nil, transportableKey: Data? = nil) {
        self.codeId = codeId
        self.date = date
        self.dateOffset = dateOffset
        self.transportableKey = transportableKey ?? Self.buildTransportableKey(id: codeId, date: date, dateOffset: dateOffset)
    }
}

extension LocalContent {
    
    @inline(__always)
    private static func buildPassword(date: Date, dateOffset: Int? = nil) -> String {
        var password = dateFormatter.string(from: date)
        
        if let dateOffset = dateOffset {
            password = password + String(dateOffset)
        }
        
        return password
    }
    
    /// Build transportable key using PBKDF2
    @inline(__always)
    internal static func buildTransportableKey(id: UUID, date: Date, dateOffset: Int? = nil) -> Data {
        let length: Int = kCCKeySizeAES128
        let password = buildPassword(date: date, dateOffset: dateOffset)
        let rawPassword: [CChar] = password.cString(using: .utf8)!.dropLast()
        let rawSalt: [CUnsignedChar] = Array(hexadecimalSalt(id))
            .chunked(into: 2)
            .map { String($0) }
            .map { CUnsignedChar($0, radix: 16)! }

        var derivedKeyData: [CUnsignedChar] = Array(repeating: 0, count: length)
        let rounds: UInt32 = 200_000
        
        CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            rawPassword, rawPassword.count,
            rawSalt, rawSalt.count,
            CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256),
            rounds,
            &derivedKeyData, length
        )
        
        return Data(bytes: derivedKeyData, count: length)
    }
    
    /// Key used to sign `TransportableContent`
    @inline(__always)
    internal var key: Data {
        codeId.data
    }
    
}

extension LocalContent {
        
    /// Helper
    @inline(__always)
    private static func hexadecimalSalt(_ uuid: UUID) -> String {
        uuid.uuidString.replacingOccurrences(of: "-", with: "")
    }

}
