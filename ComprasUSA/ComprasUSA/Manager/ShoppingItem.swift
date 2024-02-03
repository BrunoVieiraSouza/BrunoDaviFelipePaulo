//
//  ShoppingItem.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 01/02/24.
//


import SwiftUI
import UIKit
import SwiftData

@Model
class ShoppingItem {
    var id = UUID()
    var imageName: String
    var title: String
    var itemTax: String
    var itemValue: String
    var paidWithCard: Bool
    var selectedImage: Data?
    
    init(imageName: String = "",
         title: String = "",
         itemTax: String = "",
         itemValue: String = "",
         paidWithCard: Bool = false,
         selectedImage: Data? = nil
    ) {
        self.imageName = imageName
        self.title = title
        self.itemTax = itemTax
        self.itemValue = itemValue
        self.paidWithCard = paidWithCard
        self.selectedImage = selectedImage
    }
}
