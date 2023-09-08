*** Settings ***
Resource    ../resource/config.resource


*** Keywords ***
Criar um usuário novo
    ${palavra_aleatoria}    Generate Random String    4
    ${palavra_aleatoria}    Set Variable    ${palavra_aleatoria}
    ${nome}    Set Variable    ${palavra_aleatoria} Fulado da Silva
    ${email}    Set Variable    ${palavra_aleatoria.lower()}@emailteste.com
    RETURN    ${nome}    ${email}

Cadastrar o usuário criado na ServerRest
    [Arguments]    ${nome}    ${email}
    Log To Console    ${---}${\n}--- Criando massa de teste para novo usuário${---}
    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=1234
    ...    administrador=true
    Log To Console
    ...    Dados do usuário: ${\n}Nome: ${body}[nome] ${\n}Email: ${body}[email] ${\n}administrador: ${body}[administrador]

    Log To Console    ${\n}--- Cadastrando novo usuário
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ServerRest    url=https://serverest.dev    headers=${headers}    verify=${TRUE}
    ${resposta}    POST On Session    alias=ServerRest    url=/usuarios    json=${body}    expected_status=201
    Status Should Be
    ...    201
    ...    ${resposta}
    ...    msg=É esperado que o status da requisição seja "201" mas retornou ${resposta.status_code}!
    Should Be True
    ...    "${resposta.reason}" == "Created"
    ...    msg=É esperado que o reason da requisição seja "Created" mas retornou ${resposta.reason}!
    ${id}    Get From Dictionary    ${resposta.json()}    _id
    Log To Console    Usuário cadastrado com sucesso!\nId do usuário: ${id}

    RETURN    ${id}

Verificar se o usuário foi cadastrado com sucesso
    [Arguments]    ${id}    ${nome}    ${email}
    Log To Console    ${---}\nVerificando se o usuário foi cadastrado${---}
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ServerRest    url=https://serverest.dev    headers=${headers}    verify=${TRUE}
    ${resposta}    GET On Session    alias=ServerRest    url=/usuarios
    Log To Console    --- Filtrando títulos com id: ${id}
    @{usuario}    Get Value From Json    ${resposta.json()}    $..*[?(@._id=="${id}")]

    ${user_nome}    Get value from json    ${usuario}    $..nome    fail_on_empty=${TRUE}
    ${user_email}    Get value from json    ${usuario}    $..email    fail_on_empty=${TRUE}
    Should Be True    "${usuario}" != "[]"    msg=Não há usuário disponível com o ${id}!
    Should Be True
    ...    "${user_nome[0]}" == "${nome}"
    ...    msg=É esperado que o nome do usuário seja ${nome} mas foi retornado '${user_nome[0]}'!
    Should Be True
    ...    "${user_email[0]}" == "${email}"
    ...    msg=É esperado que o nome do usuário seja ${email} mas foi retornado '${user_email[0]}'!
    Log To Console    --- Usuário cadatrado com sucesso!

Teardown
    Run Keyword If Timeout Occurred    Log    Esse teste demorou demais, possível problema de performance!
