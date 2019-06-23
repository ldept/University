#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

uint64_t find_farthest_houses(uint64_t s[],int length);

int main(){

    int houses;
    scanf("%d", &houses);
    
    uint64_t* sum = (uint64_t*) malloc(houses * (sizeof(uint64_t)));
    for(int i = 0; i < houses; i++){
 //       uint64_t s;
        scanf("%" SCNu64,&sum[i]);
        if(i != 0) sum[i] += sum[i-1];
    
    }

    printf("%" SCNu64 "\n", find_farthest_houses(sum,houses));
    free(sum);
}


uint64_t find_farthest_houses(uint64_t s[],int length){  // caterpillar method
    uint64_t max = 0;    // max path between two houses

    int startptr = 0;
    int endptr = 1;
    
    while(startptr < endptr && endptr < length){
        uint64_t left,right;
        if(startptr != 0){
            left = s[endptr-1] - s[startptr-1];
            right = s[length-1] - s[endptr-1] + s[startptr-1];
        }else{
            left = s[endptr-1];
            right = s[length-1] - s[endptr-1];
        }
        if( left > right ){
            if( right > max ) max = right;
            startptr++;
        }else{
            if( left > max ) max = left;
            endptr++;
        } 
    }
    return max;
}