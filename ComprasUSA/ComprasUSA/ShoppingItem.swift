//
//  ShoppingItem.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 01/02/24.
//


import SwiftUI
import UIKit

class ShoppingItem: Identifiable, ObservableObject {
    var id = UUID()
    @Published var imageName: String
    @Published var title: String
    @Published var itemTax: String
    @Published var itemValue: String
    @Published var paidWithCard: Bool?
    @Published var selectedImage: UIImage?
    
    init(imageName: String,
         title: String,
         itemTax: String,
         itemValue: String,
         paidWithCard: Bool,
         selectedImage: UIImage?) {
        self.imageName = imageName
        self.title = title
        self.itemTax = itemTax
        self.itemValue = itemValue
        self.paidWithCard = paidWithCard
        self.selectedImage = selectedImage
    }
}
