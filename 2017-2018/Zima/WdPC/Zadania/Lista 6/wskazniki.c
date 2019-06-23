#include <stdio.h>
void* malloc_pattern(size_t size, const void* pattern, size_t pattern_len)
{
    char *t = (char*) malloc(size);
    for(int i=0;i<size;i++)
    {
        t[i]=((char*)pattern)[i%pattern_len];
    }
    return t;
}
void* realloc_pattern(void* t, size_t old_size, size_t new_size, const void* pattern, size_t pattern_len)
{
    t = realloc(t,new_size);
    if (old_size < new_size)
    {
        for(int i=0;i<new_size-old_size;i++)
        {
            ((char*)t)[i+old_size]=((char*)pattern)[i%pattern_len];
        }
    }
    return t;

}

int main()
{
    const char *p1 = "ab";


    char* t = (char*)malloc_pattern(5, p1, 2);
    const char *p2 = "cd";
    t = (char*)realloc_pattern(t, 5, 10, p2, 2);
    printf("%.10s\n", t); // ababacdcdc
    free(t);
}
