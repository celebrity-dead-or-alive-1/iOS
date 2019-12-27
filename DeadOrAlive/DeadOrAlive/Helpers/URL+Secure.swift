//
//  URL+Secure.swift
//  DeadOrAlive
//
//  Created by morse on 12/26/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

extension URL {
    var usingHTTPS: URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        components.scheme = "https"
        return components.url
    }
}
