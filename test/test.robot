*** Settings ***
Library             RequestsLibrary
Resource            ../resource/common.resource

Test Teardown       Teardown
Test Timeout        1 seconds


*** Test Cases ***
Cenário 01: Cadastrar um novo usuário com sucesso na ServerRest
    Criar um usuário novo
    Cadastrar o usuário criado na ServerRest
    Verificar se o usuário foi cadastrado com sucesso
