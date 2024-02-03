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
    @State private var isPresented = false
    @State private var selectedItem: ShoppingItem = ShoppingItem()
    
    var body: some View {
        TabView {
            NavigationView {
                ItemListingView(selectedItem: $selectedItem, isPresented: $isPresented)
            }
            .tabItem {
                Image(systemName: "cart.circle")
                Text("Compras")
            }
            
            NavigationView {
                AjustesView()
            }
            .tabItem {
                Image(systemName: "gear.circle")
                Text("Ajustes")
            }
            
            NavigationView {
                ResumoCompraView()
            }
            .tabItem {
                Image(systemName: "dollarsign.circle")
                Text("Total da compra")
            }
        }
        .sheet(isPresented: $isPresented) {
            FormItemView(selectedItem: $selectedItem)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
