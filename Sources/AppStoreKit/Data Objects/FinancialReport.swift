//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct FinancialReport {
    
    public enum SalesOrReturns {
        case sales
        case returns
    }
    
    public struct DetailsEntry: Identifiable {
        
        public let id = UUID()
        
        /// Start Date
        ///
        /// - MM/DD/YYYY
        ///
        /// This is the period start date, based on Apple’s fiscal calendar.
        public let startDate: String

        /// End Date
        ///
        /// - MM/DD/YYYY
        ///
        /// This is the period end date, based on Apple’s fiscal calendar.
        public let endDate: String

        /// ISRC/ISBN
        ///
        /// - Up to 20 characters
        ///
        /// For apps, this is your SKU.
        /// For in-app purchases, this is the product ID.
        ///
        /// (NOTE: Seems to be blank?)
        public let isrcISBN: String?

        /// Vendor Identifier
        ///
        /// - Up to 20 characters
        ///
        /// For apps, this is your SKU.
        /// For in-app purchases, this is the product ID.
        public let vendorIdentifier: String

        /// Quantity
        ///
        /// - Number with no decimal places (positive or negative)
        ///
        /// Aggregated number of units sold.
        public let quantity: Int

        /// Partner Share
        ///
        /// - Number with two decimal places (always positive)
        ///
        /// The proceeds you receive per unit. This is the Customer Price minus
        /// applicable taxes and Apple’s commission, per Schedule 2 of your
        /// Paid Applications agreement.
        public let partnerShare: Decimal
        public let partnerShareString: String

        /// Extended Partner Share
        ///
        /// - Number with two decimal places (positive or negative)
        ///
        /// Quantity multiplied by Partner Share.
        public let extendedPartnerShare: Decimal
        public let extendedPartnerShareString: String

        /// Partner Share Currency
        ///
        /// - Three characters
        ///
        /// Three-character ISO code for the currency of the amounts earned.
        public let partnerShareCurrency: String

        /// Sales or Returns
        public let salesOrReturns: SalesOrReturns

        /// Apple Identifier
        ///
        /// - Up to 18 characters
        ///
        /// Apple ID, a unique identifier automatically generated for your app
        /// when you add the app to your account. You can view this property in
        /// the App Information section in App Store Connect. This identifier
        /// is also used in the URL for the App Store on desktop computers. You
        /// can’t edit this property.
        public let appleIdentifier: String

        /// Artist/Show/Developer/Author
        ///
        /// - Up to 1000 characters
        ///
        /// Your legal entity name.
        public let developer: String

        /// Title
        ///
        /// - Up to 5000 characters
        ///
        /// The name you entered for your app as described in App information.
        public let title: String

        /// Product Type Identifier
        ///
        /// - Up to five characters
        ///
        /// The type of product purchased.
        public let productTypeIdentifier: ProductTypeIdentifier
        public let productTypeIdentifierString: String

        /// Country Of Sale
        ///
        /// - Two characters
        ///
        /// Two-character ISO code (such as US for the United States) that
        /// indicates the country or region for the App Store where the
        /// purchase occurred.
        public let countryOfSale: String

        /// Pre-order Flag
        ///
        /// - "P" or null
        public let isPreOrder: Bool

        /// Promo Code
        ///
        /// - Up to 10 characters
        ///
        /// If the transaction was part of a promotion, a gift, or was
        /// downloaded through the Volume Purchase Program for Education, this
        /// field will contain a value. This field is empty for all
        /// non-promotional items.
        public let promoCode: String?

        /// Customer Price
        ///
        /// - Number with 2 decimal places (positive or negative)
        ///
        /// The price per unit billed to the customer, which you set for your
        /// app or in-app purchase in App Store Connect. Customer price is
        /// inclusive of any applicable taxes we collect and remit per
        /// Schedule 2 of the Paid Applications agreement.
        public let customerPrice: Decimal
        public let customerPriceString: String
        
        /// Customer Currency
        ///
        /// - Three characters
        ///
        /// Three-character ISO code for the currency type paid by the
        /// customer. For example, USD for United States Dollar.
        public let currency: String
        
        private let row: [String: String]
        
        init(row: [String: String]) throws {
            self.row = row
            
            func value(_ key: String) throws -> String {
                guard let value = row[key] else {
                    throw AppStoreServiceError.invalidData
                }
                return value
            }

            startDate = try value("Start Date")
            endDate = try value("End Date")
            isrcISBN = row["ISRC/ISBN"]
            vendorIdentifier = try value("Vendor Identifier")
            guard let quantityValue = Int(try value("Quantity")) else {
                throw AppStoreServiceError.invalidData
            }
            quantity = quantityValue
            partnerShare = try Money.amount(from: try value("Partner Share"))
            partnerShareString = try value("Partner Share")
            extendedPartnerShare = try Money.amount(from: try value("Extended Partner Share"))
            extendedPartnerShareString = try value("Extended Partner Share")
            partnerShareCurrency = try value("Partner Share Currency")
            salesOrReturns = row["Sales or Return"] == "S" ? .sales : .returns
            appleIdentifier = try value("Apple Identifier")
            developer = try value("Artist/Show/Developer/Author")
            title = try value("Title")
            productTypeIdentifier = ProductTypeIdentifier(try value("Product Type Identifier"))
            productTypeIdentifierString = try value("Product Type Identifier")
            countryOfSale = try value("Country Of Sale")
            isPreOrder = row["Pre-order Flag"] == "P"
            promoCode = row["Promo Code"]
            customerPrice = try Money.amount(from: try value("Customer Price"))
            customerPriceString = try value("Customer Price")
            currency = try value("Customer Currency")
        }
    }
    
    public struct SummaryEntry: Identifiable, Hashable {
        
         public let id = UUID()
        
        /// Country Of Sale
        ///
        /// - Two characters
        ///
        /// Two-character ISO code (such as US for the United States) that
        /// indicates the country or region for the App Store where the
        /// purchase occurred.
        public let countryOfSale: String
        
        /// Partner Share Currency
        ///
        /// - Three characters
        ///
        /// Three-character ISO code for the currency of the amounts earned.
        public let partnerShareCurrency: String

        /// Quantity
        ///
        /// - Number with no decimal places (positive or negative)
        ///
        /// Aggregated number of units sold.
        public let quantity: Int
        
        /// Extended Partner Share
        ///
        /// - Number with two decimal places (positive or negative)
        ///
        /// Quantity multiplied by Partner Share.
        public let extendedPartnerShare: Decimal
        public let extendedPartnerShareString: String

        private let row: [String: String]
        
        init(row: [String: String]) throws {
            self.row = row
            
            func value(_ key: String) throws -> String {
                guard let value = row[key] else {
                    throw AppStoreServiceError.invalidData
                }
                return value
            }
            
            countryOfSale = try value("Country Of Sale")
            partnerShareCurrency = try value("Partner Share Currency")
            guard let quantityValue = Int(try value("Quantity")) else {
                throw AppStoreServiceError.invalidData
            }
            quantity = quantityValue
            extendedPartnerShare = try Money.amount(from: try value("Extended Partner Share"))
            extendedPartnerShareString = try value("Extended Partner Share")
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(countryOfSale)
            hasher.combine(partnerShareCurrency)
            hasher.combine(quantity)
            hasher.combine(extendedPartnerShare)
        }
    }
    
    public let region: RegionCode
    public let period: FiscalPeriod
    public let vendor: String
    
    public let details: [DetailsEntry]
    public let summary: [SummaryEntry]
    
    private let detailsCSV: CSV
    private let summaryCSV: CSV
    
    public init(region: RegionCode, period: FiscalPeriod, vendor: String, data: Data) throws {
        
        self.region = region
        self.period = period
        self.vendor = vendor
        
        guard let string = String(data: data, encoding: .utf8) else {
            throw AppStoreServiceError.invalidData
        }
        
        let scanner = Scanner(string: string)
        guard let detailsString = scanner.scanUpToString("Total_Rows") else {
            throw AppStoreServiceError.invalidData
        }
        guard scanner.scanUpToString("Country Of Sale") != nil else {
            throw AppStoreServiceError.invalidData
        }
        guard let summaryString = scanner.scanCharacters(from: CharacterSet().inverted) else {
            throw AppStoreServiceError.invalidData
        }
                
        detailsCSV = CSV(string: detailsString, separator: "\t")
        details = try detailsCSV.keyedRows.map(DetailsEntry.init)
        
        summaryCSV = CSV(string: summaryString, separator: "\t")
        summary = try detailsCSV.keyedRows.map(SummaryEntry.init)
    }
}
