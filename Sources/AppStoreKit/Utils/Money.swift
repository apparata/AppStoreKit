//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public class Money {

    private static let moneyFormatter: NumberFormatter = {
        $0.locale = Locale(identifier: "en_US")
        $0.numberStyle = .decimal
        return $0
    }(NumberFormatter())

    public static func amount(from string: String) throws -> Decimal {
        guard let amount = moneyFormatter.number(from: string) else {
            throw AppStoreServiceError.invalidData
        }
        return amount.decimalValue
    }
}
