//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct AppsResponse {

    public struct Links {
        public let selfReference: String
        public let related: String?
    }
    
    public struct DataElement {

        public struct Attributes {
            public let name: String
            public let bundleId: String
            public let sku: String
            public let primaryLocale: String
        }
        
        public struct Relationships {

            public struct BetaTesters {
                public let links: Links
            }

            public struct BetaGroups {
                public let links: Links
            }

            public struct PreReleaseVersions {
                public let links: Links
            }

            public struct BetaAppLocalizations {
                public let links: Links
            }

            public struct Builds {
                public let links: Links
            }

            public struct BetaLicenseAgreement {
                public let links: Links
            }

            public struct BetaAppReviewDetail {
                public let links: Links
            }

            public let betaTesters: BetaTesters
            public let betaGroups: BetaGroups
            public let preReleaseVersions: PreReleaseVersions
            public let betaAppLocalizations: BetaAppLocalizations
            public let builds: Builds
            public let betaLicenseAgreement: BetaLicenseAgreement
            public let betaAppReviewDetail: BetaAppReviewDetail
        }

        public let type: String
        public let id: String
        public let attributes: Attributes
        public let relationships: Relationships
        public let links: Links
    }

    public struct Meta {

        public struct Paging {
            public let total: Int
            public let limit: Int
        }

        public let paging: Paging
    }

    public let data: [DataElement]
    public let links: Links
    public let meta: Meta
}

// ---------------------------------------------------------------------------
// MARK: - Codable
// ---------------------------------------------------------------------------
        
extension AppsResponse: Codable {
        
    enum CodingKeys: String, CodingKey {
        case data
        case links
        case meta
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([DataElement].self, forKey: .data)
        links = try container.decode(Links.self, forKey: .links)
        meta = try container.decode(Meta.self, forKey: .meta)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(links, forKey: .links)
        try container.encode(meta, forKey: .meta)
    }
}
        
extension AppsResponse.DataElement: Codable {
        
    enum CodingKeys: String, CodingKey {
        case type
        case id
        case attributes
        case relationships
        case links
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)
        attributes = try container.decode(Attributes.self, forKey: .attributes)
        relationships = try container.decode(Relationships.self, forKey: .relationships)
        links = try container.decode(AppsResponse.Links.self, forKey: .links)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(attributes, forKey: .attributes)
        try container.encode(relationships, forKey: .relationships)
        try container.encode(links, forKey: .links)
    }
}
        
extension AppsResponse.DataElement.Attributes: Codable {
        
    enum CodingKeys: String, CodingKey {
        case name
        case bundleId
        case sku
        case primaryLocale
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        bundleId = try container.decode(String.self, forKey: .bundleId)
        sku = try container.decode(String.self, forKey: .sku)
        primaryLocale = try container.decode(String.self, forKey: .primaryLocale)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(bundleId, forKey: .bundleId)
        try container.encode(sku, forKey: .sku)
        try container.encode(primaryLocale, forKey: .primaryLocale)
    }
}
        
extension AppsResponse.DataElement.Relationships: Codable {
        
    enum CodingKeys: String, CodingKey {
        case betaTesters
        case betaGroups
        case preReleaseVersions
        case betaAppLocalizations
        case builds
        case betaLicenseAgreement
        case betaAppReviewDetail
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        betaTesters = try container.decode(BetaTesters.self, forKey: .betaTesters)
        betaGroups = try container.decode(BetaGroups.self, forKey: .betaGroups)
        preReleaseVersions = try container.decode(PreReleaseVersions.self, forKey: .preReleaseVersions)
        betaAppLocalizations = try container.decode(BetaAppLocalizations.self, forKey: .betaAppLocalizations)
        builds = try container.decode(Builds.self, forKey: .builds)
        betaLicenseAgreement = try container.decode(BetaLicenseAgreement.self, forKey: .betaLicenseAgreement)
        betaAppReviewDetail = try container.decode(BetaAppReviewDetail.self, forKey: .betaAppReviewDetail)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(betaTesters, forKey: .betaTesters)
        try container.encode(betaGroups, forKey: .betaGroups)
        try container.encode(preReleaseVersions, forKey: .preReleaseVersions)
        try container.encode(betaAppLocalizations, forKey: .betaAppLocalizations)
        try container.encode(builds, forKey: .builds)
        try container.encode(betaLicenseAgreement, forKey: .betaLicenseAgreement)
        try container.encode(betaAppReviewDetail, forKey: .betaAppReviewDetail)
    }
}
        
extension AppsResponse.DataElement.Relationships.BetaTesters: Codable {
        
    enum CodingKeys: String, CodingKey {
        case links
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        links = try container.decode(AppsResponse.Links.self, forKey: .links)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(links, forKey: .links)
    }
}
        
extension AppsResponse.Links: Codable {
        
    enum CodingKeys: String, CodingKey {
        case selfReference = "self"
        case related
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        selfReference = try container.decode(String.self, forKey: .selfReference)
        related = try container.decodeIfPresent(String.self, forKey: .related)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(selfReference, forKey: .selfReference)
        try container.encodeIfPresent(related, forKey: .related)
    }
}
        
extension AppsResponse.DataElement.Relationships.BetaGroups: Codable {
        
    enum CodingKeys: String, CodingKey {
        case links
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        links = try container.decode(AppsResponse.Links.self, forKey: .links)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(links, forKey: .links)
    }
}
        
extension AppsResponse.DataElement.Relationships.PreReleaseVersions: Codable {
        
    enum CodingKeys: String, CodingKey {
        case links
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        links = try container.decode(AppsResponse.Links.self, forKey: .links)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(links, forKey: .links)
    }
}
                
extension AppsResponse.DataElement.Relationships.BetaAppLocalizations: Codable {
        
    enum CodingKeys: String, CodingKey {
        case links
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        links = try container.decode(AppsResponse.Links.self, forKey: .links)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(links, forKey: .links)
    }
}

extension AppsResponse.DataElement.Relationships.Builds: Codable {
        
    enum CodingKeys: String, CodingKey {
        case links
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        links = try container.decode(AppsResponse.Links.self, forKey: .links)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(links, forKey: .links)
    }
}
                
extension AppsResponse.DataElement.Relationships.BetaLicenseAgreement: Codable {
        
    enum CodingKeys: String, CodingKey {
        case links
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        links = try container.decode(AppsResponse.Links.self, forKey: .links)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(links, forKey: .links)
    }
}
        
extension AppsResponse.DataElement.Relationships.BetaAppReviewDetail: Codable {
        
    enum CodingKeys: String, CodingKey {
        case links
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        links = try container.decode(AppsResponse.Links.self, forKey: .links)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(links, forKey: .links)
    }
}
        
extension AppsResponse.Meta: Codable {
        
    enum CodingKeys: String, CodingKey {
        case paging
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        paging = try container.decode(Paging.self, forKey: .paging)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(paging, forKey: .paging)
    }
}
        
extension AppsResponse.Meta.Paging: Codable {
        
    enum CodingKeys: String, CodingKey {
        case total
        case limit
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = try container.decode(Int.self, forKey: .total)
        limit = try container.decode(Int.self, forKey: .limit)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(total, forKey: .total)
        try container.encode(limit, forKey: .limit)
    }
}
