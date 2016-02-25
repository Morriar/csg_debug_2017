# Intelligent Doors 

Language: shell

Some restricted areas of the Dome are controlled by autonomous doors driven with an automatic deep-learning AI able to apply complex and heterogeneous business rules.

In order to train the AI, a test program is used to encode and check the various rules.

## Description

This program applies rules according to the content of specific text files.
The various rules are explained in the source code.

A sample of data is provided in the `tests/data.in` directory.
Expected output is available in the `tests/data.res` file.

## Usage

The program takes the directory with the data as arguments.
For each file in the directory it prints acceptation or rejection orders. 

~~~
./src/doors.sh data
~~~

## Developers

Useful commands:

	make test
