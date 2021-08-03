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
            
            List {
                
            }
            .navigationTitle("News")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
