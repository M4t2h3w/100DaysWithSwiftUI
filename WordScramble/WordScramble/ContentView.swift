//
//  ContentView.swift
//  WordScramble
//
//  Created by Matej Novotný on 06/10/2020.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var score = 0
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                List(usedWords, id: \.self){
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
                
                Text("Current score: \(score)")
            }
            .navigationBarTitle(rootWord)
            .navigationBarItems(trailing: Button(action: {
                startGame()
                usedWords = []
                score = 0
            }, label: {
                Text("Start new game")
            }))
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError){
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func addNewWord() {
        //lowercase and trim new word
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        //exit if remaining string is empty
        guard answer.count > 0 else {
            return
        }
        
        //word validation
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isNotStartWord(word: answer) else {
            wordError(title: "Same as root word", message: "No, no, no, you can't submit the root word!")
            return
        }
        
        guard isLongEnough(word: answer) else {
            wordError(title: "Not long enough", message: "Try harder and come up with something longer.")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }
        
        score += answer.count + usedWords.count
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func startGame(){
        //1. find start.txt url
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            //2.load start.txt into String
            if let startWords = try? String(contentsOf: startWordsURL){
                //3.Split string into string array, split on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                
                //4.pick one random word or use silkworm as default
                rootWord = allWords.randomElement() ?? "silkworm"
                
                //if we are here everything has worked
                return
            }
        }
        
        //if we are here, there was a problem with loading the file - trigger the crash of the app and report the problem
        fatalError("Could not load start.txt from bundle")
    }
    
    //check if the word wasn't already submitted
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    //check if the word is possible to create from root word
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    //check if the word is real, not misspelled
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    //check if the word is longer than set length
    func isLongEnough(word: String) -> Bool {
        let lengthLimit = 3
        
        return word.count > lengthLimit
    }
    
    //check if the submitted word isn't the start word
    func isNotStartWord(word: String) -> Bool {
        return word != rootWord
    }
    
    func wordError(title: String, message: String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
