//
//  ContentView.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 30/01/24.
//

import SwiftUI
import UIKit
import SwiftData


enum NavigationType: Hashable {
    case detail(ShoppingItem)
    case form(ShoppingItem?)
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var items: [ShoppingItem]
    
    @State private var isPresented = false
    @State private var selectedItem: ShoppingItem = ShoppingItem()

    var body: some View {
        TabView {
            NavigationView {
                list
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Compras")
            }
            
            NavigationView {
                AjustesView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Ajustes")
            }
            
            NavigationView {
//                ResumoCompraView(viewModel: viewModel)
            }
            .tabItem {
                Image(systemName: "dollarsign.square")
                Text("Total da compra")
            }
        }
        .sheet(isPresented: $isPresented) {
            FormItemView(item: selectedItem)
        }
    }
    
    private var list: some View {
        List {
            ForEach(items) { item in
                ShoppingCell(item: item)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedItem = item
                        isPresented.toggle()
                    }
            }.onDelete(perform: deleteItem)
        }
        .listStyle(PlainListStyle())
        .navigationBarItems(trailing:
            Button(action: {
                selectedItem = ShoppingItem()
                isPresented.toggle()
            }) {
                Image(systemName: "plus")
            }
        )
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Lista de compras")
    }
    
    
    private func deleteItem(_ indexSet: IndexSet) {
        for index in indexSet {
            let item = items[index]
            modelContext.delete(item)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
