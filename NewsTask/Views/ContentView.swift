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
                
                Link(destination: URL(string: item.url)!) {
                    ZStack {
                        
                        // See: https://swiftwithmajid.com/2021/07/07/mastering-asyncimage-in-swiftui/
                        AsyncImage(url: URL(string: item.main_image)!) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .padding(0)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 300, height: 200)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(0)

                        VStack {
                            Spacer()
                            VStack {
                                HStack {
                                    Spacer(minLength: 50)
                                    Text(item.title)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 5)
                                    Spacer(minLength: 50)
                                }
                                HStack {
                                    Spacer(minLength: 50)
                                    Text(item.strap)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom, 5)
                                    Spacer(minLength: 50)
                                }
                            }
                            .background(Color.primary.colorInvert().opacity(0.8))
                        }
                        
                    }

                }
                .listRowSeparator(.hidden)
                
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Articles")
            .task {
                
                do {
                    newsItems = try await withThrowingTaskGroup(of: [NewsItem].self) { group -> [NewsItem] in
                        
                        for i in 1...5 {
                            
                            // Get all the news items from the 5 links
                            group.addTask {

                                let url = URL(string: "https://www.hackingwithswift.com/samples/news-\(i).json")!

                                // Get the data
                                let (data, _) = try await URLSession.shared.data(from: url)

                                // Just in case task was cancelled
                                try Task.checkCancellation()

                                // Decode the data from JSON into Swift structures
                                return try JSONDecoder().decode([NewsItem].self, from: data)

                            }
                                                        
                        }
                        
                        // Alt: Put the results into the array as soon as they are ready
//                        for try await result in group {
//                            newsItems.append(contentsOf: result)
//                        }
                        
                        // Collapse the news items down into one file (this puts all the results all at once)
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
