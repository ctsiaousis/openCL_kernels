__kernel void computeWeightMap(__read_only image2d_t imageIN1,
                               __read_only image2d_t imageIN2,
                               __write_only image2d_t out1,
                               __write_only image2d_t out2)
{
// foreach pixel of the 2 images, compute max of imgIN(i).<x,y>
// and return out(i).<x.y>=1 and 0 to the other out image
    int2 pos = (int2)(get_global_id(0), get_global_id(1));    
    uint4 pix1 = read_imageui(imageIN1,pos);
    uint4 pix2 = read_imageui(imageIN2,pos);
    float max1 = 0.0f;
    float max2 = 0.0f;    i
    float4 convPix1 = (float4)(pix1.x, pix1.y, pix1.z, pix1.w);
    float4 convPix2 = (float4)(pix2.x, pix2.y, pix2.z, pix2.w);    for(int i = 0; i < 3; i ++){
        if(max1 < convPix1[i]){
            max1 = convPix1[i];
        }
        if(max2 < convPix2[i]){
            max2 = convPix2[i];
        }
    }    uint4 pixZero   = (uint4)((uint) 0, (uint) 0, (uint) 0, (uint) 255);
    uint4 pixOne = (uint4)((uint)255, (uint)255, (uint)255, (uint)255);
    if(max1 < max2){
        write_imageui(out1, pos, pixZero);
        write_imageui(out2, pos, pixOne);
    }else{
        write_imageui(out1, pos, pixOne);
        write_imageui(out2, pos, pixZero);
    }
}
