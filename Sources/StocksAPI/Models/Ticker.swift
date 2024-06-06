//
//  Ticker.swift
//
//
//  Created by Đào Vĩnh Linh on 05/06/2024.
//
//  Search quote model

import Foundation

public struct Ticker: Codable, Identifiable, Hashable, Equatable {
    public let id = UUID()
    
    public let s: String?
    
    public let a: Double?
    
    public let r: Double?
}
