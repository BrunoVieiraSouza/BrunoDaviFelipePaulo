//
//  ResumoCompraView.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 01/02/24.
//

import SwiftUI

struct ResumoCompraView: View {
    @ObservedObject var viewModel: ShoppingItemViewModel
    @AppStorage("dollarRate") var dollarRate: Double = 5.5
    @AppStorage("iofPercentage") var iofPercentage: Double = 6.38
    
    var body: some View {
        return VStack { }
//        let totalDollarValue = viewModel.shoppingList
//            .compactMap { Double($0.itemValue) }
//            .reduce(0.0, +)
//        
//        let totalDollarValueWithIOF = viewModel.shoppingList
//            .compactMap { item -> Double in
//                let itemValue = Double(item.itemValue) ?? 0.0
//                let itemTax = Double(item.itemTax) ?? 0.0
//                
//                if let paidWithCard = item.paidWithCard, paidWithCard {
//                    let totalValueWithTax = itemValue + (itemValue * (itemTax / 100.0))
//                    let iof = totalValueWithTax * (iofPercentage / 100.0)
//                    return totalValueWithTax + iof
//                } else {
//                    return itemValue + (itemValue * (itemTax / 100))
//                }
//            }
//            .reduce(0.0, +)
//        
//        let finalValueInReais = (totalDollarValueWithIOF) * dollarRate
//        
//        Form {
//            Section(header: Text("")) {
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Valor dos Produtos em Dólar ($)")
//                        .foregroundColor(.black)
//                    Text("$ \(totalDollarValue, specifier: "%.2f")")
//                        .foregroundColor(.blue)
//                        .font(.system(size: 40))
//                        .bold()
//                    Spacer()
//                    Text("Valor dos Produtos com Imposto e IOF em Dólar ($)")
//                        .foregroundColor(.black)
//                    Text("$ \(totalDollarValueWithIOF, specifier: "%.2f")")
//                        .foregroundColor(.red)
//                        .font(.system(size: 40))
//                        .bold()
//                    Spacer()
//                    Text("Valor Final em Reais")
//                        .foregroundColor(.black)
//                    Text("R$ \(finalValueInReais, specifier: "%.2f")")
//                        .foregroundColor(.green)
//                        .font(.system(size: 40))
//                        .bold()
//                }
//            }
//        }
//        .navigationTitle("Resumo da Compra")
    }
}
