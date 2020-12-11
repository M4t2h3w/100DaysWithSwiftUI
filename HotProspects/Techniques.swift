//
//  ContentView.swift
//  HotProspects
//
//  Created by Matej Novotný on 15/11/2020.
//

import SamplePackage
import UserNotifications
import SwiftUI

class User: ObservableObject {
    @Published var name = "Taylor Swift"
}

struct EditView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        TextField("Name", text: $user.name)
    }
}

struct DisplayView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        Text(user.name)
    }
}

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}

class DelayedUpdater: ObservableObject {
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = 0
    let user = User()
    @ObservedObject var updater = DelayedUpdater()
    @State private var backgroundColor = Color.red
    
    let possibleNumbers = Array(1...60)
    var results: String {
        let selected = possibleNumbers.random(7).sorted()
        let strings = selected.map(String.init)
        return strings.joined(separator: ", ")
    }
    
    var body: some View {
        
//        ADDING DEPENDENCIES
        Text(results)
        
//        NOTIFICATIONS
//        VStack {
//            Button("Request permision") {
//                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                    if success {
//                        print("All set!")
//                    } else if let error = error {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//
//            Button("Schedule notification") {
//                let content = UNMutableNotificationContent()
//                content.title = "Feed the cat"
//                content.subtitle = "It looks hungry"
//                content.sound = UNNotificationSound.default
//
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//                UNUserNotificationCenter.current().add(request)
//
//            }
//        }
        
//        CONTEXT MENU
//        VStack {
//            Text("Hello, World!")
//                .padding()
//                .background(backgroundColor)
//
//            Text("Change color")
//                .padding()
//                .contextMenu {
//                    Button(action: {
//                        self.backgroundColor = .red
//                    }) {
//                        Text("Red")
//                        Image(systemName: "checkmark.circle.fill")
//                            .foregroundColor(.red)
//                    }
//
//                    Button(action: {
//                        self.backgroundColor = .green
//                    }) {
//                        Text("Green")
//                    }
//
//                    Button(action: {
//                        self.backgroundColor = .blue
//                    }) {
//                        Text("Blue")
//                    }
//                }
//        }
        
//        IMAGE INTERPOLATION
//        Image("example")
//            .interpolation(.none)
//            .resizable()
//            .scaledToFit()
//            .frame(maxHeight: .infinity)
//            .background(Color.black)
//            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
//        FETCHING DATA FROM REMOTE URL
//            .onAppear {
//                self.fetchData(from: "https://www.apple.com") { result in
//                    switch result {
//                    case .success(let str):
//                        print(str)
//                    case .failure(let error):
//                        switch error {
//                        case .badURL:
//                            print("Bad URL")
//                        case .requestFailed:
//                            print("Network problems")
//                        case .unknown:
//                            print("Unknown error")
//                        }
//                    }
//                }
//            }
    }
    
    func fetchData(from urlString: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let stringData = String(decoding: data, as: UTF8.self)
                    completion(.success(stringData))
                } else if error != nil {
                    completion(.failure(.requestFailed))
                } else {
                    completion(.failure(.unknown))
                }
            }
        } .resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
