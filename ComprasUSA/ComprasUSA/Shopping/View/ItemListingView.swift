//
//  ItemListingView.swift
//  ComprasUSA
//
//  Created by Felipe Moreno Borges on 03/02/24.
//

import SwiftUI
import SwiftData

struct ItemListingView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var items: [ShoppingItem]
    
    @Binding var selectedItem: ShoppingItem
    @Binding var isPresented: Bool
    
    var body: some View {
        if (items.isEmpty) {
            Text("Sua lista está vazia")
                .italic()
                .navigationBarItems(
                    trailing: Button(
                        action: {
                            selectedItem = ShoppingItem()
                            isPresented.toggle()
                        }
                    ) {
                        Image(systemName: "plus")
                    }
                )
                .navigationTitle("Lista de compras")
        } else {
            List {
                ForEach(items) { item in
                    ShoppingItemRowView(item: item)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedItem = item
                            isPresented.toggle()
                        }
                }.onDelete(perform: deleteItem)
            }
            .navigationBarItems(
                trailing: Button(
                    action: {
                        selectedItem = ShoppingItem()
                        isPresented.toggle()
                    }
                ) {
                    Image(systemName: "plus")
                }
            )
            .navigationTitle("Lista de compras")
        
        }
    }
    
    private func deleteItem(_ indexSet: IndexSet) {
        for index in indexSet {
            let item = items[index]
            modelContext.delete(item)
        }
    }
}

#Preview {
    ItemListingView(selectedItem: .constant(ShoppingItem()), isPresented: .constant(false))
}

