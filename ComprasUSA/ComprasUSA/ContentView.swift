//
//  ContentView.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 30/01/24.
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

class ShoppingItem: Identifiable, ObservableObject {
    var id = UUID()
    @Published var imageName: String
    @Published var title: String
    @Published var itemTax: String
    @Published var itemValue: String
    @Published var paidWithCard: Bool?
    @Published var selectedImage: UIImage?
    
    init(imageName: String, title: String, itemTax: String, itemValue: String, paidWithCard: Bool, selectedImage: UIImage?) {
        self.imageName = imageName
        self.title = title
        self.itemTax = itemTax
        self.itemValue = itemValue
        self.paidWithCard = paidWithCard
        self.selectedImage = selectedImage
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // Do nothing here
    }
}

class ShoppingItemViewModel: ObservableObject {
    @Published var shoppingList: [ShoppingItem] = []
}

struct ContentView: View {
    @ObservedObject var viewModel = ShoppingItemViewModel()
    @State private var selectedItem: ShoppingItem?
    
    var body: some View {
        TabView {
            NavigationView {
                List {
                    Section(header: Text("Lista de Compra")) {
                        ForEach(viewModel.shoppingList) { item in
                            NavigationLink(destination: AddItemView(viewModel: viewModel, selectedItem: $selectedItem, item: item)) {
                                ShoppingCell(item: item)
                                    .onTapGesture {
                                        self.selectedItem = item
                                    }
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.shoppingList.remove(atOffsets: indexSet)
                        }
                    }
                }
                .navigationBarItems(trailing:
                                        NavigationLink(destination: AddItemView(viewModel: viewModel, selectedItem: $selectedItem, item: nil)) {
                    Image(systemName: "plus")
                }
                )
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Lista de Compra")
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Compras")
            }
            
            NavigationView {
                AjustesView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Ajustes")
            }
            
            NavigationView {
                ResumoCompraView(viewModel: viewModel)
            }
            .tabItem {
                Image(systemName: "dollarsign.square")
                Text("Total da compra")
            }
        }
    }
}

struct AddItemView: View {
    @ObservedObject var viewModel: ShoppingItemViewModel
    @Binding var selectedItem: ShoppingItem?
    @State private var itemName: String
    @State private var itemTax: String
    @State private var itemValue: String
    @State private var paidWithCard: Bool
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false

    @Environment(\.presentationMode) var presentationMode

    init(viewModel: ShoppingItemViewModel, selectedItem: Binding<ShoppingItem?>, item: ShoppingItem?) {
        self.viewModel = viewModel
        self._selectedItem = selectedItem

        if let selectedItem = item {
            _itemName = State(initialValue: selectedItem.title)
            _itemTax = State(initialValue: selectedItem.itemTax)
            _itemValue = State(initialValue: selectedItem.itemValue)
            _paidWithCard = State(initialValue: selectedItem.paidWithCard ?? false)
            _selectedImage = State(initialValue: selectedItem.selectedImage)
        } else {
            _itemName = State(initialValue: "")
            _itemTax = State(initialValue: "0.0")
            _itemValue = State(initialValue: "0.0")
            _paidWithCard = State(initialValue: false)
        }
    }

