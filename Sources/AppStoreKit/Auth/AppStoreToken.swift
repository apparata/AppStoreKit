//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import CommonCrypto

public struct AppStoreToken {

    public enum Error: Swift.Error {
        case failedToSignToken
    }
    
    private struct Header: Codable {
        
        let tokenType: String = "JWT"

        /// App Store Connect API requires ES256.
        let algorithm: String = "ES256"
        
        /// Private key ID from App Store Connect.
        /// (e.g. 1Z2A3BCD45)
        let keyID: String
        
        enum CodingKeys: String, CodingKey {
            case algorithm = "alg"
            case keyID = "kid"
            case tokenType = "typ"
        }
        
        init(keyID: String) {
            self.keyID = keyID
        }
    }
    
    private struct Payload: Codable {
        
        /// Issuer ID from API key page on App Store Connect.
        /// (e.g. abcdef12-a34b-5678-abcd-1ab2c3456789)
        let issuerID: String
        
        /// Expiration time relative to the epoch time.
        /// Maximum 20 minutes for App Store Connect.
        let expirationTime: Int64
        
        let audience: String = "appstoreconnect-v1"
        
        init(issuerID: String, expirationTime: Int64) {
            self.expirationTime = expirationTime
            self.issuerID = issuerID
        }
        
        enum CodingKeys: String, CodingKey {
            case issuerID = "iss"
            case expirationTime = "exp"
            case audience = "aud"
        }
    }
    
    private let header: Header
    
    private let payload: Payload
    
    public init(keyID: String, issuerID: String, expiresAfter time: TimeInterval = 19 * 60) {
        header = Header(keyID: keyID)
        let expirationTime = Date()
            .addingTimeInterval(time)
            .timeIntervalSince1970
            .rounded()
        payload = Payload(issuerID: issuerID, expirationTime: Int64(expirationTime))
    }
    
    public func sign(with key: PKCS8) throws -> String {
        let encodedHeader = base64URLEncoded(data: try JSONEncoder().encode(header))
        let encodedPayload = base64URLEncoded(data: try JSONEncoder().encode(payload))
        let digest = "\(encodedHeader).\(encodedPayload)"
        guard let digestData = digest.data(using: .utf8) else {
            throw Error.failedToSignToken
        }
        let signature = try sign(digest: digestData, pkcs8Key: key)
        return "\(digest).\(signature)"
    }
    
    private func sign(digest: Data, pkcs8Key: PKCS8) throws -> String {
        
        var error: Unmanaged<CFError>? = nil
        guard let key = SecKeyCreateWithData(pkcs8Key.keyData as CFData,
                                             [kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
                                              kSecAttrKeyClass: kSecAttrKeyClassPrivate,
                                              kSecAttrKeySizeInBits: 256] as CFDictionary,
                                             &error) else {
            throw Error.failedToSignToken
        }
        
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256((digest as NSData).bytes, CC_LONG(digest.count), &hash)
        let digestHash = Data(hash)
        
        let algorithm = SecKeyAlgorithm.ecdsaSignatureDigestX962SHA256
        guard SecKeyIsAlgorithmSupported(key, .sign, algorithm) else {
            throw Error.failedToSignToken
        }
        
        guard let signatureData = SecKeyCreateSignature(key,
                                                        algorithm,
                                                        digestHash as CFData,
                                                        &error) as Data? else {
            throw Error.failedToSignToken
        }
        
        let asn1Data = ASN1Data(signatureData)
        let signatureSequence = try asn1Data.parse()
        guard case let .sequence(signatureValues) = signatureSequence else {
            throw Error.failedToSignToken
        }
        
        guard let firstValue = signatureValues.first,
            case let .integer(firstPartData) = firstValue,
            let secondValue = signatureValues.last,
            case let .integer(secondPartData) = secondValue else {
            throw Error.failedToSignToken
        }
        
        var firstPart32Bit: Data = firstPartData
        if firstPart32Bit.count == 33 {
            firstPart32Bit = firstPart32Bit.dropFirst()
        }
        
        var secondPart32Bit: Data = secondPartData
        if secondPart32Bit.count == 33 {
            secondPart32Bit = secondPart32Bit.dropFirst()
        }
        
        let signature64Bit = firstPart32Bit + secondPart32Bit
        
        let encodedSignature = base64URLEncoded(data: signature64Bit)

        return encodedSignature
    }
    
    private func base64URLEncoded(data: Data) -> String {
        return data
            .base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
}

