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
    
    @Binding var selectedItem: ShoppingItem
    @State private var selectedImage: PhotosPickerItem?
    @State private var itemImage: Data?
    
    
    var body: some View {
        VStack {
            form
            button
        }
        
    }
    
    private var form: some View {
        Form {
            Section(header: Text("NOME DO PRODUTO")) {
                TextField("Nome", text: $selectedItem.title)
            }
            
            Section(header: Text("IMPOSTO DO ESTADO")) {
                TextField("Imposto do Estado", text: $selectedItem.itemTax)
                    .keyboardType(.decimalPad)
                    .onTapGesture {
                        hideKeyboard()
                    }
            }
            
            Section(header: Text("VALOR DO PRODUTO (U$)")) {
                TextField("Valor", text: $selectedItem.itemValue)
                    .keyboardType(.decimalPad)
                    .onTapGesture {
                        hideKeyboard()
                    }
            }
            
            Section(header: Text("MEIO DE PAGAMENTO")) {
                Toggle("Com o cartão?", isOn: $selectedItem.paidWithCard)
            }
            
            Section(header: Text("FOTO")) {
                PhotosPicker(
                    selection: $selectedImage,
                    matching: .images
                ) {
                    Label("Escolher foto", systemImage: "giftcard.fill")
                }
                
                if let data = selectedItem.selectedImage,
                   let uiimage = UIImage(data: data) {
                    Image(uiImage: uiimage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 10)
                }
            }
        }
        .listSectionSpacing(3)
        .navigationTitle(selectedItem.title.isEmpty ? "Cadastro de produto" : selectedItem.title)
        .onChange(of: selectedImage) {
            Task {
                itemImage = try? await selectedImage?.loadTransferable(type: Data.self)
                selectedItem.selectedImage = itemImage
            }

        }
    }
    
    private var button: some View {
        Button(action: {
            modelContext.insert(selectedItem)      
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Salvar")
        }
        .buttonStyle(.borderedProminent)
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
        return FormItemView(selectedItem: .constant(item)).modelContainer(container)
    } catch {
        fatalError("Não consegui criar o Preview")
    }
}
