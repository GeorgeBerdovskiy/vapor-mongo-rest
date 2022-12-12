//  Authentication.swift
//  Created by George Berdovskiy on 12/11/22.

import Vapor
import SwiftJWT

struct TokenRequest: Content {
    var name: String
}
