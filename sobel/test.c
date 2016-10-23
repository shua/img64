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

char* argv0;

const int comp = 4;

void sobel (unsigned char *data, unsigned char* out, long rows, long cols);
void pack_in (unsigned char *data, long rows, long cols, long depth);

void pack_in (unsigned char *data, long rows, long cols, long depth) {
	int p,i;
	for(p=1; p<(rows*cols); p++)
	for(i=0; i<depth; i++)
		data[p*depth + i] = data[p*comp + i];
}

void usage() {
	printf("usage: %s FILE [OUT]\n", argv0);
	exit(1);
}

int main(int argc, char** argv){
	int x,y,n;

	unsigned char *data;
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

	data = stbi_load(infile, &x, &y, &n, comp);
	final = calloc(x*y, comp);
	sobel(data, final, y, x);
	pack_in(final, y, x, 3);

 	stbi_write_bmp(outfile, x, y, 3, final);
	return 0;
}
