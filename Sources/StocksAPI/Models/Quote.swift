//
//  File.swift
//
//
//  Created by Đào Vĩnh Linh on 05/06/2024.
//

import Foundation

public struct QuoteResponse: Decodable {
    public let data: [Quote]?
    public let error: ErrorResponse?

    public init(from decoder: Decoder) throws {
        /**
            singleValueContainer: because response is single value (in this case is array). Use nestedContainer for other case
            decode: decode directly into Quote
         */
        do {
            let container = try decoder.singleValueContainer()
            if let quoteData = try? container.decode([Quote].self) {
                self.data = quoteData
                self.error = nil
            } else if let errorResponse = try? decoder.singleValueContainer().decode(ErrorResponse.self) {
                self.data = []
                self.error = errorResponse
            } else {
                self.data = []
                self.error = nil
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Data does not match [Quote] or ErrorResponse")
            }
        } catch let decodingError as DecodingError {
            // Handle specific decoding errors
            switch decodingError {
            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            case .valueNotFound(let type, let context):
                print("Value not found for type '\(type)':", context.debugDescription)
                print("codingPath:", context.codingPath)
            case .keyNotFound(let key, let context):
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            case .dataCorrupted(let context):
                print("Data corrupted:", context.debugDescription)
                print("codingPath:", context.codingPath)
            @unknown default:
                print("Unknown decoding error")
            }
            throw decodingError
        } catch {
            // Handle any other errors
            print("Unexpected error:", error)
            throw error
        }
    }
}

/**
    codable: used for encoding/decoding data, to easily serialize and deserialize to/from JSON
    identifiable: to uniquely identify each instance of a type
    hashable: provide hash value can be used for quickly comparing instances
 */

public struct Quote: Codable, Identifiable, Hashable {
    public let id = UUID()

    // Symbol of the stock.
    public let s: String?

    // Opening price, highest price, lowest price, and closing price.
    public let o, h, l, c: Double?

    // Change in price and change rate.
    public let ch: Double?
    public let r: Double?

    // Volume of shares traded, normalized volume, and total value of shares traded.
    public let vo, vonm, va: Int?

    // Average price of the stock.
    public let a: Double?

    // Timestamp in milliseconds and market value.
    public let ti, mv: Int?

    // Bid book, ask book, odd-lot bid book, and odd-lot ask book.
    public let bb, bo, bbOd, boOd: [Bb]?

    // Odd-lot trades: closing price, change in price, change rate, market value, volume, and value.
    public let odC, odCh, odR, odMv: Double?
    public let odVo, odVa: Int?

    // Foreign trade volumes and values.
    public let frBvo, frSvo, frBva, frSva, frTr, frCr, frVo, frVa: Int?

    // Session status (e.g., "INTERMISSION").
    public let ss: String?

    // Total bid orders volume, total odd-lot orders volume, additional bid orders volume, and additional odd-lot orders volume.
    public let tbo, too, abo, aoo: Int?

    // Additional bid count, additional odd-lot count, domestic bid orders volume.
    public let abc, aoc, dbo: Int?

    // Expected price, count, rate, and volume.
    public let ep, ec, er, ev: Double?

    // Bid earnings and best ask price.
    public let be, ba: Int?

    // Open interest, market bid orders volume, market sell orders volume, market buy and sell orders volume, and reference price.
    public let oi, mbo, mso, mbso, re: Double?

    // Historical dates: one day ago, three days ago, one week ago, one month ago, two months ago, three months ago, six months ago, one year ago.
    public let d1D, d3D, d1W, d1M, d2M, d3M, d6M, d1Y: String?

    // Historical closing prices: one day ago, three days ago, one week ago, one month ago, two months ago, three months ago, six months ago, one year ago.
    public let c1D, c3D, c1W, c1M, c2M, c3M, c6M, c1Y: Int?

    // Highest and lowest prices over various periods: one year, three days, one day, one month, two months, three months, six months.
    public let h1Y, l1Y, h3D, l3D, h1D, l1D, h1M, h2M, l1M, l2M, h3M, l3M, h6M, l6M: Int?

    // Sudden price drop indicator and volume of shares traded in the last 15 minutes.
    public let sud, vo15M: Int?

