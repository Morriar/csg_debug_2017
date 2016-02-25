# Domesec

Language: Go

As with any advanced facilities, security is primordial for the Dome.

For security checks when our brave soldiers come back from the exterior of the dome, we need the security X-Ray scanner to be on top when it comes to reliability to avoid foreign objects from ever penetrating the Dome.

To do so, we check the outlines of objects within the effects of anyone coming back to the dome.
This is done with a Sobel operator, an old pre-dome algorithm for Edge detection.
This has times and times again proven its reliability and efficiency.

However, the Sobel algorithm we use is based on Black and White PPM images, therefore, to convert regular coloured images to black and white, we use an internal converter based on luminance values.

This program now seems to be broken, we need you to fix it as fast as you can, each second it remains broken endangers the Dome and the Empire even more.

## Description

The program works with 3 simple steps:

* Parsing of the input coloured PPM image
* Luminance computations and producing of the Black and White image
* Writing the b/w image to a new PPM file

All is done in Go to facilitate parallelism, our research suggests the language is very adapted for this.

PPM files are image formats which are most certainly expensive in space, but are very easy to parse and generate.
The dome is an advanced technology, and so are the machines within it, a few megabytes of image data does not scare us !

It works by having 3 lines with the informations on an image:

* P3, a magic word stating that the image is stored using ASCII codes for colours, in RGB format
* width, height: two ASCII numbers
* maximum size of a colour description (usually 255)

After these informations are the colour values, in triplets, first is Red, then Green, and finally Blue.

## Usage

The converter take two arguments when executed: source image and destination image.

	./bw source.ppm output.ppm

