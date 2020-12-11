//
//  AddView.swift
//  iExpense
//
//  Created by Matej Novotný on 12/10/2020.
//

import SwiftUI

struct AddView: View {
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    static let types = ["Business", "Personal"]
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add New Expense")
            .navigationBarItems(trailing:
                                    Button("Save"){
                                        if let actualAmount = Int(self.amount){
                                            let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                                            self.expenses.items.append(item)
                                            self.presentationMode.wrappedValue.dismiss()
                                        } else {
                                            showingAlert = true
                                        }
            })
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Incorect input"), message: Text("You can input only integer values as amount"), dismissButton: .default(Text("Continue")))
        })
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
