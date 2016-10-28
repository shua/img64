//https://github.com/nothings/stb/blob/master/stb_image.h

// Basic usage (see HDR discussion below for HDR usage):
//    int x,y,n;
//    unsigned char *data = stbi_load(filename, &x, &y, &n, 0);
//    // ... process data if not NULL ...
//    // ... x = width, y = height, n = # 8-bit components per pixel ...
//    // ... replace '0' with '1'..'4' to force that many components per pixel
//    // ... but 'n' will always be the number that it would have been if you said 0
//    stbi_image_free(data)

#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION
//this line needs to be defined before the include 

#include <stdio.h>
#include "stb_image.h"
#include "stb_image_write.h"
#include "px.c"

char* argv0;

const int comp = 1;

void mean (unsigned char *data, unsigned char* out, long rows, long cols);

void usage() {
	printf("usage: %s FILE [OUT]\n", argv0);
	exit(1);
}

int main(int argc, char** argv){
	int x,y,n,i;
	unsigned char *data;
	unsigned char *tmp;
	unsigned char *final;
	char *infile,*outfile;

	argv0 = argv[0];
	switch(argc) {
	case 1: usage();
	case 2: 
		infile=argv[1]; 
		outfile="out.bmp";
		break;
	default: 
		infile=argv[1]; 
		outfile=argv[2]; 
		break;
	}

	data = stbi_load(infile, &x, &y, &n, 3);
	final = calloc((x+200)*(y+200), 3);
	printf("opened %s: %d %d %d\n", infile, x, y, n);
//	printmat(data, y, x, 3);

	pxpad(data, final, y, x, 3, 100);

//	mean(data, final, y, x);

//	free(data); data = final;
//	final = calloc(x*y, 3);
//	pxconv(data, final, x*y, 1, 3, g2rgb);

 	stbi_write_bmp(outfile, x+200, y+200, 3, final);
	return 0;
}
