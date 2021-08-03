//
//  ContentView.swift
//  NewsTask
//
//  Created by Russell Gordon on 2021-08-03.
//

import SwiftUI

struct ContentView: View {
    
    @State private var newsItems = [NewsItem]()
    
    var body: some View {
        
        NavigationView {
            
            List(newsItems) { item in
                Text(item.title)
            }
            .navigationTitle("News")
            .task {
                
                do {
                    newsItems = try await withThrowingTaskGroup(of: [NewsItem].self) { group -> [NewsItem] in
                        
                        for i in 1...5 {
                            
                            // Get all the news items from the 5 links
                            group.addTask {
                                
                                let url = URL(string: "https://www.hackingwithswift.com/samples/news-\(i).json")!
                                
                                let (data, _) = try await URLSession.shared.data(from: url)
                                
                                return try JSONDecoder().decode([NewsItem].self, from: data)
                                
                            }
                                                        
                        }
                        
                        // Collapse the news items down into one file
                        let allNewsItems = try await group.reduce(into: [NewsItem]()) {
                            $0 += $1
                        }
                        
                        // Return an array sorted by ID
                        return allNewsItems.sorted(by: { lhs, rhs in
                            lhs.id < rhs.id
                        })

                        
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
