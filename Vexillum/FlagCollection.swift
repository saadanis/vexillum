//
//  FlagCollection.swift
//  Vexillum
//
//  Created by Saad Anis on 05/07/2024.
//

import Foundation
import SwiftData

@Model
class FlagCollection {
    var name: String
    var overview: String
    var symbolName: String
    var hex: String
    var predefined: Bool
    
    @Relationship(inverse: \Flag.collections) var flags: [Flag]
    
    init(name: String, overview: String, symbolName: String, hex: String, flags: [Flag] = [], predefined: Bool) {
        self.name = name
        self.overview = overview
        self.symbolName = symbolName
        self.hex = hex
        self.flags = flags
        self.predefined = predefined
    }
}
