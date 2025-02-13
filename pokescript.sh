#!/bin/bash

#Verificar que se haya colocado un parámetro.
if [ -z "$1"]; then
    echo "Error: Debes proporcionar el nombre de un Pokémon"
    exit 1
fi

#Nombre de Pokémon
POKEMON_NAME = $1

#URL de la PokeAPI
API_URL = "https://pokeapi.co/api/v2/$POKEMON_NAME"

RESPONSE = $(curl -s "$API_URL")

if echo "$RESPONSE" | jq -e '.id'> /dev/null 2> &1; then
    ID = $(echo "$RESPONSE" | jq '.id')
    NAME = $(echo "$RESPONSE" | jq -r '.name')
    WEIGHT = $(echo "$RESPONSE" | jq '.weight')
    HEIGHT = $(echo "$RESPONSE" | jq '.height')
    ORDER = $(echo "$RESPONSE" | jq '.oder')
    
    #Imprimir los datos
    echo "${NAME^}(No. $ID)"
    echo "ID =$ID"
    echo "Weight = $WEIGHT"
    echo "Height = $HEIGHT"
    echo "Order = $ORDER"

    #Crear o concatenar el archivo CSV
    CSV_FILE = "pokemon_data.csv"
    if [! -f "$CSV_FILE"]; then
        echo "id,name,weight,height,order" > "$CSV_FILE"
    fi
    echo "$ID,$NAME,$WEIGHT,$HEIGHT,$ORDER">> "$CSV_FILE"

else
    echo "Error: No se ve al Pokémon '$POKEMON_NAME'."
    exit 1
fi