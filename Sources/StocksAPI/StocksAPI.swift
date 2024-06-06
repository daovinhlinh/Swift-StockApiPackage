import Foundation

public struct StocksAPI {
    public private(set) var text = "Hello World"
    private let session = URLSession.shared
    private let jsonDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970 // Used to decode response have this date type
        return decoder
    }()
    
    private let baseURL = "https://wts.finavi.com.vn"
    
    //  ===================================QUOTE===================================
    /**
            To get data from list of symbols like: AAA,ACB,TCB (no space between comma)
     */
    public func fetchQuotes(symbols: String) async throws -> [Quote] {
        guard var urlComponent = URLComponents(string: "\(baseURL)/api/v1/market/listSymbol") else {
            throw APIError.invalidURL
        }
        
        urlComponent.queryItems = [URLQueryItem(name: "symbolList", value: symbols)] // add params to request
        
        guard let url = urlComponent.url else {
            throw APIError.invalidURL
        }

        let (response, statusCode): (QuoteResponse, Int) = try await fetch(url: url)

        if let error = response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: .errorResponse(error))
        }
        
        return response.data ?? []
    }
    
    public func fetchAllQuotes() async throws -> [Symbol] {
        guard let url = URL(string: "\(baseURL)/s3/market/symbol.json") else {
            throw APIError.invalidURL
        }
        
        let (response, statusCode): (SymbolListResponse, Int) = try await fetch(url: url)
        if let error = response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        
        return response.data ?? []
    }
    
    public func fetchQuoteTradeHistory(symbol: String, range: ChartRange, from: String, to: String) async throws -> TradingViewHistory? {
        guard var urlComponent = URLComponents(string: "\(baseURL)/api/v1/tradingview/history") else {
            throw APIError.invalidURL
        }
        
        urlComponent.queryItems = [
            .init(name: "symbol", value: symbol),
            .init(name: "resolution", value: range.resolution),
            .init(name: "from", value: from),
            .init(name: "to", value: to)
        ]
        
        guard let url = urlComponent.url else {
            throw APIError.invalidURL
        }
        
        let (response, statusCode): (TradingViewHistoryResponse, Int) = try await fetch(url: url)
        
        if let error = response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        
        return response.data ?? nil
    }
    
    //  ===================================QUOTE===================================

    public init() {}
    
    /**
     - Params: url
     - Response
        - D: Decodable
        - Int: http response status code
     */
    private func fetch<D: Decodable>(url: URL) async throws -> (D, Int) {
        let (data, response) = try await session.data(from: url) // data: JSON, response: response metadata (status code, header,...)
        
        let statusCode = try validateHttpResponse(response)
        return try (jsonDecoder.decode(D.self, from: data), statusCode)
    }
    
    // Get response status code
    private func validateHttpResponse(_ response: URLResponse) throws -> Int {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponseType
        }
        
        // Check if statusCode in range
        guard 200...299 ~= httpResponse.statusCode ||
            400...499 ~= httpResponse.statusCode
        else {
            throw APIError.httpStatusCodeFailed(statusCode: httpResponse.statusCode, error: nil) // error = nil because api response not return error
        }
        
        return httpResponse.statusCode
    }
}
