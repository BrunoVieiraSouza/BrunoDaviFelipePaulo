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
    @Published var paidWithCard: Bool
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

    init(viewModel: ShoppingItemViewModel, selectedItem: Binding<ShoppingItem?>, item: ShoppingItem?) {
        self.viewModel = viewModel
        self._selectedItem = selectedItem

        if let selectedItem = item {
            _itemName = State(initialValue: selectedItem.title)
            _itemTax = State(initialValue: selectedItem.itemTax)
            _itemValue = State(initialValue: selectedItem.itemValue)
            _paidWithCard = State(initialValue: selectedItem.paidWithCard)
            _selectedImage = State(initialValue: selectedItem.selectedImage)
        } else {
            _itemName = State(initialValue: "")
            _itemTax = State(initialValue: "0.0")
            _itemValue = State(initialValue: "0.0")
            _paidWithCard = State(initialValue: false)
            //_selectedImage = nil
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
                ImagePicker(image: $selectedImage)
            }

            Section {
                Button(action: {
                    self.addItem()
                }) {
                    Text("Cadastrar")
                }
                .disabled(!formIsValid())
            }
        }
        .navigationTitle("Adicionar Produto")
    }

    private func addItem() {
        guard formIsValid() else { return }

        if let selectedItem = selectedItem {
            // Atualiza o item existente
            selectedItem.title = itemName
            selectedItem.itemTax = itemTax
            selectedItem.itemValue = itemValue
            selectedItem.paidWithCard = paidWithCard
            selectedItem.selectedImage = selectedImage
            // Atualize outros campos conforme necessário
        } else {
            // Adiciona um novo item
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

        // Reset form fields
        itemName = ""
        itemTax = "0.0"
        itemValue = "0.0"
        paidWithCard = false
        selectedImage = nil

        // Desativa a seleção do item
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
            .filter { $0.paidWithCard }
            .compactMap { item in
                let itemValue = Double(item.itemValue) ?? 0.0
                let itemTax = Double(item.itemTax) ?? 0.0
                let iof = (itemValue) * ((iofPercentage + itemTax) / 100.0)
                return itemValue + iof
            }
            .reduce(0.0, +)

        let totalDollarValueWithTax = viewModel.shoppingList
            .compactMap { item in
                let itemValue = Double(item.itemValue) ?? 0.0
                let itemTax = Double(item.itemTax) ?? 0.0
                return itemValue + itemTax
            }
            .reduce(0.0, +)

        let finalValueInReais = (totalDollarValueWithIOF) * dollarRate

        Form {
            Section(header: Text("Resumo da Compra")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. Valor dos Produtos em Dólar ($)")
                        .foregroundColor(.blue)
                    Text("\(totalDollarValue, specifier: "%.2f")")
                        .foregroundColor(.blue)
                        .font(.system(size: 18))

                    Text("2. Valor dos Produtos com Imposto e IOF em Dólar ($)")
                        .foregroundColor(.red)
                    Text("\(totalDollarValueWithIOF, specifier: "%.2f")")
                        .foregroundColor(.red)
                        .font(.system(size: 18))

                    Text("3. Valor Final em Reais")
                        .foregroundColor(.green)
                    Text("\(finalValueInReais, specifier: "%.2f")")
                        .foregroundColor(.green)
                        .font(.system(size: 18))
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
            }

            Spacer()

            Text("R$ \(item.itemValue)")
                .font(.headline)
        }
        .padding(10)
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
