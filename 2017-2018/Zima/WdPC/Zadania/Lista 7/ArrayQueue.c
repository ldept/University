#include <stdio.h>
#include <stdlib.h>

struct ArrayQueue {
int *t;
size_t size; // Liczba elementów w kolejce
size_t first; // Indeks pierwszego elementu w kolejce
size_t capacity; // Wielkość tablicy
};

struct ArrayQueue make_queue(size_t initial_capacity)
{
    int *t = (int*) malloc(initial_capacity*sizeof(int));
    struct ArrayQueue q = {t,0,0,initial_capacity};
    return q;
}
void push_last(struct ArrayQueue *q, int value)
{
    if(q->size == q->capacity)
    {
        q->capacity *= 2;
        q->t = realloc(q->t,(q->capacity)*sizeof(int));

        int pierwszy = q->first;
        for(int i = 0; i < q->size; i++ )
        {
            q->t[(pierwszy+i)] = q->t[(pierwszy+i)%(q->capacity/2)];
        }
    }

    q -> t[ (q->size + q->first) % q->capacity] = value;
    q -> size++;

}
int pop_first(struct ArrayQueue *q)
{

    int r = q -> t[ q->first ];
    q ->first = (q->first+1) % q->capacity;
    q ->size--;




    return r;
}

int main()
{
    struct ArrayQueue q = make_queue(1);
    for (int i = 0; i < 4; i++) push_last(&q, i);
    printf("%lu %lu %lu,", q.size, q.first, q.capacity);

    for (int i = 0; i < 7; i++) {

    printf(" %i", pop_first(&q));
    push_last(&q, i);

    }

    push_last(&q, 0);
    printf(", %i, %lu %lu %lu\n", pop_first(&q), q.size, q.first, q.capacity);
}
