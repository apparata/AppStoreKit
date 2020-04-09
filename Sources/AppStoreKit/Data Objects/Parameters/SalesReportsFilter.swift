//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct SalesReportsFilter {
    
    public enum Frequency {
        case daily(Date?)
        case weekly(Date)
        case monthly(Date)
        case yearly(Date)
    }

    public enum ReportType {
        case sales
        case preOrder
        case newsstand
        case subscription
        case subscriptionEvent
        case subscriber
    }

    public enum ReportSubtype {
        case summary
        case detailed
        case optIn
    }
    
    public enum ReportVersion {
        case version1
    }
    
    public let frequency: Frequency
    public let reportType: ReportType
    public let reportSubtype: ReportSubtype
    public let vendorNumber: String
    public let version: ReportVersion
    
    public func makeParameters() -> [String: String] {
        var parameters: [String: String] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        switch frequency {
        case .daily(let optionalDate):
            parameters["filter[frequency]"] = "DAILY"
            if let date = optionalDate {
                parameters["filter[reportDate]"] = dateFormatter.string(from: date)
            }
        case .weekly(let date):
            parameters["filter[frequency]"] = "WEEKLY"
            parameters["filter[reportDate]"] = dateFormatter.string(from: date)
        case .monthly(let date):
            parameters["filter[frequency]"] = "MONTHLY"
            parameters["filter[reportDate]"] = dateFormatter.string(from: date)
        case .yearly(let date):
            parameters["filter[frequency]"] = "YEARLY"
            parameters["filter[reportDate]"] = dateFormatter.string(from: date)
        }

        switch reportType {
        case .sales:
            parameters["filter[reportType]"] = "SALES"
        case .preOrder:
            parameters["filter[reportType]"] = "PRE_ORDER"
        case .newsstand:
            parameters["filter[reportType]"] = "NEWSSTAND"
        case .subscription:
            parameters["filter[reportType]"] = "SUBSCRIPTION"
        case .subscriptionEvent:
            parameters["filter[reportType]"] = "SUBSCRIPTION_EVENT"
        case .subscriber:
            parameters["filter[reportType]"] = "SUBSCRIBER"
        }

        switch reportSubtype {
        case .summary:
            parameters["filter[reportSubType]"] = "SUMMARY"
        case .detailed:
            parameters["filter[reportSubType]"] = "DETAILED"
        case .optIn:
            parameters["filter[reportSubType]"] = "OPT_IN"
        }

        parameters["filter[vendorNumber]"] = vendorNumber
        
        switch version {
        case .version1:
            parameters["filter[version]"] = "1_0"
        }

        return parameters
    }
}
