//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public class Countries {
    public static var euMembers: [String] = [
        "AT", "BE", "BG", "CR", "CY", "CZ", "DK", "EE",
        "FI", "FR", "DE", "GR", "HU", "IE", "IT", "LV",
        "LT", "LU", "MT", "NL", "PL", "PT", "RO", "SK",
        "SI", "ES", "SE", "GB", "UK"
    ]
    
    public static func isInEU(country: String) -> Bool {
        euMembers.contains(country.uppercased())
    }
}
