//
//  Currency.swift
//  Interview
//
//  Created by Emre AYDIN on 16.04.2022.
//

import Foundation

struct Currency: Codable {

    let id: String
    let name: String
    let minSize: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case minSize = "min_size"
    }

}
