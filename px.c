typedef void (*pxfun) (unsigned char *i, unsigned char *o);

void g2rgb (unsigned char *i, unsigned char *o) {
	o[0] = o[1] = o[2] = i[0];
}

void rgb2g (unsigned char *i, unsigned char *o) {
	unsigned int v;
	v = i[0] + i[1] + i[2];
	v /= 3;
	o[0] = v;
}

void rgb_pa (unsigned char *i, unsigned char *o) {
	o[0] = i[0];
	o[1] = i[1];
	o[2] = i[2];
	o[3] = 255;
}

void pxcp1 (unsigned char *i, unsigned char *o) {
	o[0] = i[0];
}
void pxcp2 (unsigned char *i, unsigned char *o) {
	o[0] = i[0];
	o[1] = i[1];
}
void pxcp3 (unsigned char *i, unsigned char *o) {
	o[0] = i[0];
	o[1] = i[1];
	o[2] = i[2];
}
void pxcp4 (unsigned char *i, unsigned char *o) {
	o[0] = i[0];
	o[1] = i[1];
	o[2] = i[2];
	o[3] = i[3];
}
pxfun cp[4] = { pxcp1, pxcp2, pxcp3, pxcp4 };

void pxconv (unsigned char *i, unsigned char *o, long z, long si, long so, pxfun conv) {
	long p;
	for (p=0; p<z; p++)
		conv(i+(p*si), o+(p*so));
}

void
printmat(unsigned char *m, long rows, long cols, long depth) {
	long r,c,d;
	for(r=0; r<rows; r++) {
		for(c=0; c<cols; c++) {
			for(d=0; d<depth; d++) 
				printf("%02x", m[(r*cols+c)*depth+d]);
			printf(" ");
		}
		printf("\n");
	}
}


#define I(_r,_c,_cols) ((((_r)*(_cols))+(_c))*depth)
void pxpad (unsigned char *i, unsigned char *o, long rows, long cols, long depth, long border) {
	long r, c, ri, ci;
	for(r=0; r<(rows+2*border); r++) {
		ri = (r<border)? 0 : ((r>border+rows-1)?(rows-1):r-border);
		for(c=0; c<(cols+2*border); c++) {
			ci = (c<border)? 0 : ((c>border+cols-1)?(cols-1):c-border);
			cp[depth-1](i+I(ri,ci,cols), o+I(r,c,cols+2*border));
		}
	}
}

void pxcrop(unsigned char *i, unsigned char *o, long rows, long cols, long depth, long x1, long y1, long x2, long y2) {
	long r, c, ri, ci;
	for(r=0; r<y2-y1; r++)
	for(c=0; c<x2-x1; c++)
		cp[depth-1](i+I(r+y1,c+x1,cols), o+I(r,c,x2-x1));
}
#undef I
