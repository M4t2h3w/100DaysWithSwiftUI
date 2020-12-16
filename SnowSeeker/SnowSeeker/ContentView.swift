//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Matej Novotný on 16/12/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var filterOption = Resort.SortingOptions.original
    @State private var sizeFilter = 0
    @State private var priceFilter = 0
    @State private var countryFilter = ""
    @State private var isShowingSettingsSheet = false
    
    @ObservedObject var favorites = Favorites()
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    var countries: Set<String> {
        return Set(resorts.map { $0.country } )
    }
    
    var filteredBySize: [Resort] {
        switch sizeFilter {
        case 1:
            return resorts.filter { $0.size == 1}
        case 2:
            return resorts.filter { $0.size == 2}
        case 3:
            return resorts.filter { $0.size == 3}
        default:
            return resorts
        }
    }
    
    var filteredByPrice: [Resort] {
        switch priceFilter {
        case 1:
            return filteredBySize.filter { $0.price == 1}
        case 2:
            return filteredBySize.filter { $0.price == 2}
        case 3:
            return filteredBySize.filter { $0.price == 3}
        default:
            return filteredBySize
        }
    }
    
    var filteredByCountry: [Resort] {
        if countryFilter == "" {
            return self.filteredByPrice
        } else {
            return self.filteredByPrice.filter { $0.country == countryFilter }
        }
    }
    
    var sortedResorts: [Resort] {
        switch filterOption {
        case .alphabetical:
            return self.filteredByCountry.sorted { $0.name < $1.name }
        case .country:
            return self.filteredByCountry.sorted { $0.country < $1.country }
        default:
            return self.filteredByCountry
        }
    }
    
    var body: some View {
        NavigationView {
            List(sortedResorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)
                    
                    if self.favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .accessibility(label: Text("This is a favorite resort."))
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .navigationBarItems(trailing: Button(action: {
                self.isShowingSettingsSheet = true
            }, label: {
                Image(systemName: "gear")
                    .font(.title2)
            }))
            
            // this view will be shown after the user runs the app before he select the resort from the list
            WelcomeView()
        }
        .sheet(isPresented: $isShowingSettingsSheet, content: {
            SettingsView(filterOption: self.$filterOption, sizeFilter: self.$sizeFilter, priceFilter: self.$priceFilter, countryFilter: self.$countryFilter, countries: self.countries)
        })
        .environmentObject(favorites)
//        // StackNavigationViewStyle will be used for phones
//        .phoneOnlyStackNavigationView()
    }
}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
