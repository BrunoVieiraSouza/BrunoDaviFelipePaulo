//
//  AddItemView.swift
//  ComprasUSA
//
//  Created by Bruno Vieira Souza on 01/02/24.
//

import PhotosUI
import SwiftData
import SwiftUI

struct FormItemView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @Bindable var selectedItem: ShoppingItem
    @State private var selectedImage: PhotosPickerItem?
    @State private var posterImageData: Data?
    
    init(item: ShoppingItem? = nil) {
        selectedItem = item ?? ShoppingItem()
    }
    
    
    var body: some View {
        VStack {
            form
            button
        }
        
    }
    
    private var form: some View {
        Form {
            Section(header: Text("NOME DO PRODUTO")) {
                TextField("Nome do Produto", text: $selectedItem.title)
            }
            Section(header: Text("IMPOSTO DO ESTADO %")) {
                TextField("Imposto do Estado", text: $selectedItem.itemTax)
                    .keyboardType(.decimalPad)
                    .onTapGesture {
                        hideKeyboard()
                    }
            }
            Section(header: Text("VALOR DO PRODUTO (U$)")) {
                TextField("Valor do Produto", text: $selectedItem.itemValue)
                    .keyboardType(.decimalPad)
                    .onTapGesture {
                        hideKeyboard()
                    }
            }
            
            Section(header: Text("MEIO DE PAGAMENTO")) {
                Toggle("Pagou com Cartão", isOn: $selectedItem.paidWithCard)
            }
            
            Section(header: Text("FOTO")) {
                PhotosPicker(
                    selection: $selectedImage,
                    matching: .images
                ) {
                    Label("Selecione uma foto", systemImage: "photo")
                }
                
                if let posterImageData,
                   let uiimage = UIImage(data: posterImageData) {
                    Image(uiImage: uiimage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 10)
                }
            }
        }
        .navigationTitle("Cadastro de Produto")
    }
    
    private var button: some View {
        Button(action: {
            modelContext.insert(selectedItem)      
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cadastrar")
        }
        .disabled(!formIsValid())
    }
    
    private func formIsValid() -> Bool {
        return !selectedItem.title.isEmpty && !selectedItem.itemTax.isEmpty && !selectedItem.itemValue.isEmpty
    }
}

#Preview {
    do {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ShoppingItem.self, configurations: configuration)
        let item = ShoppingItem(imageName: "", title: "Banana", itemTax: "2", itemValue: "10", paidWithCard: true)
        return FormItemView(item: item).modelContainer(container)
    } catch {
        fatalError("Não consegui criar o Preview")
    }
}
