//
//  DetailContactView.swift
//  ConferenceContacts
//
//  Created by Matej Novotný on 10/11/2020.
//

import SwiftUI
import MapKit

struct DetailContactView: View {
    let contact: Contact
    @State private var anotation = MKPointAnnotation()
    @State private var centerCoordinate = CLLocationCoordinate2D()
    var body: some View {

            VStack {
                contact.image
                    .resizable()
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .shadow(radius: 2)
                    .padding(.horizontal)
                Text(contact.firstName)
                    .font(.title)
                Text(contact.surname)
                    .font(.title)
                MapView(centerCoordinate: $centerCoordinate, annotation: anotation)
                Spacer()
            }
            .padding()
            .navigationBarTitle(Text("Contact details"))
            .onAppear(perform: loadAnotation)
        
    }
    
    func loadAnotation() {
        self.anotation.coordinate.latitude = contact.latitude
        self.anotation.coordinate.longitude = contact.longitude
        self.centerCoordinate = CLLocationCoordinate2D(latitude: contact.latitude, longitude: contact.longitude)
        print(anotation.coordinate.latitude)
        print(anotation.coordinate.longitude)
    }
}

struct DetailContactView_Previews: PreviewProvider {
    static var previews: some View {
        DetailContactView(contact: Contact(id: UUID(), firstName: "Fero", surname: "Dajaky", latitude: 51.0, longitude: 10.0))
    }
}
