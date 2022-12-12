//  JWT.swift
//  Created by George Berdovskiy on 12/11/22

import Foundation
import SwiftJWT
import Vapor

// TODO - Consider adhering to these standards - https://www.rfc-editor.org/rfc/rfc7519
struct TokenClaims: Claims {
    let issuer: String
    let subject: String
    let expiration: Date
}

// TODO - Read more about headers (what does this do)
let header = Header(kid: "KeyID1")

// Access private key from system
let path = URL(fileURLWithPath: "secret.key")

// Return signed token that will be sent to the user
func signedToken(claims: TokenClaims) -> String {
    do {
        let key: Data = try Data(contentsOf: path, options: .alwaysMapped)
        
        var pendingJWT = JWT(header: header, claims: claims)
        let jwtSigner = JWTSigner.rs256(privateKey: key)
        
        do {
            let signedJWT = try pendingJWT.sign(using: jwtSigner)
            return signedJWT
        } catch .invalidPrivateKey {
            print("Invalid private key.")
            return ""
        } catch .missingPEMHeaders {
            print("Missing PEM headers.")
            return ""
        } catch {
            print("An unknown JWT signing error occured.")
            return ""
        }
    } catch {
        print("Couldn't access key from file path.")
        return ""
    }
}
