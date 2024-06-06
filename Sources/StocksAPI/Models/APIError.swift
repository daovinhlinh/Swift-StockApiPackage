//
//  File.swift
//
//
//  Created by Đào Vĩnh Linh on 05/06/2024.
//

/**
    CustomNSError: need to implement 3 properties
        - static var errorDomain: string - The domain of the error, which is typically a reverse-DNS string unique to your application or library.
        - var errorCode: Int - The error code that identifies the error within the specified domain
        - var errorUserInfo: [String: Any]:  A dictionary containing additional information about the error.
 */

import Foundation

public enum HttpStatusCodeFailedError {
    case errorResponse(ErrorResponse)
    case tradingViewHistoryErrorResponse(TradingViewHistoryErrorResponse)
}

public enum APIError: CustomNSError {
    case invalidURL
    case invalidResponseType
    case httpStatusCodeFailed(statusCode: Int, error: HttpStatusCodeFailedError?)

    public static var errorDomain: String {
        "StocksAPI"
    }

    public var errorCode: Int {
        switch self {
        case .invalidURL: return 0
        case .invalidResponseType: return 1
        case .httpStatusCodeFailed: return 2
        }
    }

    public var errorUserInfo: [String: Any] {
        let text: String
        switch self {
        case .invalidURL:
            text = "Invalid URL"
        case .invalidResponseType:
            text = "Invalid Response Type"
        case .httpStatusCodeFailed(let statusCode, let error):
            if let error = error {
                switch error {
                case .errorResponse(let response):
                    text = "Error: Status Code: \(statusCode), ErrorResponse: \(response)"
                case .tradingViewHistoryErrorResponse(let historyResponse):
                    text = "Error: Status Code: \(statusCode), TradingViewHistoryErrorResponse: \(historyResponse)"
                }
            } else {
                text = "Error: Status  Code \(statusCode)"
            }
        }
        return [NSLocalizedDescriptionKey: text]
    }
}
