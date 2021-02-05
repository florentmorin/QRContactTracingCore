//
//  Code.swift
//  
//
//  Created by Florent Morin on 05/02/2021.
//

import Foundation

/**
 
 A code represents the data scanned from a QR code or manually entered.
 
 A code can be implemented like this:
 
 ```swift
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
     
     init?(url: URL) {
         <# set `id` and `options` from url #>
     }
     
     init(id: UUID, options: [Option : Any] = [:]) {
         self.id = id
         self.options = options
     }
     
     func buildURL() -> URL? {
         <# build URL from `id` and `options` #>
     }
 }

 ```
 
 */
public protocol Code: Identifiable {
    
    /// An option is the input
    associatedtype Option: Hashable
    
    /// The unique identifier of the element scanned
    var id: UUID { get }
    
    /// Options to be used
    ///
    /// Example: type of place, capacity
    var options: [Option: Any] { get }
    
    /// Initialize code from a scanned URL
    ///
    /// - parameter url: URL to parse
    ///
    /// - SeeAlso: `buildURL()`
    init?(url: URL)
    
    /// Manually initialize code
    ///
    /// - parameter id: data for `Code.id`
    /// - parameter options: data `Code.options`
    init(id: UUID, options: [Option: Any])
    
    /// Build URL from code
    ///
    /// - returns: URL including elements to build a new `Code`
    ///
    /// - SeeAlso: `init(url: URL)`
    func buildURL() -> URL?
}
