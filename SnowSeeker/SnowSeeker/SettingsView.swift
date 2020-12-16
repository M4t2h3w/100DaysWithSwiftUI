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
