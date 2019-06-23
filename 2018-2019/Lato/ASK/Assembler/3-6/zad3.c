#include <stdio.h>
#include <stdlib.h>

/*void insert_sort(long* first, long *last){
    int n = last - first;
    int i, j;
    long key;
    for(i = 1; i < n+1; i++){
        j = i - 1;
        key = first[i];
        while ((j >= 0) && (first[j] > key)){
            first[j+1] = first[j];
            j--;
        }
        first[j+1] = key;

    }
}
*/
void insert_sort(long *first, long *last);

int main(){
    long *first = (long*) malloc(4*(sizeof(long)));
    first[0] = 4;
    first[1] = 2;
    first[2] = 1;
    first[3] = 3;
    for(int i = 0; i<4;i++){
        printf("%ld ", first[i]);
    }
    insert_sort(first,(&first[3]));
    for(int i = 0; i<4;i++){
        printf("%ld ", first[i]);
    }
}