//
//  NewsItem.swift
//  NewsItem
//
//  Created by Russell Gordon on 2021-08-03.
//

import Foundation

struct NewsItem: Codable, Identifiable {
    
    let id: Int
    let title: String
    let strap: String
    let url: String
    let main_image: String
    let published_date: String
}
