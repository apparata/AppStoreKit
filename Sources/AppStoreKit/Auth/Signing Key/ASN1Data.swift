//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

struct ASN1Data {
    
    enum Error: Swift.Error {
        case unexpectedLength
    }
    
    indirect enum ASN1Value {
        case boolean(Bool)                  // 0x01
        case integer(Data)                  // 0x02
        case bitString(Data)                // 0x03
        case octetString(Data)              // 0x04
        case null                           // 0x05
        case objectIdentifier (Data)        // 0x06
        case utf8String(String)             // 0x0C
        case printableString(String)        // 0x13
        case ia5String(Data)                // 0x16
        case bmpString(Data)                // 0x1E
        case sequence([ASN1Value])          // 0x30
        case set([ASN1Value])               // 0x31
        case unsupported(tag: UInt8, Data)  // 0x??
    }
    
    private let data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    func parse() throws -> ASN1Value {
        let scanner = DataScanner(data)
        let taggedValue = try parseNextTaggedValue(scanner)
        return taggedValue
    }
    
    private func parseNextTaggedValue(_ scanner: DataScanner) throws -> ASN1Value {
        
        let tag = try scanner.scanByte()
        
        switch tag {
        case 0x01: return try parseBoolean(scanner)
        case 0x02: return try parseInteger(scanner)
        case 0x03: return try parseBitString(scanner)
        case 0x04: return try parseOctetString(scanner)
        case 0x05: return try parseNull(scanner)
        case 0x06: return try parseObjectIdentifier(scanner)
        case 0x0C: return try parseUTF8String(scanner)
        case 0x13: return try parsePrintableString(scanner)
        case 0x16: return try parseIA5String(scanner)
        case 0x1E: return try parseBMPString(scanner)
        case 0x30: return try parseSequence(scanner)
        case 0x31: return try parseSet(scanner)
        case 0xA0: return try parseSequence(scanner) // PKCS#8 specific
        case 0xA1: return try parseSequence(scanner) // PKCS#8 specific
        default: return try skipUnsupportedTaggedValue(scanner, tag: tag)
        }
    }
    
    private func skipUnsupportedTaggedValue(_ scanner: DataScanner, tag: UInt8) throws -> ASN1Value {
        let length = try parseLength(scanner)
        let skippedData = try scanner.scanData(count: length)
        return .unsupported(tag: tag, skippedData)
    }
    
    private func parseBoolean(_ scanner: DataScanner) throws -> ASN1Value {
        try parseLength(scanner, expect: 1)
        let byte = try scanner.scanByte()
        let value = (byte != 0)
        return .boolean(value)
    }
    
    private func parseInteger(_ scanner: DataScanner) throws -> ASN1Value {
        let length = try parseLength(scanner)
        let intData = try scanner.scanData(count: length)
        return .integer(intData)
    }
    
    private func parseBitString(_ scanner: DataScanner) throws -> ASN1Value {
        let length = try parseLength(scanner)
        let bitString = try scanner.scanData(count: length)
        return .bitString(bitString)
    }
    
    private func parseOctetString(_ scanner: DataScanner) throws -> ASN1Value {
        let length = try parseLength(scanner)
        let octetString = try scanner.scanData(count: length)
        return .octetString(octetString)
    }
    
    func parseNull(_ scanner: DataScanner) throws -> ASN1Value {
        try parseLength(scanner, expect: 1)
        return .null
    }
    
    private func parseObjectIdentifier(_ scanner: DataScanner) throws -> ASN1Value {
        let length = try parseLength(scanner)
        let objectIdentifier = try scanner.scanData(count: length)
        return .bitString(objectIdentifier)
    }
    
    private func parseUTF8String(_ scanner: DataScanner) throws -> ASN1Value {
        let length = try parseLength(scanner)
        let utf8Data = try scanner.scanData(count: length)
        let utf8String = String(data: utf8Data, encoding: .utf8) ?? ""
        return .utf8String(utf8String)
    }
    
    private func parsePrintableString(_ scanner: DataScanner) throws -> ASN1Value {
        let length = try parseLength(scanner)
        let printableString = try scanner.scanData(count: length)
        let utf8String = String(data: printableString, encoding: .utf8) ?? ""
        return .printableString(utf8String)
    }
    
    private func parseIA5String(_ scanner: DataScanner) throws -> ASN1Value {
        let length = try parseLength(scanner)
        let ia5String = try scanner.scanData(count: length)
        return .ia5String(ia5String)
    }
    
    private func parseBMPString(_ scanner: DataScanner) throws -> ASN1Value {
        let length = try parseLength(scanner)
        let bmpString = try scanner.scanData(count: length)
        return .bmpString(bmpString)
    }
    
    private func parseSequence(_ scanner: DataScanner) throws -> ASN1Value {
        let length = try parseLength(scanner)
        let limit = scanner.remainingCount - length
        
        var values: [ASN1Value] = []
        while scanner.remainingCount > limit {
            let value = try parseNextTaggedValue(scanner)
            values.append(value)
        }
        
        return .sequence(values)
    }
    
    private func parseSet(_ scanner: DataScanner) throws -> ASN1Value {
        let length = try parseLength(scanner)
        let limit = scanner.remainingCount - length
        
        var values: [ASN1Value] = []
        while scanner.remainingCount > limit {
            let value = try parseNextTaggedValue(scanner)
            values.append(value)
        }
        
        return .set(values)
    }
    
    @discardableResult
    private func parseLength(_ scanner: DataScanner, expect: Int? = nil) throws -> Int {
        let byte = try scanner.scanByte()
        var length: Int = Int(byte)
        if length & 0x80 > 0 {
            let lengthOfLength = length & 0x7F
            length = try scanner.scanInt(byteCount: lengthOfLength)
            if let expect = expect, length != expect {
                throw Error.unexpectedLength
            }
        }
        return length
    }
}
