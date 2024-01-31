//
//  ContentView.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 30/01/24.
//

import SwiftUI
import UIKit

class ShoppingItem: Identifiable, ObservableObject {
    var id = UUID()
    @Published var imageName: String
    @Published var title: String
    @Published var description: String

    init(imageName: String, title: String, description: String) {
        self.imageName = imageName
        self.title = title
        self.description = description
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

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
    @Published var shoppingList: [ShoppingItem] = [
        // Adicione mais itens conforme necessário
    ]
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
                            NavigationLink(destination: AddItemView(viewModel: viewModel, selectedItem: $selectedItem)) {
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
                    NavigationLink(destination: AddItemView(viewModel: viewModel, selectedItem: $selectedItem)) {
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
                ResumoCompraView()
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

    init(viewModel: ShoppingItemViewModel, selectedItem: Binding<ShoppingItem?>) {
        self.viewModel = viewModel
        self._selectedItem = selectedItem
        if let selectedItem = selectedItem.wrappedValue {
            _itemName = State(initialValue: selectedItem.title)
            _itemTax = State(initialValue: "") // Preencha conforme necessário
            _itemValue = State(initialValue: "") // Preencha conforme necessário
            _paidWithCard = State(initialValue: false) // Preencha conforme necessário
        } else {
            _itemName = State(initialValue: "")
            _itemTax = State(initialValue: "")
            _itemValue = State(initialValue: "")
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
            selectedItem.description = "Taxa: \(itemTax), Valor: \(itemValue), Cartão: \(paidWithCard ? "Sim" : "Não")"
            // Atualize outros campos conforme necessário
        } else {
            // Adiciona um novo item
            let newItem = ShoppingItem(
                imageName: "placeholder",
                title: itemName,
                description: "Taxa: \(itemTax), Valor: \(itemValue), Cartão: \(paidWithCard ? "Sim" : "Não")"
            )

            viewModel.shoppingList.append(newItem)
        }

        // Reset form fields
        itemName = ""
        itemTax = ""
        itemValue = ""
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
    @State private var cotacaoDolar = ""
    @State private var valorIOF = ""

    var body: some View {
        Form {
            Section(header: Text("COTAÇÃO DO DÓLAR (R$)")) {
                TextField("Cotação do Dólar", text: $cotacaoDolar)
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text("IOF (%)")) {
                TextField("Valor do IOF", text: $valorIOF)
                    .keyboardType(.decimalPad)
            }
        }
        .navigationTitle("Ajustes")
    }
}

struct ResumoCompraView: View {
    var body: some View {
        Form {
            Section(header: Text("")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Valor dos Produtos ($)")
                        .foregroundColor(.black)
                    Text("1,698.00")
                        .foregroundColor(.blue)
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                    
                    Text("Total de Impostos ($)")
                        .foregroundColor(.black)
                    Text("1,698.00")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .font(.system(size: 28))
                    Text("Valor Final em Reais")
                        .foregroundColor(.black)
                    Text("1,698.00")
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                        .font(.system(size: 28))
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
            Image(systemName: item.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)  // Adiciona um espaço à direita da imagem

            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
            }

            Spacer()  // Preenche o espaço entre o texto e o valor

            Text(item.description)  // Substitua pelo valor real do produto
                .font(.headline)
        }
        .padding(10)  // Adiciona espaçamento geral à célula
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(viewModel: ShoppingItemViewModel(), selectedItem: .constant(nil))
    }
}

struct AjustesView_Previews: PreviewProvider {
    static var previews: some View {
        AjustesView()
    }
}

#Preview {
    ContentView()
}
