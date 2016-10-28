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

const int comp = 3;

void mean (unsigned char *data, unsigned char* out, long rows, long cols);

void usage() {
	printf("usage: %s FILE [OUT] [N]\n", argv0);
	exit(1);
}

int main(int argc, char** argv){
	int x,y,n,i,N;
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
	case 3:
		infile=argv[1];
		outfile=argv[2];
		N=1;
		break;
	default: 
		infile=argv[1]; 
		outfile=argv[2]; 
		N=atoi(argv[3]);
		break;
	}

	data = stbi_load(infile, &x, &y, &n, comp);
	final = calloc((x+2*N)*(y+2*N), comp);
	printf("opened %s: %d %d %d\n", infile, x, y, n);

	pxpad(data, final, y, x, comp, N);
	x+=2*N;
	y+=2*N;
	free(data); data = final;
	final = calloc(x*y, 3);

	mean(data, final, y, x);
	for(i=1; i<N; i++) {
		tmp = final;
		final = data;
		data = tmp;
		mean(data, final, y, x);
	}
	tmp = final; final = data; data = tmp;

	pxcrop(data, final, y, x, comp, N, N, x-N, y-N);
	x-=2*N;
	y-=2*N;

//	pxconv(data, final, x*y, 1, 3, g2rgb);

 	stbi_write_bmp(outfile, x, y, 3, final);
	return 0;
}
