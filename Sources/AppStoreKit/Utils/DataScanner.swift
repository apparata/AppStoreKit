//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

class DataScanner {
    
    enum Error: Swift.Error {
        case endOfData
        case unexpectedData
        case unsupportedLength
    }
    
    var remainingCount: Int {
        return data.count
    }
    
    private var data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    @discardableResult
    func scanByte() throws -> UInt8 {
        guard let byte = data.first else {
            throw Error.endOfData
        }
        try advance(by: 1)
        return byte
    }
    
    func scanExpectedByte(_ value: UInt8) throws {
        let byte = try scanByte()
        guard byte == value else {
            throw Error.unexpectedData
        }
    }
    
    @discardableResult
    func scanInt(byteCount: Int) throws -> Int {
        guard byteCount <= 4 else {
            throw Error.unsupportedLength
        }
        let intData = try scanData(count: byteCount)
        var value: Int = 0
        for i in 0..<byteCount {
            value <<= 8
            value += Int(intData[i])
        }
        return value
    }
    
    @discardableResult
    func scanData(count: Int) throws -> Data {
        guard count <= data.count else {
            throw Error.endOfData
        }
        let subdata = Data(data.prefix(count))
        try advance(by: count)
        return subdata
    }
    
    private func advance(by count: Int) throws {
        guard count <= data.count else {
            throw Error.endOfData
        }
        if count == data.count {
            data = Data()
        } else {
            data = data.advanced(by: count)
        }
    }
}
