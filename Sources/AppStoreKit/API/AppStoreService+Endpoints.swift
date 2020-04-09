//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import Combine

public extension AppStoreService {
    
    func apps() throws -> AnyPublisher<AppsResponse, Error> {
        try getJSON("/apps")
    }
    
    func financialReports(region: RegionCode, period: FiscalPeriod) throws -> AnyPublisher<FinancialReport, Error> {
        let vendor = configuration.vendorID
        let filter = FinancialReportsFilter(region: region, period: period, vendor: vendor)
        let parameters = filter.makeParameters()
        return try getData("/financeReports", parameters: parameters)
            .tryMap {
                try FinancialReport(region: region, period: period, vendor: vendor, data: $0)
            }.eraseToAnyPublisher()
    }
}
