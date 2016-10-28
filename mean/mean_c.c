#include <math.h>
#define I(a,b,c) a[((b)*cols+(c))*comp+(d)]
#define MIN(a,b) (((a)>(b))?(b):(a))

extern const int comp;

void mean (unsigned char *data, unsigned char* out, long rows, long cols, long N){
	int r, c, d, i, j;
	float v;
	v = 0.f;

	for(r = N; r < (rows)-N; r++)
	for(c = N; c < (cols)-N; c++)
	for(d = 0; d < comp; d++) {
		v = 0.f;
		for(i=-N; i<=N; i++)
		for(j=-N; j<=N; j++) {
			v += I(data, r+i, c+j);
		}
		v /= N*N;
		I(out, r, c) = (long)MIN(v,255);
	}
}
