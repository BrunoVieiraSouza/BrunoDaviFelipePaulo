//
//  ShoppingItemViewModel.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 01/02/24.
//

import SwiftUI

class ShoppingItemViewModel: ObservableObject {
    @Published var shoppingList: [ShoppingItem] = []
}
