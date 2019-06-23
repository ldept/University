#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

uint64_t minimum(uint64_t a, uint64_t b);

uint64_t distance(int a, int b, uint64_t s[], int length);

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

uint64_t minimum(uint64_t a, uint64_t b){
    if(a < b){
        return a;
    }else return b;
}

uint64_t distance(int a, int b,uint64_t s[], int length){
    if(a == 1){
        return minimum(s[b-2], (s[length - 1] - s[b-2]));
    }
    else if (a == 2){
        return minimum(s[b-2] - s[a-2], (s[length - 1] - s[b-2] + s[a-2]));
    }else return minimum(s[b-2] - s[a-2], (s[length - 1] - s[b-2] + s[a-2]));
}

uint64_t find_farthest_houses(uint64_t s[],int length){  // caterpillar method
    uint64_t max = 0;    // max path between two houses

    int start = 0;
    /*
    int end = 1; // start&end of subsequences

    uint64_t dst = distance(start+1, end+1, s, length);
    */
    int endptr = 1;
    
    while(start < endptr && endptr < length){
        uint64_t left,right;
        if(start != 0){
            left = s[endptr-1] - s[start-1];
            right = s[length-1] - s[endptr-1] + s[start-1];
        }else{
            left = s[endptr-1];
            right = s[length-1] - s[endptr-1];
        }
        if( left > right ){
            if( right > max ) max = right;
            start++;
        }else{
            if( left > max ) max = left;
            endptr++;
        } 
    }/*
    for(int i = 0; i < length-1; i++){
       if(end <= i){
           end = i+1;
       } 
       uint64_t dst1 = distance(i+1,end+1,s,length);
       if(dst1 > dst){
           end--;
       }
       while (end < length && (dst = distance(i+1,end+1,s,length)) >= max){
           printf("while:   i: %d, end: %d, dst: %"SCNu64 "\n",i,end, dst);
           max = dst;
           end++;   
           
           
       }
       if(end == length) end--;
       printf("for:     i: %d, end: %d, dst: %"SCNu64 "\n",i,end, dst);
    }
    */
    /* BruteForce
    for(int i = 0; i<length-1; i++){
        for(int j = i+1; j<length; j++){
            dst = distance(i+1,j+1,s,length);
            if (dst > max) {
                max = dst;
            }
        }
    }
    */
    /*while(start < length){
        dst = distance(start+1,end+1,s,length);

        while (end < length && dst >= max){
            max = dst;
            dst = distance(start+1, end+1, s, length);
            end++;
        }
        if(dst > max) max = dst;
        end--;
        start++;
        
    }*/
    return max;
}