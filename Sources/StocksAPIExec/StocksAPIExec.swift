//
//  File.swift
//
//
//  Created by Đào Vĩnh Linh on 05/06/2024.
//

// import Foundation
// import StocksAPI
//
// @main // entry point for executable target
// struct StocksAPIExec {
//    static func main() async {
//        do {
//            let (data, _) = try! await URLSession.shared.data(from: URL(string: "https://wts.finavi.com.vn/api/v1/market/listSymbol?symbolList=AAA,ACB")!)
//
//            let quoteResponse = try JSONDecoder().decode(QuoteResponse.self, from: data)
//
//            print(quoteResponse)
//        } catch {
//            print("Error decoding JSON", error)
//        }
//    }
// }
//

//
//  File.swift
//
//
//  Created by Đào Vĩnh Linh on 05/06/2024.
//

import Foundation
import StocksAPI

@main // entry point for executable target
struct StocksAPIExec {
    static let stocksAPI = StocksAPI()
    static func main() async {
        do {
//            let quotes = try await stocksAPI.fetchQuotes(symbols: "AAA,ACB,TPB,TCB")
            let symbol = try await stocksAPI.fetchAllQuotes()
            print(symbol.count)
        } catch {
            print(error)
        }
    }
}
