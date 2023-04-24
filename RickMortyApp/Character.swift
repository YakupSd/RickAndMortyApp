//
//  Character.swift
//  RickMortyApp
//
//  Created by Yakup Suda on 17.04.2023.
//

import Foundation


struct Character: Decodable {
    let info: Info?
    let results: [Results]
}

struct Info: Decodable {
    let count, pages: Int?
    let next, prev: String?
}

struct Results : Decodable {
    let id : Int?
    let name : String?
    let status : String?
    let species : String?
    let type : String?
    let gender : String?
    let origin : Origin
    let image : String?
    let location : Location
    let episode : [String]
    let created : String?
}

struct Location : Decodable {
    let name : String?
    let url : String?
}
struct Origin : Decodable {
    let name : String?
    let url : String?
}
