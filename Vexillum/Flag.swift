//
//  Flag.swift
//  Vexillum
//
//  Created by Saad Anis on 29/06/2024.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Flag: Codable {
    
    enum CodingKeys: CodingKey {
        case flag_id,
             country_name,
             nickname,
             continent,
             aspect_ratio,
             colors,
             overview,
             collections
    }
    
    var country: String
    var id: String
    var nickname: String?
    var continent: [String]
    var aspectRatio: String
    var hexes: [String]
    var overview: String
    
    var collections: [FlagCollection]
    
    init(country: String, id: String, nickname: String? = nil, continent: [String], aspectRatio: String, hexes: [String], overview: String, collections: [FlagCollection]) {
        self.country = country
        self.id = id
        self.nickname = nickname
        self.continent = continent
        self.aspectRatio = aspectRatio
        self.hexes = hexes
        self.overview = overview
        self.collections = collections
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.country = try container.decode(String.self, forKey: .country_name)
        self.id = try container.decode(String.self, forKey: .flag_id)
        self.nickname = try container.decode(String?.self, forKey: .nickname)
        self.continent = try container.decode([String].self, forKey: .continent)
        self.aspectRatio = try container.decode(String.self, forKey: .aspect_ratio)
        self.hexes = try container.decode([String].self, forKey: .colors)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.collections = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(country, forKey: .country_name)
        try container.encode(id, forKey: .flag_id)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(continent, forKey: .continent)
        try container.encode(aspectRatio, forKey: .aspect_ratio)
        try container.encode(hexes, forKey: .colors)
        try container.encode(overview, forKey: .overview)
//        try container.encode(collections, forKey: .collections)
    }
}
