//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Matej Novotný on 03/10/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Text")
            .largeBlueFont()
    }
}

struct LargeBlueFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    }
}

extension View {
    func largeBlueFont() -> some View{
        self.modifier(LargeBlueFont())
    }
}

struct Watermark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing){
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black)
        }
    }
}

extension View{
    func watermarked(with text: String) -> some View{
        self.modifier(Watermark(text: text))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
