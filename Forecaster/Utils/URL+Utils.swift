//
//  URL+Utils.swift
//  SkyPac
//
//  Created by Vrana, Jozef on 26/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

extension URL {
    
    func addURLParameters(items: [String:String?]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return self.absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        for (_, itemValue) in items.enumerated() {
            let queryItem = URLQueryItem(name: itemValue.key, value: itemValue.value)
            queryItems.append(queryItem)
        }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return self.absoluteURL }
        
        return url
    }
}

