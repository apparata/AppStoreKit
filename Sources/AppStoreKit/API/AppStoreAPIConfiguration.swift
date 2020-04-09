//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct AppStoreAPIConfiguration {
    
    /// Private key ID from App Store Connect.
    /// (e.g. 1A2B3CDE45)
    let privateKeyID: String
    
    /// Issuer ID from API key page on App Store Connect.
    /// (e.g. abcdef12-a34b-5678-abcd-1ab2c3456789)
    let issuerID: String
    
    /// Private key downloaded from API key page
    let privateKey: PKCS8
    
    /// Vendor ID from App Store Connect.
    /// (e.g. 81234567)
    let vendorID: String
    
    public init(privateKeyID: String, issuerID: String, privateKey: PKCS8, vendorID: String) {
        self.privateKeyID = privateKeyID
        self.issuerID = issuerID
        self.privateKey = privateKey
        self.vendorID = vendorID
    }
}