    // Average bid volumes over different periods: 5 days, 10 days, 20 days, 60 days.
    public let av5B, av10B, av20B, av60B: Double?

    // Average bid prices over different periods: 5 days, 10 days, 20 days, 60 days.
    public let a5B, a10B, a20B, a60B: Double?

    // General evaluation volume.
    public let gev: Int?

    // Total price and evaluation for the last 5 days.
    public let tp, ev5D: Double?

    public init(from decoder: any Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.s = try container.decodeIfPresent(String.self, forKey: .s)
            self.o = try container.decodeIfPresent(Double.self, forKey: .o)
            self.h = try container.decodeIfPresent(Double.self, forKey: .h)
            self.l = try container.decodeIfPresent(Double.self, forKey: .l)
            self.c = try container.decodeIfPresent(Double.self, forKey: .c)
            self.ch = try container.decodeIfPresent(Double.self, forKey: .ch)
            self.r = try container.decodeIfPresent(Double.self, forKey: .r)
            self.vo = try container.decodeIfPresent(Int.self, forKey: .vo)
            self.vonm = try container.decodeIfPresent(Int.self, forKey: .vonm)
            self.va = try container.decodeIfPresent(Int.self, forKey: .va)
            self.a = try container.decodeIfPresent(Double.self, forKey: .a)
            self.ti = try container.decodeIfPresent(Int.self, forKey: .ti)
            self.mv = try container.decodeIfPresent(Int.self, forKey: .mv)
            self.bb = try container.decodeIfPresent([Bb].self, forKey: .bb)
            self.bo = try container.decodeIfPresent([Bb].self, forKey: .bo)
            self.bbOd = try container.decodeIfPresent([Bb].self, forKey: .bbOd)
            self.boOd = try container.decodeIfPresent([Bb].self, forKey: .boOd)
            self.odC = try container.decodeIfPresent(Double.self, forKey: .odC)
            self.odCh = try container.decodeIfPresent(Double.self, forKey: .odCh)
            self.odR = try container.decodeIfPresent(Double.self, forKey: .odR)
            self.odMv = try container.decodeIfPresent(Double.self, forKey: .odMv)
            self.odVo = try container.decodeIfPresent(Int.self, forKey: .odVo)
            self.odVa = try container.decodeIfPresent(Int.self, forKey: .odVa)
            self.frBvo = try container.decodeIfPresent(Int.self, forKey: .frBvo)
            self.frSvo = try container.decodeIfPresent(Int.self, forKey: .frSvo)
            self.frBva = try container.decodeIfPresent(Int.self, forKey: .frBva)
            self.frSva = try container.decodeIfPresent(Int.self, forKey: .frSva)
            self.frTr = try container.decodeIfPresent(Int.self, forKey: .frTr)
            self.frCr = try container.decodeIfPresent(Int.self, forKey: .frCr)
            self.frVo = try container.decodeIfPresent(Int.self, forKey: .frVo)
            self.frVa = try container.decodeIfPresent(Int.self, forKey: .frVa)
            self.ss = try container.decodeIfPresent(String.self, forKey: .ss)
            self.tbo = try container.decodeIfPresent(Int.self, forKey: .tbo)
            self.too = try container.decodeIfPresent(Int.self, forKey: .too)
            self.abo = try container.decodeIfPresent(Int.self, forKey: .abo)
            self.aoo = try container.decodeIfPresent(Int.self, forKey: .aoo)
            self.abc = try container.decodeIfPresent(Int.self, forKey: .abc)
            self.aoc = try container.decodeIfPresent(Int.self, forKey: .aoc)
            self.dbo = try container.decodeIfPresent(Int.self, forKey: .dbo)
            self.ep = try container.decodeIfPresent(Double.self, forKey: .ep)
            self.ec = try container.decodeIfPresent(Double.self, forKey: .ec)
            self.er = try container.decodeIfPresent(Double.self, forKey: .er)
            self.ev = try container.decodeIfPresent(Double.self, forKey: .ev)
            self.be = try container.decodeIfPresent(Int.self, forKey: .be)
            self.ba = try container.decodeIfPresent(Int.self, forKey: .ba)
            self.oi = try container.decodeIfPresent(Double.self, forKey: .oi)
            self.mbo = try container.decodeIfPresent(Double.self, forKey: .mbo)
            self.mso = try container.decodeIfPresent(Double.self, forKey: .mso)
            self.mbso = try container.decodeIfPresent(Double.self, forKey: .mbso)
            self.re = try container.decodeIfPresent(Double.self, forKey: .re)
            self.d1D = try container.decodeIfPresent(String.self, forKey: .d1D)
            self.d3D = try container.decodeIfPresent(String.self, forKey: .d3D)
            self.d1W = try container.decodeIfPresent(String.self, forKey: .d1W)
            self.d1M = try container.decodeIfPresent(String.self, forKey: .d1M)
            self.d2M = try container.decodeIfPresent(String.self, forKey: .d2M)
            self.d3M = try container.decodeIfPresent(String.self, forKey: .d3M)
            self.d6M = try container.decodeIfPresent(String.self, forKey: .d6M)
            self.d1Y = try container.decodeIfPresent(String.self, forKey: .d1Y)
            self.c1D = try container.decodeIfPresent(Int.self, forKey: .c1D)
            self.c3D = try container.decodeIfPresent(Int.self, forKey: .c3D)
            self.c1W = try container.decodeIfPresent(Int.self, forKey: .c1W)
            self.c1M = try container.decodeIfPresent(Int.self, forKey: .c1M)
            self.c2M = try container.decodeIfPresent(Int.self, forKey: .c2M)
            self.c3M = try container.decodeIfPresent(Int.self, forKey: .c3M)
            self.c6M = try container.decodeIfPresent(Int.self, forKey: .c6M)
            self.c1Y = try container.decodeIfPresent(Int.self, forKey: .c1Y)
            self.h1Y = try container.decodeIfPresent(Int.self, forKey: .h1Y)
            self.l1Y = try container.decodeIfPresent(Int.self, forKey: .l1Y)
            self.h3D = try container.decodeIfPresent(Int.self, forKey: .h3D)
            self.l3D = try container.decodeIfPresent(Int.self, forKey: .l3D)
            self.h1D = try container.decodeIfPresent(Int.self, forKey: .h1D)
            self.l1D = try container.decodeIfPresent(Int.self, forKey: .l1D)
            self.h1M = try container.decodeIfPresent(Int.self, forKey: .h1M)
            self.h2M = try container.decodeIfPresent(Int.self, forKey: .h2M)
            self.l1M = try container.decodeIfPresent(Int.self, forKey: .l1M)
            self.l2M = try container.decodeIfPresent(Int.self, forKey: .l2M)
            self.h3M = try container.decodeIfPresent(Int.self, forKey: .h3M)
            self.l3M = try container.decodeIfPresent(Int.self, forKey: .l3M)
            self.h6M = try container.decodeIfPresent(Int.self, forKey: .h6M)
            self.l6M = try container.decodeIfPresent(Int.self, forKey: .l6M)
            self.sud = try container.decodeIfPresent(Int.self, forKey: .sud)
            self.vo15M = try container.decodeIfPresent(Int.self, forKey: .vo15M)
            self.av5B = try container.decodeIfPresent(Double.self, forKey: .av5B)
            self.av10B = try container.decodeIfPresent(Double.self, forKey: .av10B)
            self.av20B = try container.decodeIfPresent(Double.self, forKey: .av20B)
            self.av60B = try container.decodeIfPresent(Double.self, forKey: .av60B)
            self.a5B = try container.decodeIfPresent(Double.self, forKey: .a5B)
            self.a10B = try container.decodeIfPresent(Double.self, forKey: .a10B)
            self.a20B = try container.decodeIfPresent(Double.self, forKey: .a20B)
            self.a60B = try container.decodeIfPresent(Double.self, forKey: .a60B)
            self.gev = try container.decodeIfPresent(Int.self, forKey: .gev)
            self.tp = try container.decodeIfPresent(Double.self, forKey: .tp)
            self.ev5D = try container.decodeIfPresent(Double.self, forKey: .ev5D)
        } catch {
            print(error)
            throw error
        }
    }

    public init(s: String?, o: Double?, h: Double?, l: Double?, c: Double?, ch: Double?, r: Double?, vo: Int?, vonm: Int?, va: Int?, a: Double?, ti: Int?, mv: Int?, bb: [Bb]?, bo: [Bb]?, bbOd: [Bb]?, boOd: [Bb]?, odC: Double?, odCh: Double?, odR: Double?, odMv: Double?, odVo: Int?, odVa: Int?, frBvo: Int?, frSvo: Int?, frBva: Int?, frSva: Int?, frTr: Int?, frCr: Int?, frVo: Int?, frVa: Int?, ss: String?, tbo: Int?, too: Int?, abo: Int?, aoo: Int?, abc: Int?, aoc: Int?, dbo: Int?, ep: Double?, ec: Double?, er: Double?, ev: Double?, be: Int?, ba: Int?, oi: Double?, mbo: Double?, mso: Double?, mbso: Double?, re: Double?, d1D: String?, d3D: String?, d1W: String?, d1M: String?, d2M: String?, d3M: String?, d6M: String?, d1Y: String?, c1D: Int?, c3D: Int?, c1W: Int?, c1M: Int?, c2M: Int?, c3M: Int?, c6M: Int?, c1Y: Int?, h1Y: Int?, l1Y: Int?, h3D: Int?, l3D: Int?, h1D: Int?, l1D: Int?, h1M: Int?, h2M: Int?, l1M: Int?, l2M: Int?, h3M: Int?, l3M: Int?, h6M: Int?, l6M: Int?, sud: Int?, vo15M: Int?, av5B: Double?, av10B: Double?, av20B: Double?, av60B: Double?, a5B: Double?, a10B: Double?, a20B: Double?, a60B: Double?, gev: Int?, tp: Double?, ev5D: Double?) {
        self.s = s
        self.o = o
        self.h = h
        self.l = l
        self.c = c
        self.ch = ch
        self.r = r
        self.vo = vo
        self.vonm = vonm
        self.va = va
        self.a = a
        self.ti = ti
        self.mv = mv
        self.bb = bb
        self.bo = bo
        self.bbOd = bbOd
        self.boOd = boOd
        self.odC = odC
        self.odCh = odCh
        self.odR = odR
        self.odMv = odMv
        self.odVo = odVo
        self.odVa = odVa
        self.frBvo = frBvo
        self.frSvo = frSvo
        self.frBva = frBva
        self.frSva = frSva
        self.frTr = frTr
        self.frCr = frCr
        self.frVo = frVo
        self.frVa = frVa
        self.ss = ss
        self.tbo = tbo
        self.too = too
        self.abo = abo
        self.aoo = aoo
        self.abc = abc
        self.aoc = aoc
        self.dbo = dbo
        self.ep = ep
        self.ec = ec
        self.er = er
        self.ev = ev
        self.be = be
        self.ba = ba
        self.oi = oi
        self.mbo = mbo
        self.mso = mso
        self.mbso = mbso
        self.re = re
        self.d1D = d1D
        self.d3D = d3D
        self.d1W = d1W
        self.d1M = d1M
        self.d2M = d2M
        self.d3M = d3M
        self.d6M = d6M
        self.d1Y = d1Y
        self.c1D = c1D
        self.c3D = c3D
        self.c1W = c1W
        self.c1M = c1M
        self.c2M = c2M
        self.c3M = c3M
        self.c6M = c6M
        self.c1Y = c1Y
        self.h1Y = h1Y
        self.l1Y = l1Y
        self.h3D = h3D
        self.l3D = l3D
        self.h1D = h1D
        self.l1D = l1D
        self.h1M = h1M
        self.h2M = h2M
        self.l1M = l1M
        self.l2M = l2M
        self.h3M = h3M
        self.l3M = l3M
        self.h6M = h6M
        self.l6M = l6M
        self.sud = sud
        self.vo15M = vo15M
        self.av5B = av5B
        self.av10B = av10B
        self.av20B = av20B
        self.av60B = av60B
        self.a5B = a5B
        self.a10B = a10B
        self.a20B = a20B
        self.a60B = a60B
        self.gev = gev
        self.tp = tp
        self.ev5D = ev5D
    }
}

// MARK: - Bb

public struct Bb: Codable, Hashable {
    public let p, v: Double

    public init(p: Double, v: Double) {
        self.p = p
        self.v = v
    }
}
