//
//  AjustesView.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 01/02/24.
//

import SwiftUI

struct AjustesView: View {
    @AppStorage("dollarRate") var dollarRate: Double = 4.9
    @AppStorage("iofPercentage") var iofPercentage: Double = 5.38
    
    var body: some View {
        Form {
            Section(header: Text("COTAÇÃO DO DÓLAR (R$)")) {
                TextField("Cotação do Dólar", value: $dollarRate, formatter: NumberFormatter(numberStyle: .decimal))
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text("IOF (%)")) {
                TextField("Valor do IOF", value: $iofPercentage, formatter: NumberFormatter(numberStyle: .decimal))
                    .keyboardType(.decimalPad)
            }
        }
        .navigationTitle("Ajustes")
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct AjustesView_Previews: PreviewProvider {
    static var previews: some View {
        AjustesView()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension NumberFormatter {
    convenience init(numberStyle: Style, locale: Locale = .current) {
        self.init()
        self.locale = locale
        self.maximumFractionDigits = 2
        self.numberStyle = numberStyle
    }
}
