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
    @State var myStringResult: String
    
    var body: some View {
        VStack {
        Text(myStringResult)
        List (results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
                // Text(item.trackName)
            }
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
        guard let url1 = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print (" Invalid URL")
            return
        }
        
        let request = URLRequest (url: url1)
        
        URLSession.shared.dataTask (with : request) { data, response, error in
            // step 4
            if let myData = data {
                // print("............ myData = ", myData) // 75098 bytes
                // print("...............................")
                // print("------------ myData = ", myData.enumerated()) // EnumeratedSequence<Data>(_base: 75098 bytes)
                // print("..... myData first = ", myData.first) // Optional(10)
                // print("..... myData = ", myData.description) // 75000 bytes
                // print(".... myData = ", myData.self) // 75... bytes
                
                // decodedResponse is of type Response
                // .decode() input is myData (it decode myData and put result into decodecResponse var
                // .decode(struct type that store decoded data, from: myData)

                let str = String(decoding: myData, as: UTF8.self)
                // print("string from String decoding = ", str)

                DispatchQueue.main.async {
                    print("string from String decoding = ", str)
                    self.myStringResult = str
                }
                
                
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: myData)
                    // { ... } is closure for the function JSONDecoder.decode() so the var decodedResponse
                    // is passed into { ... } closure and available for Dispatchqueue...() function to use
                    {
                    
                    // go back to UI queue (main queue) and set results to stuff we got back from internet
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? " Un known error")")
        }
        .resume () // URLSession is running in background, we use resume() to get back to main thread
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView( myStringResult: "oy yy")
//    }
//}
