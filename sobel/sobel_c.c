#include <math.h>
#define I(a,b,c) a[(b)*(cols*comp)+((c)*comp)+(d)]
#define MIN(a,b) (((a)>(b))?(b):(a))

extern const int comp;

void sobel (unsigned char *data, unsigned char* out, long rows, long cols){
	int r, c, d, v;
	int gx, gy;
	r = c = d = v = 0;
	gx = gy = 0;
	
	for(r = 1; r < (rows)-1; r++)
	for(c = 1; c < (cols)-1; c++)
	for(d = 0; d < comp; d++) {
			gx = -I(data, r-1, c-1) + I(data, r-1, c+1) +
			     -2*I(data, r, c-1) + 2*I(data, r, c+1) +
			     -I(data, r+1, c-1) + I(data, r+1, c+1);
			gy = -I(data, r-1, c-1) - 2*I(data, r-1, c) - I(data, r-1, c+1) + 
			      I(data, r+1, c-1) + 2*I(data, r+1, c) + I(data, r+1, c+1);
			v = (float)sqrt((float)(gx) * (float)(gx)+
					    (float)(gy) * (float)(gy));
			I(out, r, c) = MIN(v,255);
	}
}
