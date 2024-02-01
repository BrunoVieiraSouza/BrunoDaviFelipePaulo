//
//  ContentView.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 30/01/24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @ObservedObject var viewModel = ShoppingItemViewModel()
    @State private var isPresented = false

    @State private var selectedItem: ShoppingItem?

    var body: some View {
        TabView {
            NavigationView {
                List {
                    ForEach(viewModel.shoppingList) { item in
                        ShoppingCell(item: item)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.selectedItem = item
                                isPresented.toggle()
                            }
                    }
                    .onDelete { indexSet in
                        viewModel.shoppingList.remove(atOffsets: indexSet)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarItems(trailing:
                    Button(action: {
                        self.selectedItem = nil
                        isPresented.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                )
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Lista de Compra")
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
                ResumoCompraView(viewModel: viewModel)
            }
            .tabItem {
                Image(systemName: "dollarsign.square")
                Text("Total da compra")
            }
        }
        .sheet(isPresented: $isPresented) {
            AddItemView(viewModel: viewModel, selectedItem: $selectedItem, item: selectedItem)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
