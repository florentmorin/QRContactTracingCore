//
//  MyCode.swift
//  
//
//  Created by Florent Morin on 05/02/2021.
//

import Foundation
import QRContactTracingCore

struct MyCode: Code {
    enum Option: String, Hashable {
        case type
        case capacity
    }
    
    enum CodeType: String, Hashable {
        case person
        case house
        case enterprise
        case shop
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
    static let urlHost = "qrcode.tousanticovid.gouv.fr"
    
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
              let id = UUID(uuidString: String(path)) else {
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
        components.path = "/\(id.uuidString)"
        
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
