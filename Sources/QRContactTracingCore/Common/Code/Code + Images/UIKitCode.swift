//
//  UIKitCode.swift
//  
//
//  Created by Florent Morin on 08/02/2021.
//

import Foundation

#if canImport(CoreImage)
import CoreImage
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(CoreImage)
#if canImport(UIKit)

public protocol UIKitCode: CoreImageCode {
    
    /// Generate a UI Image representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as UI Image
    func uiImage(length: CGFloat) -> UIImage?
}

extension UIKitCode {
    
    /// Generate a UI Image representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as UI Image
    public func uiImage(length: CGFloat = 500.0) -> UIImage? {
        guard let ciImage = ciImage(length: length) else {
            return nil
        }
        
        return UIImage(ciImage: ciImage)
    }
    
}

#endif
#endif
