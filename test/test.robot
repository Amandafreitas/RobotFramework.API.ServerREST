*** Settings ***
Library             RequestsLibrary
Resource            ../resource/common.resource

Test Teardown       Teardown
# Test Timeout    1 seconds


*** Test Cases ***
Cenário 01: Cadastrar um novo usuário com sucesso na ServerRest
    ${nome}    ${email}    Criar um usuário novo
    ${id}    Cadastrar o usuário criado na ServerRest    ${nome}    ${email}
    Verificar se o usuário foi cadastrado com sucesso    ${id}    ${nome}    ${email}
