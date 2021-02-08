//
//  CoreImageCode.swift
//  
//
//  Created by Florent Morin on 08/02/2021.
//

#if canImport(CoreImage)

import CoreImage
import CoreImage.CIFilterBuiltins

public protocol CoreImageCode: Code {
    
    /// Generate a CI Image representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as CI Image
    func ciImage(length: CGFloat) -> CIImage?
}

extension CoreImageCode {
    
    /// Generate a CI Image representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as CI Image
    public func ciImage(length: CGFloat = 500) -> CIImage? {
        guard let message = buildURL()?.absoluteString.data(using: .utf8) else {
            return nil
        }
        
        let outputImage: CIImage?
        
        if #available(iOS 13.0, macOS 10.15, tvOS 13.0, *) {
            let filter = CIFilter.qrCodeGenerator()
        
            filter.message = message
        
            outputImage = filter.outputImage
        } else {
            guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
                return nil
            }
            
            filter.setValue(message, forKey: "inputMessage")
            
            outputImage = filter.outputImage
        }
        
        guard let output = outputImage else {
            return nil
        }
        
        let scaleX = length / output.extent.size.width
        let scaleY = length / output.extent.size.height
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        
        return output.transformed(by: transform)
    }
    
}

#endif
