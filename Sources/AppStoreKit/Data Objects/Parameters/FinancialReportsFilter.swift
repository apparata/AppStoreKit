//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct FinancialReportsFilter {
    
    public let region: RegionCode
    public let period: FiscalPeriod
    public let vendor: String
    
    public init(region: RegionCode, period: FiscalPeriod, vendor: String) {
        self.region = region
        self.period = period
        self.vendor = vendor
    }
    
    public func makeParameters() -> [String: String] {
        var parameters: [String: String] = [:]
                
        parameters["filter[regionCode]"] = region.rawValue
        parameters["filter[reportDate]"] = period.formatted
        parameters["filter[reportType]"] = "FINANCIAL"
        parameters["filter[vendorNumber]"] = vendor

        return parameters
    }
}
