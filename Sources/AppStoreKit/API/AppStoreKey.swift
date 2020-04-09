//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct AppStoreKey {
    public let id: String
    public let path: String
    public let issuerID: String
    
    public init(id: String, path: String, issuerID: String) {
        self.id = id
        self.path = path
        self.issuerID = issuerID
    }
}
