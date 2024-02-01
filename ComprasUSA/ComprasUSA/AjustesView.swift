//
//  AjustesView.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 01/02/24.
//

import SwiftUI

struct AjustesView: View {
    @AppStorage("dollarRate") var dollarRate: Double = 5.0
    @AppStorage("iofPercentage") var iofPercentage: Double = 6.38
    
    var body: some View {
        Form {
            Section(header: Text("COTAÇÃO DO DÓLAR (R$)")) {
                TextField("Cotação do Dólar", value: $dollarRate, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text("IOF (%)")) {
                TextField("Valor do IOF", value: $iofPercentage, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
            }
        }
        .navigationTitle("Ajustes")
    }
}

struct AjustesView_Previews: PreviewProvider {
    static var previews: some View {
        AjustesView()
    }
}
