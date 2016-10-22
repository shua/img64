#define I(a,b,c) a[(b)*(cols*3)+((c)*3)+(d)]
#define MIN(a,b) (((a)>(b))?(b):(a))

void sobel (unsigned char *data, unsigned char* out, long rows, long cols){
	int r, c;
	int gx, gy;
	int d, v;
	r = c = gx = gy = 0;
	d = v = 0;
	
	for(d = 0; d < 3; d++)
	for(r = 1; r < (rows)-1; r++)
	for(c = 1; c < (cols)-1; c++) {
			gx = -I(data, r-1, c-1) + I(data, r-1, c+1) +
			     -2*I(data, r, c-1) + 2*I(data, r, c+1) +
			     -I(data, r+1, c-1) + I(data, r+1, c+1);
			gy = -I(data, r-1, c-1) - 2*I(data, r-1, c) -
			      I(data, r-1, c+1) + I(data, r+1, c-1) +
			      2*I(data, r+1, c) + I(data, r+1, c+1);
			v = (float)sqrt((float)(gx) * (float)(gx)+
					    (float)(gy) * (float)(gy));
			I(out, r, c) = MIN(v,255);
	}
}
