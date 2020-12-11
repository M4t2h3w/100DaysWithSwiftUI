//
//  ContentView.swift
//  UnitConversion
//
//  Created by Matej Novotný on 01/10/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var inputValue = ""
    @State private var inputUnit = 0
    @State private var outputUnit = 0
    
    let units = ["km", "m", "cm", "mm", "mi", "yd", "ft", "in"]
    let conversionToMm = [1000000, 1000, 10, 1, 1609344, 914.4, 304.8, 25.4]
    
    var outputValue: Double{
        let userInputValue = Double(inputValue) ?? 0
        let userInputInMm = userInputValue * Double(conversionToMm[inputUnit])
        let result = userInputInMm / Double(conversionToMm[outputUnit])
        
        return result
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Input")){
                    TextField("Input value", text: $inputValue)
                        .keyboardType(.decimalPad)
                    
                    Picker("Input unit", selection: $inputUnit){
                        ForEach(0 ..< units.count){
                            Text("\(units[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Output")){
                    Text("\(outputValue)")
                    
                    Picker("Output unit", selection: $outputUnit){
                        ForEach(0 ..< units.count){
                            Text("\(units[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("Unit Conversion")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
