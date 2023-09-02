*** Settings ***
Library     RequestsLibrary
Library     String

*** Keywords ***
Criar um usuário novo
    ${palavra_aleatoria}    Generate Random String    4
    Set Test Variable    ${EMAIL_TESTE}    ${palavra_aleatoria.lower.lower()}@emailteste.com
    Log    Minha palavra aleatoria: ${EMAIL_TESTE}

Cadastrar o usuário criado na ServerRest
    ${body}    Create Dictionary
    ...    nome=Fulado da Silva
    ...    email=${EMAIL_TESTE}
    ...    password=1234
    ...    administrador=true

    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ServerRest    url=https://serverest.dev    headers=${headers}
    ${resposta}    POST On Session    alias=ServerRest    url=/usuarios    json=${body}

    Log    ${resposta.json()}

Verificar se o usuário foi cadastrado com sucesso

Teardown
    Run Keyword If Timeout Occurred    Log    Esse teste demorou demais, possível problema de performance!
