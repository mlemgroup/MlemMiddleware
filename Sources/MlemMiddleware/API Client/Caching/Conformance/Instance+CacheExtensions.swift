//
//  Instance+CacheExtensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-02.
//

import Foundation

extension Instance1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with site: ApiSite) {
        displayName = site.name
        description = site.sidebar
        shortDescription = site.description
        avatar = site.icon
        banner = site.banner
        lastRefresh = site.lastRefreshedAt
        contentWarning = site.contentWarning
    }
}

extension Instance2: CacheIdentifiable {
    public var cacheId: Int { instance1.cacheId }
    
    func update(with siteView: ApiSiteView) {
        instance1.update(with: siteView.site)
    }
}

extension Instance3: CacheIdentifiable {
    public var cacheId: Int { instance2.cacheId }
    
    func update(with response: ApiGetSiteResponse) {
        version = SiteVersion(response.version)
        instance2.update(with: response.siteView)
    }
}
