//
//  AVMetadataCode.swift
//  
//
//  Created by Florent Morin on 08/02/2021.
//

import Foundation

#if canImport(AVFoundation)
import AVFoundation

public protocol AVMetadataCode: Code {
    
    /// Initialize from captured metadata
    ///
    /// - parameter avMetadataObject: The captured metadata
    init?(avMetadataObject: AVMetadataObject)
    
    /// Create an array of QR code from metadata output
    ///
    /// - parameter avMetadataObjects: Captured metadata
    ///
    /// - returns: An array of `Code`
    static func create(from avMetadataObjects: [AVMetadataObject]) -> [Self]
}

extension AVMetadataCode {
    
    /// Initialize from captured metadata
    ///
    /// - parameter avMetadataObject: The captured metadata
    public init?(avMetadataObject: AVMetadataObject) {
        let scannedURL: URL
        if #available(macOS 10.15, *) {
            guard let readableObject = avMetadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue,
                  let url = URL(string: stringValue) else {
                return nil
            }
            
            scannedURL = url
        } else {
            return nil
        }
        
        self.init(url: scannedURL)
    }
    
    /// Create an array of QR code from metadata output
    ///
    /// - parameter avMetadataObjects: Captured metadata
    ///
    /// - returns: An array of `Code`
    public static func create(from avMetadataObjects: [AVMetadataObject]) -> [Self] {
        avMetadataObjects
            .compactMap { Self(avMetadataObject: $0) }
    }
}

#endif
