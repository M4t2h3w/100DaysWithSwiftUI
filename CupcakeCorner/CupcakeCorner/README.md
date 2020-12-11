#  Code samples for project 10

import SwiftUI

// if I use @Published for variable inside the Codable class, SwiftUI will not compile
// I have to tell it which part of the @Published is to be encoded and decoded
class User: ObservableObject, Codable {
//    1. add CodingKeys
    enum CodingKeys: CodingKey {
        case name
    }
    @Published var name = "Paul Hudson"
    
//    2. create custom init
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
    
//    3. create custom encode func
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}

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
    
    @State var userName = ""
    @State var email = ""
    
    var body: some View {
        
//        DISABLING THE PART OF CODE
        Form {
            Section {
                TextField("User name", text: $userName)
                TextField("Email", text: $email)
            }
            
            Section {
                Button("Create account") {
                    print("Creating account...")
                }
            }
//            with this line of code I will disable the button if the userName or email is empty
            .disabled(userName.isEmpty || email.isEmpty)
        }
        
//        THIS IS THE PART FOR URL SESSION LOADING THE SONGS FROM ITUNES
//        List(results, id: \.trackId){ item in
//            VStack(alignment: .leading){
//                Text(item.trackName)
//                    .font(.headline)
//
//                Text(item.collectionName)
//            }
//        }
//        .onAppear(perform: loadData)
    }
    
//    loading data from URL
    func loadData(){
//        1. prepare URL string
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
//        2. create request from the URL string
        let request = URLRequest(url: url)
        
//        3. initiate URL session
        URLSession.shared.dataTask(with: request) { data, response, error in
//            try loading the data
            if let data = data {
//                if we load data try to decode them
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
//                    if we are all the way here, we can return the data from background to the main program
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                    }
                    
                    return
                }
            }
            
//            otherwise print error to the console
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown Error")")
            
//            DON'T FORGET the .resume() at the end of URLSession
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

