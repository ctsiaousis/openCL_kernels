__kernel void img_interpolate(__write_only image2d_t out,
			      __read_only image2d_t image1,
			      int W, int H,
			      float sinTheta, float cosTheta,
			      __global float* infoIn)
{
    int2 pos = (int2)(get_global_id(0),get_global_id(1));
    float x0 = W/2.0f;
    float y0 = H/2.0f;
    float xOff = ((float)pos.x)-x0;
    float yOff = ((float)pos.y)-y0;
    int xpos = (int)( xOff*cosTheta + yOff*sinTheta + x0);
    int ypos = (int)( yOff*cosTheta - xOff*sinTheta + y0);	int2 posNew;
    posNew.x = xpos;
    posNew.y = ypos;	//Interpolation
    float2 wA = (float2)(infoIn[0],infoIn[1]) ;
    float2 wB = (float2)(infoIn[2],infoIn[3]) ;
    float2 wC = (float2)(infoIn[4],infoIn[5]) ;
    float2 wD = (float2)(infoIn[6],infoIn[7]) ;
    float distX_AB = W;
    float distX_CD = W;
    float distY_AD = H;
    float distY_BC = H;    
    float xVertical_AB 		= (float)pos.x/distX_AB;
    float probX_AB 		= (1-xVertical_AB)*wA.x + xVertical_AB*wB.x;
    float xVertical_CD 		= (float)pos.x/distX_CD;
    float probX_CD 		= (1-xVertical_CD)*wD.x + xVertical_CD*wC.x;
    float xVertical_AB_CD	= pos.y/distY_AD;
    float probX 		= (1-xVertical_AB_CD)*probX_AB + xVertical_AB_CD*probX_CD;
    float yHorizontal_AD 	= (float)pos.y/distY_AD;
    float probY_AD		= (1-yHorizontal_AD)*wA.y + yHorizontal_AD*wD.y;
    float yHorizontal_BC	= (float)pos.y/distY_BC;
    float probY_BC		= (1-yHorizontal_BC)*wB.y + yHorizontal_BC*wC.y;
    float yHorizontal_AD_BC	= pos.x/distX_AB;
    float probY			= (1-yHorizontal_AD_BC)*probY_AD + yHorizontal_AD_BC*probY_BC;  

    int2 wNewPos		= (int2)(pos.x+probX,pos.y+probY);

    uint4 pix			= read_imageui(image1,wNewPos);
    write_imageui(out,pos,pix);
}
