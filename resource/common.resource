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
    Log To Console    ${\n}==============================================================================

    Log To Console    --- Criando massa de teste do novo usuário..
    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=1234
    ...    administrador=true
    Log To Console    --- Dados do usuário: ${\n}${body}

    Log To Console    --- Cadastrando novo usuário
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ServerRest    url=https://serverest.dev    headers=${headers}
    ${resposta}    POST On Session
    ...    alias=ServerRest    url=/usuarios    json=${body}    expected_status=201    
    Status Should Be
    ...    201
    ...    ${resposta}
    ...    msg=É esperado que o status da requisição seja "201" mas retornou ${resposta.status_code}!
    Should Be True
    ...    "${resposta.reason}" == "Created"
    ...    msg=É esperado que o reason da requisição seja "Created" mas retornou ${resposta.reason}!
    Log To Console    --- Usuário cadastrado com sucesso!
    ${id}    Get Value From Json    ${resposta.json}    $._id

    RETURN    ${id}

Verificar se o usuário foi cadastrado com sucesso
    [Arguments]    ${id}    ${name}    ${email}
    Log To Console    OK
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ServerRest    url=https://serverest.dev    headers=${headers}
    ${resposta}    GET On Session    alias=ServerRest    url=/usuarios
    Dictionary Should Contain Item    ${resposta.json()}    _id    ${id}
    Dictionary Should Contain Item    ${resposta.json()}    nome    ${name}
    Dictionary Should Contain Item    ${resposta.json()}    email    ${email}

Teardown
    Run Keyword If Timeout Occurred    Log    Esse teste demorou demais, possível problema de performance!
