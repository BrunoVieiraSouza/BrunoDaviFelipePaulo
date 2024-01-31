//
//  ContentView.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 30/01/24.
//

import SwiftUI
import UIKit

class ShoppingItem: Identifiable {
    var id = UUID()
    var imageName: String
    var title: String
    var description: String

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
    @Published var shoppingList = [
        ShoppingItem(imageName: "apple", title: "Maçã", description: "5 unidades"),
        ShoppingItem(imageName: "banana", title: "Banana", description: "1 cacho"),
        // Adicione mais itens conforme necessário
    ]
}

struct ContentView: View {
    @ObservedObject var viewModel = ShoppingItemViewModel()

    var body: some View {
        TabView {
            NavigationView {
                List {
                    Section(header: Text("Lista de Compra")) {
                        ForEach(viewModel.shoppingList) { item in
                            NavigationLink(destination: Text("Detalhes do Item \(item.title)")) {
                                ShoppingCell(item: item)
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.shoppingList.remove(atOffsets: indexSet)
                        }
                    }
                }
                .navigationBarItems(trailing:
                    NavigationLink(destination: AddItemView(viewModel: viewModel)) {
                        Image(systemName: "plus")
                    }
                )
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Lista de Compra")
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Lista")
            }

            NavigationView {
                AjustesView()
            }
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Ajustes")
            }

            NavigationView {
                ResumoCompraView()
            }
            .tabItem {
                Image(systemName: "star")
                Text("Resumo")
            }
        }
    }
}

struct AddItemView: View {
    @ObservedObject var viewModel: ShoppingItemViewModel

    @State private var itemName = ""
    @State private var itemTax = ""
    @State private var itemValue = ""
    @State private var paidWithCard = false
    @State private var selectedImage: UIImage?

    var body: some View {
        Form {
            Section(header: Text("Detalhes do Produto")) {
                TextField("Nome do Produto", text: $itemName)
                TextField("Imposto do Estado", text: $itemTax)
                    .keyboardType(.decimalPad)
                TextField("Valor do Produto", text: $itemValue)
                    .keyboardType(.decimalPad)
                Toggle("Pagou com Cartão", isOn: $paidWithCard)
            }

            Section(header: Text("Adicionar Foto")) {
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

        let newItem = ShoppingItem(
            imageName: "placeholder",
            title: itemName,
            description: "Taxa: \(itemTax), Valor: \(itemValue), Cartão: \(paidWithCard ? "Sim" : "Não")"
        )

        viewModel.shoppingList.append(newItem)

        // Reset form fields
        itemName = ""
        itemTax = ""
        itemValue = ""
        paidWithCard = false
        selectedImage = nil
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
            Section(header: Text("Ajustes")) {
                TextField("Cotação do Dólar", text: $cotacaoDolar)
                    .keyboardType(.decimalPad)
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
            Section(header: Text("Resumo da Compra")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Valor dos Produtos ($)")
                        .foregroundColor(.blue)
                    Text("1,698.00")
                        .foregroundColor(.blue)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Total de Impostos ($)")
                        .foregroundColor(.red)
                    Text("1,698.00")
                        .foregroundColor(.red)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Valor Final em Reais")
                        .foregroundColor(.green)
                    Text("1,698.00")
                        .foregroundColor(.green)
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
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(item.description)
                    .font(.subheadline)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(viewModel: ShoppingItemViewModel())
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
