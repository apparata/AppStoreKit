//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct Agent {
    public let name: String
    public let vatID: String?
    public let currencies: [String]
}

public extension Agent {
    
    static let allAgents: [Agent] = [
        appleInc,
        appleCanadaInc,
        appleDistributionInternational,
        applePtyLimited,
        iTunesKK
    ]
    
    static let appleInc = Agent(
        name: "Apple Inc.",
        vatID: nil,
        currencies: [
            "BRL", // Brazilian Real
            "CLP", // Chilean Peso
            "COP", // Comlombian Peso
            "PEN", // Pervuvian Sol
            "USD", // United States Dollar
            ])
    
    static let appleCanadaInc = Agent(
        name: "Apple Canada Inc.",
        vatID: nil,
        currencies: [
            "CAD" // Canadian Dollar
        ])
    
    static let appleDistributionInternational = Agent(
        name: "Apple Distribution International",
        vatID: "IE9700053D",
        currencies: [
            "AED", // United Arab Emirates Dirham
            "BGN", // Bulgarian Lev
            "CHF", // Swiss Franc
            "CNY", // Chinese Yuan
            "CZK", // Czech Koruna
            "DKK", // Danish Krone
            "EUR", // Euro
            "EGP", // Egyptian Pound
            "GBP", // Pound Sterling
            "HKD", // Hong Kong Dollar
            "HUF", // Hungarian Forint
            "HRK", // Croatian Kuna
            "IDR", // Indonesian Rupiah
            "ILS", // Israeli New Shekel
            "INR", // Indian Rupee
            "KRW", // Korean Won
            "KZT", // Kazakhstani Tenge
            "MYR", // Malaysian Ringgit
            "NGN", // Nigerian Naira
            "NOK", // Norwegian Krone
            "RUB", // Pakistani Rupee
            "PHP", // Philippine Peso
            "PLN", // Polish Zloty
            "PKR", // Pakistani Rupee
            "QAR", // Qatari Riyal
            "RON", // Romanian Leu
            "SAR", // Saudi Riyal
            "SEK", // Swedish Krona
            "SGD", // Singapore Dollar
            "THB", // Thai Baht
            "TRY", // Turkish Lira
            "TWD", // New Taiwan Dollar
            "TZS", // Tanzanian Shilling
            "USD-WW", // Rest of the world US Dollar
            "VND", // Vietnamese Dong"
            "ZAR" // South African Rand
        ])
    
    static let applePtyLimited = Agent(
        name: "Apple Pty Limited",
        vatID: nil,
        currencies: [
            "AUD", // Australian Dollar
            "NZD" // New Zealand Dollar
        ])
    
    static let iTunesKK = Agent(
        name: "iTunes K.K.",
        vatID: nil,
        currencies: [
            "JPY" // Japanese Yen
        ])
}
