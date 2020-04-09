//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public enum ProductTypeIdentifier {
    
    case freeOrPaidApp(id: String, String)
    case appBundle(id: String, String)
    case paidApp(id: String, String)
    case redownload(id: String, String)
    case update(id: String, String)
    case inAppPurchase(id: String, String)
    case restoredInAppPurchase(id: String, String)
    case unknown(id: String, String)
    
    public var typeAsString: String {
        switch self {
        case .freeOrPaidApp: return "Free or Paid App"
        case .appBundle: return "App Bundle"
        case .paidApp: return "Paid App"
        case .redownload: return "Redownload"
        case .update: return "Update"
        case .inAppPurchase: return "In-App Purchase"
        case .restoredInAppPurchase: return "Restored In-App Purchase"
        case .unknown: return "Unknown"
        }
    }
    
    public init(_ id: String) {
        switch id {
        case "1": self = .freeOrPaidApp(id: id, "iPhone, iPod touch (iOS), Apple watch")
        case "1-B": self = .appBundle(id: id, "iPhone, iPod touch (iOS)")
        case "F1-B": self = .appBundle(id: id, "Mac app")
        case "1E": self = .paidApp(id: id, "Custom iPhone and iPod touch (iOS)")
        case "1EP": self = .paidApp(id: id, "Custom iPad (iOS)")
        case "1EU": self = .paidApp(id: id, "Custom universal (iOS)")
        case "1F": self = .freeOrPaidApp(id: id, "Universal (iOS), excluding tvOS")
        case "1T": self = .freeOrPaidApp(id: id, "iPad (iOS)")
        case "3": self = .redownload(id: id, "Update (iOS, watchOS, and tvOS), excluding iPad only")
        case "3F": self = .redownload(id: id, "Universal (iOS), excluding tvOS")
        case "7": self = .update(id: id, "Update (iOS, watchOS, and tvOS), excluding iPad only")
        case "7F": self = .update(id: id, "Universal (iOS), excluding tvOS")
        case "7T": self = .update(id: id, "iPad (iOS)")
        case "F1": self = .freeOrPaidApp(id: id, "Mac app")
        case "F7": self = .update(id: id, "Mac app")
        case "FI1": self = .inAppPurchase(id: id, "Mac app")
        case "IA1": self = .inAppPurchase(id: id, "Purchase (iOS)")
        case "IA1-M": self = .inAppPurchase(id: id, "Purchase (Mac)")
        case "IA3": self = .restoredInAppPurchase(id: id, "Non-consumable")
        case "IA9": self = .inAppPurchase(id: id, "Subscription (iOS)")
        case "IA9-M": self = .inAppPurchase(id: id, "Subscription (Mac)")
        case "IAY": self = .inAppPurchase(id: id, "Auto-renewable subscription (iOS)")
        case "IAY-M": self = .inAppPurchase(id: id, "Auto-renewable subscription (Mac)")
        default: self = .unknown(id: id, "Unknown product type")
        }
    }
}
