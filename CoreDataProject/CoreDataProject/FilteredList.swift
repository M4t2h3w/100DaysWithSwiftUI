//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Matej Novotný on 21/10/2020.
//

import CoreData
import SwiftUI

struct FilteredList<T: NSManagedObject, Content: View>: View {
    
    var fetchRequest: FetchRequest<T>
    var singers: FetchedResults<T> {
        fetchRequest.wrappedValue
    }
    var sortDescriptors: [NSSortDescriptor]
    
    let content: (T) -> Content
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            self.content(singer)
        }
    }
    
    init(filterKey: String, filterValue: String, sortDescriptors: [NSSortDescriptor], @ViewBuilder content: @escaping (T) -> Content) {
        
        if (filterValue == "") {
            fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors)
        } else {
            fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: NSPredicate(format:"%K BEGINSWITH %@", filterKey, filterValue))
        }
        
        
        self.content = content
        self.sortDescriptors = sortDescriptors
    }
}

//struct FilteredList_Previews: PreviewProvider {
//    static var previews: some View {
//        FilteredList()
//    }
//}
