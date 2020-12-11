//
//  ContentView.swift
//  Animations
//
//  Created by Matej Novotný on 07/10/2020.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animationAmount: CGFloat = 1
    @State private var animationAmount2: CGFloat = 0.0
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    @State private var dragAmount2 = CGSize.zero
    @State private var isShowingRed = false
    
    let letters = Array("Hello SwiftUI")
    
    var body: some View {
        VStack{
            Button(action: {
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)){
                    self.animationAmount2 += 360
                }
                //self.animationAmount += 1
            }, label: {
                Text("Tap me")
            })
            .padding(50)
            .animation(.default)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .rotation3DEffect(
                .degrees(Double(animationAmount2)),
                axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
                )
            .overlay(
                Circle()
                    .stroke(Color.red)
                    .scaleEffect(animationAmount)
                    .opacity(Double(2 - animationAmount))
                    .animation(Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: false))
                        )
            
            Button(action: {
                self.enabled.toggle()
                withAnimation {
                    self.isShowingRed.toggle()
                }
            }, label: {
                Text("Show text")
            })
            .frame(width: 120, height: 120)
            .background(enabled ? Color.blue : Color.red)
            .animation(.default)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
            .animation(.interpolatingSpring(stiffness: 10, damping: 1))
            
            LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                .offset(dragAmount)
                //.animation(.spring())
                .gesture(
                    DragGesture()
                        .onChanged{ self.dragAmount = $0.translation }
                        .onEnded{ _ in
                            withAnimation(.spring()){
                                self.dragAmount = .zero
                            }
                        }
                )
            
            Spacer()
            
            if isShowingRed {
                HStack(spacing: 0){
                    ForEach(0..<letters.count) {num in
                        Text(String(self.letters[num]))
                            .padding(5)
                            .font(.title)
                            .background(self.enabled ? Color.blue : Color.red)
                            .offset(self.dragAmount2)
                            .animation(Animation.default.delay(Double(num) / 20))
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged{self.dragAmount2 = $0.translation}
                        .onEnded{_ in
                            self.dragAmount2 = .zero
                            self.enabled.toggle()
                        }
                )
            }
            
        }
       // .scaleEffect(animationAmount)
        //.blur(radius: (animationAmount - 1) * 3)
        
        .onAppear {
            self.animationAmount = 2
        }
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

// with this extension I can use transition with any view like this:
// .transition(.pivot)
extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
