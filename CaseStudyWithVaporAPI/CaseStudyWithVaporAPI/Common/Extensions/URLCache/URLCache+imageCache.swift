//
//  URLCache+imageCache.swift
//  CaseStudyWithVaporAPI
//
//  Created by ROBIN HUMNE on 09/06/25.
//

import Foundation

extension URLCache {
    
    static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 10_000_000_000)
}
