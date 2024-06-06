//
//  File.swift
//
//
//  Created by Đào Vĩnh Linh on 06/06/2024.
//

import Foundation

public struct SymbolListResponse: Decodable {
    public let data: [Symbol]?
    public let error: HttpStatusCodeFailedError?

    enum CodingKeys: CodingKey {
        case data
        case error
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let symbolListData = try? container.decode([Symbol].self) {
            self.data = symbolListData
            self.error = nil
        } else if let errorResponse = try? decoder.singleValueContainer().decode(ErrorResponse.self) {
            self.data = []
            self.error = .errorResponse(errorResponse)
        } else {
            self.data = []
            self.error = nil
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Data does not match [Quote] or ErrorResponse")
        }
    }
}

// MARK: - SymbolElement

public struct Symbol: Codable, Hashable, Identifiable {
    public let id = UUID()

    public let s: String?
    public let m: M?
    public let n1, n2: String?
    public let t: T?
    public let re: Double?
    public let i: Bool?
    public let ce, fl: Int?
    public let mEx: MEx?
    public let md, b: String?
    public let cwt: Cwt?
    public let exp, fv: Int?
    public let exr, ltd: String?
    public let symbolIs: Is?
    public let isd: String?
    public let ie: Bool?

    public enum CodingKeys: String, CodingKey {
        case s, m, n1, n2, t, re, i, ce, fl
        case mEx = "m_ex"
        case md, b, cwt, exp, fv, exr, ltd
        case symbolIs = "is"
        case isd, ie
    }

    public init(s: String?, m: M?, n1: String?, n2: String?, t: T?, re: Double?, i: Bool?, ce: Int?, fl: Int?, mEx: MEx?, md: String?, b: String?, cwt: Cwt?, exp: Int?, fv: Int?, exr: String?, ltd: String?, symbolIs: Is?, isd: String?, ie: Bool?) {
        self.s = s
        self.m = m
        self.n1 = n1
        self.n2 = n2
        self.t = t
        self.re = re
        self.i = i
        self.ce = ce
        self.fl = fl
        self.mEx = mEx
        self.md = md
        self.b = b
        self.cwt = cwt
        self.exp = exp
        self.fv = fv
        self.exr = exr
        self.ltd = ltd
        self.symbolIs = symbolIs
        self.isd = isd
        self.ie = ie
    }
}

public enum Cwt: String, Codable, Hashable {
    case c = "C"
}

public enum M: String, Codable, Hashable {
    case hnx = "HNX"
    case hose = "HOSE"
    case upcom = "UPCOM"
}

public enum MEx: String, Codable, Hashable {
    case hnx30 = "HNX30"
    case vn100 = "VN100"
    case vn30 = "VN30"
}

public enum Is: String, Codable, Hashable {
    case acbs = "ACBS"
    case bsc = "BSC"
    case hsc = "HSC"
    case kis = "KIS"
    case ssi = "SSI"
    case vcsc = "VCSC"
    case vnd = "VND"
    case vpbanks = "VPBANKS"
}

public enum T: String, Codable, Hashable {
    case cw = "CW"
    case etf = "ETF"
    case fund = "FUND"
    case index = "INDEX"
    case stock = "STOCK"
}
