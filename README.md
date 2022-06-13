# Seeder App

Um app para manejo de sementes desenvolvido em Dart/Flutter

## Descrição

O app visa ajudar agricutores a manter o controle do seu estoque
de sementes. Por meio dele, é possível cadastrar novas sementes, informando
seu nome, fabricante, data de fabricação e data de validade.

O app utiliza como "source of truth" o banco de dados local(utilizando o pacote sqflite).
Sendo assim, todos os dados mostrados na interface são lidos diretamente do banco de dados. Quando 
o agricultor cadastra novas sementes, elas são armazenadas localmente e ele pode sincronizá-las com o servidor 
quando possuir conexão com a internet. Quando o agricultor faz login e já possui sementes cadastradas
no servidor, elas são lidas(mediante o pacote http), armazenas localmente e em seguida mostradas ao usuário. 

O app possui um sistema de autenticação composto por email, no caso do login, e email e nome completo quando 
é feito um cadastro. O objetivo é poder identificar quem cadastrou cada semente armazenada no servidor. Uma tabela
do banco de dados é utilizada para armazenar os dados do usuário logado. 

## Estrutura do Projeto

A lógica principal da aplicação se encontra no diretório lib. Nos subdiretórios

- MODELS, localizam-se as classes que transportam os dados manipulados na aplicação.
- DATABASE, encontram-se o banco de dados e seus respectivos DAOs
- NETWORK, está a lógica de requisições e respostas http.
- EXCEPTIONS, estão as exceptions criadas para informar o usuário de problemas ocorridos na aplicação.
- MAPPERS, classes responsáveis por fazer a conversão entre tipos criados dentro da aplicação
- REPOSITORIES, situam-se componentes que abstraem as fontes de dados dos providers.
    Estes não possuem conhecimento se os dados vem do banco de dados, serviços http ou shared preferences, por exemplo.
- PROVIDERS, estão os intermediários entre ui  e repositórios(a ui somente conhece os providers
- e retira todos os dados que serão mostrados na tela deles).
- UTILS,classes as quais possuem métodos utilizados em diversas partes da aplicação.
- VALIDATORS, dispõem-se classes responsáveis por lógicas de validação, como validação de nome e email.
- UI, estão as classes que mostram os dados aos usuários ou os coletam para armazenamento(screens são componentes que ocupam a tela inteira,
já os widgets são subpartes das telas, que foram criados para reaproveitamento de código, pois são utilizados mais de uma vez na mesma tela
ou em diferentes telas).

## Para conhecer mais sobre Flutter
- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

