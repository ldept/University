#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <algorithm>

struct point {
    int x,y;
};

point P1, P2;


double distance(const point &p1,const point &p2){
    long long int p2x = p2.x, p2y =p2.y, p1x =p1.x, p1y =p1.y;
    return sqrt((p2x - p1x)*(p2x - p1x) + (p2y - p1y)*(p2y - p1y));
}

double bruteforce(const point* parr,const int &n){
    double d = __DBL_MAX__;
    for(int i = 0; i<n; i++){
        for(int j = i+1; j<n; j++){
            if(distance(parr[i],parr[j]) < d){
                d = distance(parr[i],parr[j]);
                P1 = parr[i];
                P2 = parr[j];
            }
        }
    }
    return d;
}

double process_middle(point* midpoints, int &n, double &dist){
    double d = dist;
    for(int i =0; i<n; i++){
        for(int j = i+1; j<n && (midpoints[j].y - midpoints[i].y) < d; j++){
            if(distance(midpoints[i],midpoints[j]) < d){
                P1 = midpoints[i];
                P2 = midpoints[j];
                d = distance(midpoints[i],midpoints[j]);
            }
        }
    }
    /*for(int i = 0; i<n; i++){
        for(int j = 0; j<15; j++){
            if(distance(midpoints[i],midpoints[j]) < d){
                P1 = midpoints[i];
                P2 = midpoints[j];
                d = distance(midpoints[i],midpoints[j]);
            }
        }
    }*/
    return d;
}

int compareX(point &p1, point &p2){
    return (p1.x < p2.x);
}
int compareY(point &p1, point &p2){
    return (p1.x < p2.x);
}

double dothework(point* sortedX, point* sortedY, int n){
    //if(n == 2){
    //    P1 = sortedX[0];
    //    P2 = sortedY[1];
    //    return distance(sortedX[0],sortedX[1]);
    //}
    if (n <= 3){
        return bruteforce(sortedX,n);
    }
    else{
        int middle = n/2;

        point *sortedLeft = (point*) malloc((middle+1) * sizeof(point));
        point *sortedRight= (point*) malloc((n-middle-1) * sizeof(point));
        int left=0,right=0;

        for(int i = 0; i < n; i++){
            if(sortedY[i].x <= sortedX[middle].x){
                sortedLeft[left] = sortedY[i];
                left++;
            }
            else {
                sortedRight[right] = sortedY[i];
                right++;
            }
        }

        //split in two subproblems, solve
        double leftdist = dothework(sortedX,sortedLeft,middle);
        double rightdist = dothework(sortedX,sortedRight,n-middle);
        double d = (leftdist < rightdist) ? leftdist : rightdist;

        //array for points in distance d from the middle (size n just in case)
        point *midpoints = (point*) malloc(n*sizeof(point));
        int size = 0;

        //populate midpoints array as above
        for(int i = 0; i<n; i++){
            if(abs(sortedY[i].x - sortedX[middle].x) < d){
                midpoints[size] = sortedY[i];
                size++;
            }
        }

        //backups, because process_middle may overwrite good ones (or not? better be safe)
        point P1b = P1;
        point P2b = P2;
        double result = process_middle(midpoints, size, d);

        if(d < result){
            P1 = P1b;
            P2 = P2b;
            free(midpoints);
            free(sortedLeft);
            free(sortedRight);
            return d;
        }
        else {
            free(midpoints);
            free(sortedLeft);
            free(sortedRight);
            return result;
        }

    }
}

double closest_pair(point* p, int n){
    point *sortedX = (point*) malloc(sizeof(point) * n);
    point *sortedY = (point*) malloc(sizeof(point) * n);
    
    for(int i = 0; i<n; i++){
        sortedX[i] = p[i];
        sortedY[i] = p[i];
    }

    std::sort(sortedX,sortedX+n,compareX);
    std::sort(sortedY,sortedY+n,compareY);
    double d = dothework(sortedX,sortedY,n);
    free(sortedX);
    free(sortedY);
    return d;
}
int main(){
    int n;
    scanf("%d",&n);
    point *P = (point*) malloc(n * sizeof(point));

    for(int i = 0; i<n; i++){
        scanf("%d %d",&(P[i].x), &(P[i].y));
    }
    
    n = closest_pair(P,n);

    printf("%d %d\n", P1.x,P1.y);
    printf("%d %d\n", P2.x,P2.y);

    //printf("%d %d\n", pairx1,pairy1);
    //printf("%d %d\n", pairx2,pairy2);

    
    
    free(P);
    return 0;
}