    var body: some View {
        Form {
            Section(header: Text("NOME DO PRODUTO")) {
                TextField("Nome do Produto", text: $itemName)
            }
            Section(header: Text("IMPOSTO DO ESTADO %")) {
                TextField("Imposto do Estado", text: $itemTax)
                    .keyboardType(.decimalPad)
            }
            Section(header: Text("VALOR DO PRODUTO (U$)")) {
                TextField("Valor do Produto", text: $itemValue)
                    .keyboardType(.decimalPad)
            }

            Section(header: Text("MEIO DE PAGAMENTO")) {
                Toggle("Pagou com Cartão", isOn: $paidWithCard)
            }

            Section(header: Text("FOTO")) {
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Text("Escolher Foto")
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $selectedImage)
                }

                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.top, 10)
                }
            }

            Section {
                Button(action: {
                    self.addItem()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cadastrar")
                }
                .disabled(!formIsValid())
            }
        }
        .navigationTitle("Cadastro de Produto")
    }

    private func addItem() {
        guard formIsValid() else { return }

        if let selectedItem = selectedItem {
            if let index = viewModel.shoppingList.firstIndex(where: { $0.id == selectedItem.id }) {
                viewModel.shoppingList[index].title = itemName
                viewModel.shoppingList[index].itemTax = itemTax
                viewModel.shoppingList[index].itemValue = itemValue
                viewModel.shoppingList[index].paidWithCard = paidWithCard
                viewModel.shoppingList[index].selectedImage = selectedImage
            }
        } else {
            let newItem = ShoppingItem(
                imageName: "placeholder",
                title: itemName,
                itemTax: itemTax,
                itemValue: itemValue,
                paidWithCard: paidWithCard,
                selectedImage: selectedImage
            )

            viewModel.shoppingList.append(newItem)
        }

        itemName = ""
        itemTax = "0.0"
        itemValue = "0.0"
        paidWithCard = false
        selectedImage = nil

        selectedItem = nil
    }

    private func formIsValid() -> Bool {
        return !itemName.isEmpty && !itemTax.isEmpty && !itemValue.isEmpty
    }
}

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

struct ResumoCompraView: View {
    @ObservedObject var viewModel: ShoppingItemViewModel
    @AppStorage("dollarRate") var dollarRate: Double = 5.5
    @AppStorage("iofPercentage") var iofPercentage: Double = 6.38
    
    var body: some View {
        let totalDollarValue = viewModel.shoppingList
            .compactMap { Double($0.itemValue) }
            .reduce(0.0, +)
        
        let totalDollarValueWithIOF = viewModel.shoppingList
            .compactMap { item -> Double in
                let itemValue = Double(item.itemValue) ?? 0.0
                let itemTax = Double(item.itemTax) ?? 0.0
                
                if let paidWithCard = item.paidWithCard, paidWithCard {
                    let totalValueWithTax = itemValue + (itemValue * (itemTax / 100.0))
                    let iof = totalValueWithTax * (iofPercentage / 100.0)
                    return totalValueWithTax + iof
                } else {
                    return itemValue + (itemValue * (itemTax / 100))
                }
            }
            .reduce(0.0, +)
        
        let finalValueInReais = (totalDollarValueWithIOF) * dollarRate
        
        Form {
            Section(header: Text("")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Valor dos Produtos em Dólar ($)")
                        .foregroundColor(.black)
                    Text("$ \(totalDollarValue, specifier: "%.2f")")
                        .foregroundColor(.blue)
                        .font(.system(size: 40))
                        .bold()
                    Spacer()
                    Text("Valor dos Produtos com Imposto e IOF em Dólar ($)")
                        .foregroundColor(.black)
                    Text("$ \(totalDollarValueWithIOF, specifier: "%.2f")")
                        .foregroundColor(.red)
                        .font(.system(size: 40))
                        .bold()
                    Spacer()
                    Text("Valor Final em Reais")
                        .foregroundColor(.black)
                    Text("R$ \(finalValueInReais, specifier: "%.2f")")
                        .foregroundColor(.green)
                        .font(.system(size: 40))
                        .bold()
                }
            }
        }
        .navigationTitle("Resumo da Compra")
    }
}

struct ShoppingCell: View {
    var item: ShoppingItem
    
    var body: some View {
        HStack {
            if let selectedImage = item.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 10)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 10)
            }
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                
                Text("R$ \(calculateTotalValueWithTax(), specifier: "%.2f")") // Problema 2 - Correção na exibição do valor total
                    .font(.subheadline)
            }
            
            Spacer()
        }
        .padding(10)
    }
    
    // Problema 2 - Função para calcular o valor total com a taxa do imposto do estado
    private func calculateTotalValueWithTax() -> Double {
        let itemValue = Double(item.itemValue) ?? 0.0
        let itemTax = Double(item.itemTax) ?? 0.0
        return itemValue + (itemValue * (itemTax / 100.0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(viewModel: ShoppingItemViewModel(), selectedItem: .constant(nil), item: nil)
    }
}

struct AjustesView_Previews: PreviewProvider {
    static var previews: some View {
        AjustesView()
    }
}
