//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Matej Novotný on 04/10/2020.
//

import SwiftUI

struct ContentView: View {
    let options = ["Rock", "Paper", "Scissors"]
    @State private var appMove = Int.random(in: 0...2)
    @State private var winOrLose = Bool.random()
    
    @State private var currentScore = 0
    @State private var scoreTitle = ""
    @State private var showingScore = false
    var body: some View {
        VStack{
            Text("I choose \(options[appMove])")
            Text("You have to \(winOrLose ? "win" : "lose")")
            HStack{
                ForEach(0..<options.count){index in
                    Button(action: {
                        self.optionTapped(index)
                    }, label: {
                        Text("\(options[index])")
                            .foregroundColor(.white)
                            .padding()
                            .background(RadialGradient(gradient: Gradient(colors: [Color.blue, Color.black
                            ]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, startRadius: 0, endRadius: 50))
                            .clipShape(Capsule())
                    })
                }
            }
            Text("Current score is \(currentScore)")
        }
        
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(currentScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func optionTapped(_ number: Int){
        if winOrLose {
            if number > appMove || (appMove == 2 && number == 0){
                currentScore += 1
                scoreTitle = "Correct"
            } else {
                currentScore -= 1
                scoreTitle = "Wrong"
            }
        } else if number < appMove || (appMove == 0 && number == 2){
            currentScore += 1
            scoreTitle = "Correct"
        } else {
            currentScore -= 1
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    
    func askQuestion(){
        appMove = Int.random(in: 0...2)
        winOrLose = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
