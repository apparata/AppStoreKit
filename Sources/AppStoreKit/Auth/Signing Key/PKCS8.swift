//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct PKCS8 {
    
    public enum Error: Swift.Error {
        case invalidFormat
    }
    
    public let rawData: Data
    
    public let keyData: Data
    
    public init(string: String) throws {
        
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = nil
        
        guard scanner.scanString("-----BEGIN PRIVATE KEY-----\n") != nil else {
            throw Error.invalidFormat
        }
        
        var lines: [String] = []
        
        var line: String?
        repeat {
            line = scanner.scanUpToCharacters(from: CharacterSet(charactersIn: "-\n"))
            if let line = line {
                lines.append(line)
            }
            guard scanner.scanString("\n") != nil else {
                break
            }
        } while line != nil
        
        guard scanner.scanString("-----END PRIVATE KEY-----") != nil else {
            throw Error.invalidFormat
        }
        
        let encodedAsBase64 = lines.joined()
        guard let decodedData = Data(base64Encoded: encodedAsBase64) else {
            throw Error.invalidFormat
        }
        rawData = decodedData
        
        keyData = try PKCS8.extractKeyData(from: rawData)
    }
    
    private static func extractKeyData(from data: Data) throws -> Data {
        
        let asn1 = ASN1Data(data)
        
        let envelope = try asn1.parse()
        guard case let .sequence(envelopedSequence) = envelope else {
            throw Error.invalidFormat
        }
        
        // There is another ASN.1 value embedded in an ASN.1 octet string
        guard let octetString = envelopedSequence.first(where: { value in
            if case .octetString(_) = value {
                return true
            } else {
                return false
            }
        }) else {
            throw Error.invalidFormat
        }
        
        guard case let .octetString(envelopedData) = octetString else {
            throw Error.invalidFormat
        }
        
        let envelopedASN1 = ASN1Data(envelopedData)
        
        let envelopedValue = try envelopedASN1.parse()
        
        guard case let .sequence(keySequence) = envelopedValue,
            let keyOctetString = keySequence.dropFirst().first,
            case let .octetString(privateKeyData) = keyOctetString else {
            throw Error.invalidFormat
        }

        guard let publicKeyValue = keySequence.last,
            case let .sequence(publicKeySequence) = publicKeyValue,
            let publicKeyBitString = publicKeySequence.first,
            case let .bitString(publicKeyData) = publicKeyBitString else {
            throw Error.invalidFormat
        }
        
        let key = publicKeyData.dropFirst() + privateKeyData
        return key
    }
}
