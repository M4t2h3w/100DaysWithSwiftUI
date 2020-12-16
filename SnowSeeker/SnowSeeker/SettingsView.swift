//
//  SettingsView.swift
//  SnowSeeker
//
//  Created by Matej Novotný on 16/12/2020.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var filterOption: Resort.SortingOptions
    @Binding var sizeFilter: Int
    @Binding var priceFilter: Int
    @Binding var countryFilter: String
    @State var countries: Set<String>

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort")) {
                    Picker("", selection: $filterOption) {
                        ForEach(Resort.SortingOptions.allCases, id:\.self) { option in
                            Text(option.rawValue)
                                .tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Filter")) {
                    Text("Filter by size:")
                    Picker("", selection: $sizeFilter) {
                        Text("All").tag(0)
                        Text("Small").tag(1)
                        Text("Average").tag(2)
                        Text("Large").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("Filter by price:")
                    Picker("", selection: $priceFilter) {
                        Text("All").tag(0)
                        Text("$").tag(1)
                        Text("$$").tag(2)
                        Text("$$$").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Picker("Filter by country:", selection: $countryFilter) {
                        Text("All").tag("")
                        ForEach(Array(countries), id:\.self) { country in
                            Text(country)
                        }
                    }
                }
            }
            
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Done")
                }))
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(filterOption: "default")
//    }
//}
