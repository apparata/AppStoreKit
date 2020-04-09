//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public typealias FiscalYear = Int

public enum FiscalPeriod: Hashable {
    case january(FiscalYear)
    case february(FiscalYear)
    case march(FiscalYear)
    case april(FiscalYear)
    case may(FiscalYear)
    case june(FiscalYear)
    case july(FiscalYear)
    case august(FiscalYear)
    case september(FiscalYear)
    case october(FiscalYear)
    case november(FiscalYear)
    case december(FiscalYear)
    
    public var formatted: String {
        switch self {
        case .january(let year): return "\(year)-04"
        case .february(let year): return "\(year)-05"
        case .march(let year): return "\(year)-06"
        case .april(let year): return "\(year)-07"
        case .may(let year): return "\(year)-08"
        case .june(let year): return "\(year)-09"
        case .july(let year): return "\(year)-10"
        case .august(let year): return "\(year)-11"
        case .september(let year): return "\(year)-12"
        case .october(let year): return "\(year)-01"
        case .november(let year): return "\(year)-02"
        case .december(let year): return "\(year)-03"
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(formatted)
    }
}
