*** Settings ***
Library     RequestsLibrary
Library     String
Library     Collections
Library     JSONLibrary


*** Variables ***
${Base_URL}     https://serverest.dev
${headers}      Create Dictionary    accept=application/json    Content-Type=application/json
${---}          ${\n}--------------------------------------------------------------
