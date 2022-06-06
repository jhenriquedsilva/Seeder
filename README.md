# Seeder App

Um app para manejo de sementes desenvolvido em Dart/Flutter

## Descrição

O app visa ajudar agricutores a manter o controle do seu estoque
de sementes. Por meio dele, é possível cadastrar novas sementes, informando
qual seu nome, fabricante, data de fabricação e data de validade.

O app utiliza como 'source of truth' o banco de dados local(utilizando o pacote sqflite).
Sendo assim, todos os dados mostrados na interface são lidos diretamente do banco de dados. Quando 
o agricultor cadastra novas sementes, elas são armazenadas localmente e é dada a opção para
que ele possa sincronizá-las com o servidor. Mesmo quando o usuário faz login e já possui sementes cadastradas
no servidor, elas são lidas(mediante o pacote http), armazenas localmente e em seguida mostradas ao usuário. 

Ele possui um sistema de autenticação composto por email, no caso do login, e email e nome completo quando 
é feito um cadastro. Uma tabela do banco de dados é utilizada para armazenar os dados do usuário logado. 

## Estrutura do Projeto

O código fonte está localizado na pasta lib

- database: classes realicionadas ao banco: banco de dados e daos
- exceptions: classes que representam exceptions customizadas
- models: classes de dados manipuladas pelo app
- network: classes responsáveis pelas requisições http
- providers: classes responsáveis por preparar os dados para serem mostrados na tela
- repository: classes que representam uma abstração sobre o banco de dados e serviços web
- ui: classes responsáveis por mostrar os dados ao usuário

## Para conhecer mais sobre o flutter
- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

