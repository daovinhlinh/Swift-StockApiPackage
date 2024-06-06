//
//  File.swift
//  
//
//  Created by Đào Vĩnh Linh on 05/06/2024.
//

import Foundation

public struct ErrorResponse: Codable {
    public let code: String?
    public let params: String?
    public let isSystemError: Bool?
    
    public init(code: String?, params: String?, isSystemError: Bool?) {
        self.code = code
        self.params = params
        self.isSystemError = isSystemError
    }
}
