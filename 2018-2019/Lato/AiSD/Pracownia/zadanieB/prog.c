#include <stdio.h>
#include <inttypes.h>

int main(){
    uint64_t M, k;
    scanf("%" SCNu64 " %" SCNu64, &M, &k);
    uint64_t mult;
    for(int i = 0; i<M; i++){
        for(int j = 0; j<i; j++){
            if(k == 0) break;
            mult = (M - i) * (M-j);
            printf("%" SCNu64, mult);
        }
        if(k == 0) break;
    }
}