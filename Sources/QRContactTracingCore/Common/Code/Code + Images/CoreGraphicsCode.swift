//
//  CoreGraphicsCode.swift
//  
//
//  Created by Florent Morin on 08/02/2021.
//

import CoreGraphics

#if canImport(CoreImage)
import CoreImage
#endif

#if canImport(CoreServices)
import CoreServices
#elseif canImport(MobileCoreServices)
import MobileCoreServices
#endif

#if canImport(CoreImage)

public protocol CoreGraphicsCode: CoreImageCode {
    
    /// Generate a CG Image representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as CG Image
    func cgImage(length: CGFloat) -> CGImage?
    
    /// Generate image PNG data representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as  image PNG data
    func pngData(length: CGFloat) -> Data?
}

extension CoreGraphicsCode {
    
    /// Generate a CG Image representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as CG Image
    public func cgImage(length: CGFloat = 500.0) -> CGImage? {
        guard let ciImage = ciImage(length: length) else {
            return nil
        }
        
        let context = CIContext()
        
        return context.createCGImage(ciImage, from: ciImage.extent)
    }
    
    /// Generate a  image PNG data representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as  image PNG data
    public func pngData(length: CGFloat = 500.0) -> Data? {
        guard let cgImage = cgImage(length: length) else {
            return nil
        }
        
        let data = NSMutableData()
        
        guard let dst = CGImageDestinationCreateWithData(data, kUTTypePNG, 1, nil) else {
            return nil
        }
        
        CGImageDestinationAddImage(dst, cgImage, nil)
        CGImageDestinationFinalize(dst)
        
        return data as Data
    }
}

#endif
