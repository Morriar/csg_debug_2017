# Intelligent Doors 

Some restricted areas of the Dome are controlled by autonomous doors driven with an automatic deep-learning AI able to apply complex and heterogeneous business rules.

In order to train the AI, a test program is used to encode and check the various rules.

## Description

This program applies rules according to the content of specific text files.
The various rules are explained in the source code.

A sample of data is provided in the `data/` directory.
Expected output is available in the `expected_result` file.

## Usage

The program takes no arguments and will inspect files in the `data/` directory.
For each file in the directory it prints acceptation or rejection orders. 

~~~
./test.sh
~~~

## Developers

Useful commands:

	make test
