__kernel void computeCellByCell(__global float* matrix1,
                                __global float* matrix2,
                                __global int    op_code,
                                __global float* matOut)
{
//multiply the matricies cell by cell
    if(op_code == 0){                       /*OP_CODE 0 -> multiply*/
        matOut[get_global_id(0)] = matrix1[get_global_id(0)] * matrix2[get_global_id(0)];
    }else if(op_code == 1){                 /*OP_CODE 1 -> divide*/
        matOut[get_global_id(0)] = matrix1[get_global_id(0)] / matrix2[get_global_id(0)];
    }else if(op_code == 2){                 /*OP_CODE 1 -> sum*/
        matOut[get_global_id(0)] = matrix1[get_global_id(0)] + matrix2[get_global_id(0)];
    }else if(op_code == 3){                 /*OP_CODE 1 -> subtract*/
        matOut[get_global_id(0)] = matrix1[get_global_id(0)] - matrix2[get_global_id(0)];
    }else{
        matOut[get_global_id(0)] = 255.0f; //white so we know we have wrong OP_CODE
    }
}
