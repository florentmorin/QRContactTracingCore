//
//  AppKitCode.swift
//  
//
//  Created by Florent Morin on 08/02/2021.
//

#if !targetEnvironment(macCatalyst)

#if canImport(AppKit)
import AppKit
#endif

#if canImport(CoreImage)
import CoreImage
#endif


#if canImport(CoreImage)
#if canImport(AppKit)

public protocol AppKitCode: CoreImageCode {
    
    /// Generate a NS Image representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as NS Image
    func nsImage(length: CGFloat) -> NSImage?
}

extension AppKitCode {
    
    /// Generate a NS Image representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as NS Image
    public func nsImage(length: CGFloat = 500.0) -> NSImage? {
        guard let ciImage = ciImage(length: length) else {
            return nil
        }
        
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        
        nsImage.addRepresentation(rep)
        
        return nsImage
    }
    
}

#endif
#endif

#endif
