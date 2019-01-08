#!/bin/sh

until createuser homeassistant;
do
    echo "Sleeping"
    sleep 3
done
echo "Created user homeassistant"
