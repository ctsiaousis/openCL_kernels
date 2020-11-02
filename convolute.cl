__kernel void convolute(__read_only image2d_t imageIN,
                        __write_only image2d_t out,
                        int W, int H,
                        int n, int m,
                        __global float* filter)
{
// Convolute the imageIN with the {n,m} filter
    int width = W;
    int height = H;
    int dimN = n/2;
    int dimM = m/2;
    int2 startImageCoord = (int2) (get_global_id(0) - dimN, get_global_id(1) - dimM);
    int2 endImageCoord   = (int2) (get_global_id(0) + dimN, get_global_id(1) + dimM);
    int2 outImageCoord = (int2) (get_global_id(0), get_global_id(1));    
    float4 convPix = (float4)(0.0f,0.0f,0.0f,255.0f);
    float4 temp;
    uint4 pix;    
    if (outImageCoord.x < width && outImageCoord.y < height)
    {
        int counter = 0;
        for( int x = startImageCoord.y; x <= endImageCoord.y; x++)
        {
            for( int y = startImageCoord.x; y <= endImageCoord.x; y++)
            {
                pix = read_imageui(imageIN,(int2)(y,x));
                temp = (float4)((float)pix.x, (float)pix.y, (float)pix.z, (float)pix.w);                
		convPix += (float4) (temp * filter[counter]);
                convPix = fabs(convPix);
                counter += 1;
            }
        }
        pix = (uint4)((uint)convPix.x, (uint)convPix.y, (uint)convPix.z, (uint)255);
        write_imageui(out, outImageCoord, pix);
    }
}
