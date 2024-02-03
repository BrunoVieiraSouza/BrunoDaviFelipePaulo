# README.md

## Introdução

Este projeto é um aplicativo iOS desenvolvido como parte de uma atividade acadêmica pela turma de desenvolvimento mobile. O aplicativo "Compras USA" foi criado usando Swift e SwiftUI, e é projetado para auxiliar os usuários na gestão de suas compras realizadas nos Estados Unidos. Ele oferece funcionalidades como o registro de produtos, cálculo automático de impostos, conversão de moeda e um resumo detalhado das compras.
## Telas
<img src="https://github.com/BrunoVieiraSouza/BrunoDaviFelipePaulo/assets/19232807/b513a110-f552-418d-ba94-1e4046113430" width="150" height="300">
<img src="https://github.com/BrunoVieiraSouza/BrunoDaviFelipePaulo/assets/19232807/7ae39c82-44e2-4d44-b8ba-237429712a1f" width="150" height="300">
<img src="https://github.com/BrunoVieiraSouza/BrunoDaviFelipePaulo/assets/19232807/956a4195-580b-43eb-9e3f-82d441805c31" width="150" height="300">
<img src="https://github.com/BrunoVieiraSouza/BrunoDaviFelipePaulo/assets/19232807/89821cef-ab0b-46a9-8342-1c54829c0d90" width="150" height="300">
<img src="https://github.com/BrunoVieiraSouza/BrunoDaviFelipePaulo/assets/19232807/4266ceea-a755-4a4b-85e2-6ae655e13f5d" width="150" height="300">

## Recursos

- **Cadastro de Produtos**: Permite adicionar produtos com detalhes como fotos, nome, valor e imposto aplicável.
- **Gestão de Compras**: Facilita a visualização e gerenciamento dos itens comprados.
- **Cálculo de Impostos**: Calcula automaticamente o valor dos produtos com base nos impostos informados.
- **Conversão de Moeda**: Converte o valor total das compras para a moeda local (Real), utilizando a taxa de câmbio configurada pelo usuário.
- **Ajustes**: Permite a configuração da taxa de câmbio do dólar e da porcentagem do IOF para cálculos mais precisos.

## Tecnologias Utilizadas

- **SwiftUI**: Utilizado para construir a interface do usuário de forma declarativa, promovendo uma experiência responsiva e intuitiva.
- **SwiftData**: Empregado para gerenciar os dados do modelo de forma eficiente, oferecendo uma alternativa simplificada ao CoreData para operações de persistência de dados.
- **PhotosUI**: Integração com a biblioteca de fotos do dispositivo, permitindo que os usuários selecionem imagens para associar aos itens cadastrados.

## Configuração e Instalação

Para preparar e executar o projeto, siga os passos abaixo. É necessário ter o Xcode instalado em um sistema macOS:

1. Clone o repositório do projeto para sua máquina local.
```bash
git clone [URL_DO_REPOSITORIO]
```

2. Navegue até o diretório do projeto.
```bash
cd [NOME_DO_PROJETO]
```

3. Abra o arquivo do projeto no Xcode.
```bash
open [NOME_DO_PROJETO].xcodeproj
```

4. Execute o projeto utilizando o simulador iOS ou um dispositivo físico conectado.

## Estrutura do Projeto

A estrutura do projeto é delineada pelas seguintes classes e componentes principais:

- **`ComprasUSAApp`**: Classe principal que inicia o aplicativo e configura o container de dados.
- **`ShoppingItem`**: Modelo de dados que representa um item de compra, incluindo propriedades para imagem, título, valor do item, imposto e método de pagamento.
- **Views**:
    - **`ContentView`**: A view principal que organiza as abas de navegação do aplicativo.
    - **`FormItemView`**: Permite aos usuários adicionar ou editar informações de um item de compra.
    - **`ShoppingItemRowView`**: Exibe uma linha na lista de compras, mostrando detalhes do item.
    - **`AjustesView`**: View para ajustar configurações como a taxa de câmbio e a porcentagem de IOF.
    - **`ResumoCompraView`**: Apresenta um resumo das compras, incluindo cálculos de imposto e a conversão total para a moeda local.

---
