//
//  ShoppingCell.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 01/02/24.
//

import SwiftUI

struct ShoppingItemRowView: View {
    var item: ShoppingItem
    
    var body: some View {
        HStack(spacing: 20) {
            if let data = item.selectedImage,
               let uiimage = UIImage(data: data) {
                Image(uiImage: uiimage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            
            HStack(alignment: .center) {
                Text(item.title)
                    .font(.headline)
                Spacer()
                Text("$ \(calculateTotalValueWithTax(), specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(10)
    }
    
    private func calculateTotalValueWithTax() -> Double {
        let itemValue = Double(item.itemValue) ?? 0.0
        let itemTax = Double(item.itemTax) ?? 0.0
        return itemValue + (itemValue * (itemTax / 100.0))
    }
}
