//
//  ContentView.swift
//  BetterRest
//
//  Created by Matej Novotný on 04/10/2020.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    let model = SleepCalculator()
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("When do you want to wake up").font(.headline)){
                    //Text("When do you want to wake up?")
                        //.font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                //VStack(alignment: .leading, spacing: 0){
                Section(header: Text("Desired amount of sleep").font(.headline)){
                    //Text("Desired amount of sleep")
                      //  .font(.headline)
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                //VStack(alignment: .leading, spacing: 0){
                Section(header: Text("Daily coffee intake").font(.headline)){
                    //Text("Daily coffee intake")
                      //  .font(.headline)
                    
                    Stepper(value: $coffeeAmount, in: 1...20){
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }
                
                Section(header: Text("Recommended sleep time").font(.headline)){
                    Text("\(calculateBedTime())")
                        .font(.title)
                        //.foregroundColor(.red)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
            }
            .navigationBarTitle("Better Rest")
            //.navigationBarItems(trailing:
                //Button(action: calculateBedTime){
                  //  Text("Calculate")
            //    }
            //)
            .alert(isPresented: $showingAlert){
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func calculateBedTime() -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formater = DateFormatter()
            formater.timeStyle = .short
            
            //alertMessage = formater.string(from: sleepTime)
            //alertTitle = "Your ideal bed time is..."
            
            return formater.string(from: sleepTime)
            
        } catch {
            //alertTitle = "Error"
            //alertMessage = "Sorry, there was a problem calculating your bed time."
            return "Sorry, there was a problem calculating your bed time."
            
        }
        //showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
