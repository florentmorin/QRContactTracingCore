//
//  SwiftUICode.swift
//  
//
//  Created by Florent Morin on 08/02/2021.
//

#if canImport(CoreImage)
import CoreImage
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

#if canImport(SwiftUI)
import SwiftUI
#endif

#if (arch(arm64) || arch(x86_64))
#if canImport(CoreImage)
#if canImport(SwiftUI)

#if canImport(UIKit)

public protocol SwiftUICode: UIKitCode {
    
    /// Generate a SwiftUI Image representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as SwiftUI Image
    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func image(length: CGFloat) -> Image?
}

extension SwiftUICode {
    
    /// Generate a SwiftUI Image representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as SwiftUI Image
    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    public func image(length: CGFloat = 500.0) -> Image? {
        guard let uiImage = uiImage(length: length) else {
            return nil
        }
        
        return Image(uiImage: uiImage)
            .interpolation(.none)
    }
    
}

#endif

#if canImport(AppKit)
#if !targetEnvironment(macCatalyst)

public protocol SwiftUICode: AppKitCode {
    
    /// Generate a SwiftUI Image representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as SwiftUI Image
    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func image(length: CGFloat) -> Image?
}

extension SwiftUICode {
    
    /// Generate a SwiftUI Image representing QR code
    ///
    /// - parameter length: size length
    ///
    /// - returns: QR code as SwiftUI Image
    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    public func image(length: CGFloat = 500.0) -> Image? {
        guard let nsImage = nsImage(length: length) else {
            return nil
        }
        
        return Image(nsImage: nsImage)
            .interpolation(.none)
    }
}

#endif
#endif

#endif
#endif
#endif
