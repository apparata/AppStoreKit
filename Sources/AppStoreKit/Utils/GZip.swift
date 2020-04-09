//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public enum GZipError: Error {
    case notGZip
    case invalidData
    case unsupportedCompressionMethod
}

public func gunzip(data: Data) throws -> Data {
    let gzipHeader = try GZipHeader(data: data)
    let compressedData = data.subdata(in: gzipHeader.compressedDataRange)
    return try (compressedData as NSData).decompressed(using: .zlib) as Data
}

private struct GZipHeader {

    let compressionMethod: UInt8
    let flags: UInt8
    let modifiedTime: UInt32
    let extraFlags: UInt8
    let operatingSystem: UInt8
    
    let filename: String?
    let comment: String?

    let compressedDataRange: Range<Data.Index>
    
    init(data: Data) throws {
        var offset: Int = 0
        
        let magicNumber: UInt16 = data.scanValue(offset: &offset)
        if magicNumber != 0x8b1f {
            throw GZipError.notGZip
        }
    
        if data.count < (10 /* Header */ + 8 /* Footer */) {
            throw GZipError.invalidData
        }
        
        compressionMethod = data.scanValue(offset: &offset)
        if compressionMethod != 8 {
            // Only support DEFLATE, which is 8.
            throw GZipError.unsupportedCompressionMethod
        }
        
        flags = data.scanValue(offset: &offset)
        let hasHeaderChecksum = flags & 2 != 0
        let hasExtraFields = flags & 4 != 0
        let hasFileName = flags & 8 != 0
        let hasComment = flags & 16 != 0
        
        modifiedTime = data.scanValue(offset: &offset)
        extraFlags = data.scanValue(offset: &offset)
        operatingSystem = data.scanValue(offset: &offset)
        
        if hasExtraFields {
            // Ignore extra fields.
            let extraFieldsSize: UInt16 = data.scanValue(offset: &offset)
            offset += 2 + Int(extraFieldsSize)
        }
        
        if hasFileName {
            filename = data.scanNullTerminatedString(offset: &offset)
        } else {
            filename = nil
        }
        
        if hasComment {
            comment = data.scanNullTerminatedString(offset: &offset)
        } else {
            comment = nil
        }
        
        if hasHeaderChecksum {
            // Ignore header checksum.
            offset += 2
        }
        
        compressedDataRange = offset ..< (data.count - 8 /* Footer */)
    }
}

private struct GZipFooter {
    /// This contains a Cyclic Redundancy Check value of the
    /// uncompressed data computed according to CRC-32 algorithm
    /// used in the ISO 3309 standard
    let crc32: UInt32
    
    /// This contains the size of the original (uncompressed)
    /// input data modulo 2^32.
    let inputSize: UInt32
    
    init(data: Data) throws {
        
        var offset: Int = 0
        
        let magicNumber: UInt16 = data.scanValue(offset: &offset)
        if magicNumber != 0x8b1f {
            throw GZipError.notGZip
        }
    
        if data.count < (10 /* Header */ + 8 /* Footer */) {
            throw GZipError.invalidData
        }
        
        offset = data.count - 8
        crc32 = data.scanValue(offset: &offset)
        inputSize = data.scanValue(offset: &offset)
    }
}

private extension Data {
    func scanValue<T>(offset: inout Int) -> T {
        let length = MemoryLayout<T>.size
        defer { offset += length }
        return subdata(in: offset..<offset+length).withUnsafeBytes {
            $0.load(as: T.self)
        }
    }
    
    func scanNullTerminatedString(offset: inout Int) -> String? {
        var byte: UInt8 = 0
        var stringData = Data()
        repeat {
            byte = scanValue(offset: &offset)
            if byte != 0 {
                stringData.append(byte)
            }
        } while byte != 0
        if stringData.count > 0 {
            return String(data: stringData, encoding: .isoLatin1)
        }
        return nil
    }
    
    func indexOffset(by offset: Int) -> Data.Index {
        startIndex.advanced(by: offset)
    }
}
