//
//  AddItemView.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 01/02/24.
//

import SwiftUI

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
                    .onTapGesture {
                        hideKeyboard()
                    }
            }
            Section(header: Text("VALOR DO PRODUTO (U$)")) {
                TextField("Valor do Produto", text: $itemValue)
                    .keyboardType(.decimalPad)
                    .onTapGesture {
                        hideKeyboard()
                    }
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
                
                viewModel.shoppingList.remove(at: index)
                
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

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(viewModel: ShoppingItemViewModel(), selectedItem: .constant(nil), item: nil)
    }
}
