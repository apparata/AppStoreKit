//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation
import AppStoreKit
import Combine

// Replace with actual values
private let myAppManagerKey = AppStoreKey(
    id: "ABC12DEFGH",
    path: "MyAuthKey.p8",
    issuerID: "abcdef12-a34b-5678-abcd-1ab2c3456789")

// Replace with actual values
private let myFinanceKey = AppStoreKey(
    id: "ABC12DEFGH",
    path: "MyAuthKey.p8",
    issuerID: "abcdef12-a34b-5678-abcd-1ab2c3456789")

// Replace with actual value
private let myVendorNumber = "81234567"

var cancellable: AnyCancellable?

func listApps(key: AppStoreKey, vendor: String) throws {
        
    guard let appStoreKeyString = try? String(contentsOfFile: key.path, encoding: .utf8) else {
        throw AppStoreServiceError.missingKey
    }
    let appStoreKey = try PKCS8(string: appStoreKeyString)
    let apiConfiguration = AppStoreAPIConfiguration(privateKeyID: key.id,
                                                    issuerID: key.issuerID,
                                                    privateKey: appStoreKey,
                                                    vendorID: vendor)

    let appStoreService = AppStoreService(configuration: apiConfiguration)
    
    cancellable = try appStoreService.apps()
        .sink(receiveCompletion: {
            if case .failure(let error) = $0 {
                print("Error: \(error.localizedDescription)")
            }
        }, receiveValue: {
            dump($0)
        })
}

func fetchFinancialReports(key: AppStoreKey, vendor: String) throws {
    
    guard let appStoreKeyString = try? String(contentsOfFile: key.path, encoding: .utf8) else {
        throw AppStoreServiceError.missingKey
    }
    let appStoreKey = try PKCS8(string: appStoreKeyString)
    let apiConfiguration = AppStoreAPIConfiguration(privateKeyID: key.id,
                                                    issuerID: key.issuerID,
                                                    privateKey: appStoreKey,
                                                    vendorID: vendor)
    
    let appStoreService = AppStoreService(configuration: apiConfiguration)
        
    cancellable = try appStoreService.financialReports(region: .ZZ,
                                                       period: .october(2019))
        .sink(receiveCompletion: {
            if case .failure(let error) = $0 {
                print("Error: \(error.localizedDescription)")
            }
        }, receiveValue: {
            dump($0)
        })
}

try listApps(key: myAppManagerKey, vendor: myVendorNumber)
try fetchFinancialReports(key: myFinanceKey, vendor: myVendorNumber)

RunLoop.main.run()
