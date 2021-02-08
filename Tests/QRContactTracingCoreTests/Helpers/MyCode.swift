//
//  MyCode.swift
//  
//
//  Created by Florent Morin on 05/02/2021.
//

import Foundation
import QRContactTracingCore

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(SwiftUI)
import SwiftUI
#endif

fileprivate extension UUID {
    
    /// Build UUID from data
    ///
    /// - parameter data: Input data (16 bytes)
    init?(data: Data) {
        guard data.count == 16 else {
            return nil
        }
        
        let a = [UInt8](data)
        let uuid = (a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15])
        
        self.init(uuid: uuid)
    }
    
    /// Build UUID from base64 URL string
    ///
    /// - parameter base64URLString: Input Base 64 URL string
    init?(base64URLString: String) {
        var base64 = base64URLString
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        
        guard let data = Data(base64Encoded: base64) else {
            return nil
        }
        
        self.init(data: data)
    }
    
    /// Data from UUID bytes
    var data: Data {
        withUnsafeBytes(of: uuid, { Data($0) } )
    }
    
    /// Base64 URL string (without padding)
    var base64URLString: String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

struct MyCode: Code {
    enum Option: String, Hashable {
        case type       = "t"
        case capacity   = "c"
    }
    
    enum CodeType: String, Hashable {
        case person     = "p"
        case house      = "h"
        case enterprise = "e"
        case shop       = "s"
    }
    
    let id: UUID
    let options: [Option: Any]
    
    var type: CodeType? {
        options[.type] as? CodeType
    }
    
    var capacity: Int? {
        options[.capacity] as? Int
    }
    
    static let urlScheme = "https"
    static let urlHost = "z2z.fr"
    
    init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        guard components.scheme == Self.urlScheme else {
            return nil
        }
        
        guard components.host == Self.urlHost else {
            return nil
        }
        let parts = components.path.split(separator: "/")
        
        guard parts.count == 1,
              let path = parts.first,
              let id = UUID(base64URLString: String(path)) else {
            return nil
        }
        
        self.id = id
        
        var options: [Option: Any] = [:]
        
        components.queryItems?.forEach { item in
            if let option = Option(rawValue: item.name), let value = item.value {
                switch option {
                case .type:
                    if let type = CodeType(rawValue: value) {
                        options[.type] = type
                    }
                case .capacity:
                    if let capacity = Int(value) {
                        options[.capacity] = capacity
                    }
                }
            }
        }
        
        self.options = options
    }
    
    init(id: UUID = UUID(), options: [Option : Any] = [:]) {
        self.id = id
        self.options = options
    }
    
    func buildURL() -> URL? {
        var components = URLComponents()
        
        components.scheme = Self.urlScheme
        components.host = Self.urlHost
        components.path = "/\(id.base64URLString)"
        
        var queryItems = [URLQueryItem]()
        
        if let type = self.type {
            queryItems.append(
                URLQueryItem(
                    name: Option.type.rawValue,
                    value: type.rawValue
                )
            )
        }
        
        if let capacity = self.capacity {
            queryItems.append(
                URLQueryItem(
                    name: Option.capacity.rawValue,
                    value: String(capacity)
                )
            )
        }
        
        if queryItems.count > 0 {
            components.queryItems = queryItems
        }
        
        return components.url
    }
}

#if canImport(CoreImage)

extension MyCode: CoreGraphicsCode { }


#if canImport(UIKit)
extension MyCode: UIKitCode { }
#endif

#if canImport(AppKit)
extension MyCode: AppKitCode { }
#endif

#if (arch(arm64) || arch(x86_64))
#if canImport(SwiftUI)
extension MyCode: SwiftUICode { }
#endif
#endif

#endif
