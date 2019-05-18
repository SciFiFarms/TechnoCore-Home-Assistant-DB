#!/bin/sh

until createuser home_assistant;
do
    echo "Sleeping"
    sleep 3
done
echo "Created user home_assistant"
