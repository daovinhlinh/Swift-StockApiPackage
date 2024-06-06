//
//  File.swift
//
//
//  Created by Đào Vĩnh Linh on 05/06/2024.
//

import Foundation

public struct TradingViewHistoryErrorResponse: Decodable {
    public let s: [String]?
    public let nextTime: [Double]?

    public init(s: [String]?, nextTime: [Double]?) {
        self.s = s
        self.nextTime = nextTime
    }
}

public struct TradingViewHistoryResponse: Decodable {
    public let data: TradingViewHistory?
    public let error: HttpStatusCodeFailedError?

    public init(from decoder: any Decoder) throws {
        if let historyData = try? decoder.singleValueContainer().decode(TradingViewHistory.self) {
            self.data = historyData
            self.error = nil
        } else if let errorResponse = try? decoder.singleValueContainer().decode(TradingViewHistoryErrorResponse.self) {
            self.data = nil
            self.error = .tradingViewHistoryErrorResponse(errorResponse)
        } else {
            self.data = nil
            self.error = nil
        }
    }
}

public struct TradingViewHistory: Codable {
    public let t: [Int]? // Timestamp when data points were recorded
    public let o, h, l, c: [Int]? // open/highest/lowest/close price
    public let v: [Int]? // trading volume
    public let s: String? // api status
    public let ce: [Int]? // extending closing prices

    public let fl: [Int]? // first low prices

    public let re: [Int]? //

    public let nextTime: Double?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.t = try container.decodeIfPresent([Int].self, forKey: .t)
        self.o = try container.decodeIfPresent([Int].self, forKey: .o)
        self.h = try container.decodeIfPresent([Int].self, forKey: .h)
        self.l = try container.decodeIfPresent([Int].self, forKey: .l)
        self.c = try container.decodeIfPresent([Int].self, forKey: .c)
        self.v = try container.decodeIfPresent([Int].self, forKey: .v)
        self.s = try container.decodeIfPresent(String.self, forKey: .s)
        self.ce = try container.decodeIfPresent([Int].self, forKey: .ce)
        self.fl = try container.decodeIfPresent([Int].self, forKey: .fl)
        self.re = try container.decodeIfPresent([Int].self, forKey: .re)
        self.nextTime = try container.decodeIfPresent(Double.self, forKey: .nextTime)
    }
}
