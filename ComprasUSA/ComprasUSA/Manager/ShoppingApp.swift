//
//  ShoppingApp.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 01/02/24.
//

import SwiftUI
import UIKit

struct ShoppingApp: App {
    @AppStorage("dollarRate") var dollarRate: Double = 5.0
    @AppStorage("iofPercentage") var iofPercentage: Double = 6.38
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
