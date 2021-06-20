//
//  ContentView.swift
//  urlsession_learn_1
//
//  Created by ha tuong do on 6/19/21.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}


struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    @State var results = [Result]()
    
    var body: some View {
        List (results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
                Text(item.trackName)
            }
        }
        .onAppear(perform: {
            loadData()
        })
    }
    
    // step 1: create url
    // step 2: create url request
    // step 3: create, start networking task from request
    // step 4: handle result of networking task
    func loadData() {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print (" Invalid URL")
            return
        }
        
        let request = URLRequest (url: url)
        
        URLSession.shared.dataTask (with : request) { data, response, error in
            
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? " Un known error")")
        }
        .resume ()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
