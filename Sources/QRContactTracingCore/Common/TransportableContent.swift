//
//  TransportableContent.swift
//  
//
//  Created by Florent Morin on 05/02/2021.
//

import Foundation
import CommonCrypto

/**
 
 Transportable content represents content exported and imported.
 
 When user will share its code, supplement data will be encrypted.
 And, to decrypt supplement data from an importation, local content is required.
 
 */
public struct TransportableContent {
    
    /// Identifier is based on key and encryptedData
    public var id: Data {
        key + encryptedData
    }
    
    /// Key build from local content
    public let key: Data
    
    /// Supplement data, encrypted with local content
    public let encryptedData: Data
    
    /// Initializer from local data
    ///
    /// - parameter localContent: Content from local store
    /// - parameter clearData: Supplement data that need to be encrypted (stored in `encryptedData`)
    @inline(__always)
    public init?(localContent: LocalContent, clearData: Data) {
        let iv = localContent.transportableKey
        
        let data = Self.crypt(
            input: clearData,
            key: localContent.key,
            iv: iv,
            operation: CCOperation(kCCEncrypt)
        )
        
        guard let encryptedData = data else {
            return nil
        }
        
        self.encryptedData = encryptedData
        self.key = iv
    }
    
    /// Initializer from external data
    ///
    /// - parameter key: Key from external data
    /// - parameter encryptedData: encrypted data containing supplement data
    public init(key: Data, encryptedData: Data) {
        self.key = key
        self.encryptedData = encryptedData
    }
    
    /// Decrypt data using corresponding local content
    ///
    /// - parameter localContent: Local content containing keys to decrypt data
    ///
    /// - returns: Data if decryption works fine
    @inline(__always)
    public func decryptData(localContent: LocalContent) -> Data? {
        Self.crypt(
            input: encryptedData,
            key: localContent.key,
            iv: localContent.transportableKey,
            operation: CCOperation(kCCDecrypt)
        )
    }
}

extension TransportableContent {

    /// Crypt data using AES-128 algorithm with a PKCS7 padding
    ///
    /// - parameter input: Data to encrypt / decrypt
    /// - parameter key: key (128 bits)
    /// - parameter iv: Initialization vector (128 bits)
    /// - parameter operation: kCCEncrypt / kCCDecrypt
    ///
    /// - returns: Data, if encryption / decryption is a success
    @inline(__always)
    fileprivate static func crypt(input: Data, key: Data, iv: Data, operation: CCOperation) -> Data? {
        var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
        let rawKey = NSData(data: key).bytes
        let rawInput = NSData(data: input).bytes
        var output = [UInt8](repeating: 0, count: input.count + kCCBlockSizeAES128)
        var outputLen = 0
        let iv = NSData(data: iv).bytes
        
        status = CCCrypt(
            operation,
            CCAlgorithm(kCCAlgorithmAES128),
            CCOptions(kCCOptionPKCS7Padding),
            rawKey, key.count,
            iv,
            rawInput, input.count,
            &output, output.count,
            &outputLen
        )
        
        if status == kCCSuccess {
            return Data(bytes: output, count: outputLen)
        } else {
            return nil
        }
    }
}
