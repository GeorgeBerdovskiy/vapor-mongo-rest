// Food.swift
// Created by George Berdovskiy on 12/11/22

import Vapor
import MongoSwift

enum FoodType: String, Codable {
    case MEAT, POULTRY, PRODUCE, DAIRY, OTHER
}

struct Food: Content {
    var _id: BSONObjectID?
    let name: String
    let type: FoodType
}

struct FoodUpdate: Content {
    var name: String?
    var type: String?
}

struct DeleteQuery: Content {
    var id: String?
}
