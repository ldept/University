#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <algorithm>

struct point {
    int x,y;
};

point P1, P2;

int compareX(const point &p1, const point &p2){
    return (p1.x < p2.x);
}
int compareY(const point &p1,const point &p2){
    return (p1.y < p2.y);
}

double distance(const point &p1,const point &p2){
    long long int p2x = p2.x - p1.x, p2y = p2.y - p1.y;
    return sqrt(p2x*p2x + p2y*p2y);
}

double closest_pair(const point* Q, const point* X, const point* Y, const int &n){
    if(n < 2){
        return __DBL_MAX__;
    }
    else if (n == 2){
        P1 = Q[0];
        P2 = Q[1];
        return distance(P1,P2); 
    }
    point mid = X[n/2];
    point* XL = (point*) malloc(n/2 * sizeof(point));
    point* XR = (point*) malloc((n - n/2) * sizeof(point));
    point* YL = (point*) malloc(n/2 * sizeof(point));
    point* YR = (point*) malloc((n - n/2) * sizeof(point));
    int l = 0, r = 0;
    for(int i = 0; i < n; i++){
        if(X[i].x < mid.x){
            XL[l] = X[i];
            l++;
        }
        else{
            XR[r] = X[i];
            r++;
        }
    }
    l = 0; r = 0;
    for(int i = 0; i < n; i++){
        if(Y[i].x < mid.x){
            YL[l] = X[i];
            l++;
        }
        else{
            YR[r] = X[i];
            r++;
        }
    }
    double dl = closest_pair(XL,XL,YL,n/2);
    double dr = closest_pair(XR,XR,YR,n-n/2-1);
    double dmin = (dl < dr) ? dl : dr;
    point *midpoints = (point*) malloc(n*sizeof(point));
        int size = 0;

        //populate midpoints array as above
        for(int i = 0; i<n; i++){
            if(abs(Y[i].x - X[n/2].x) < dmin){
                midpoints[size] = Y[i];
                size++;
            }
        }
    
    for(int i = 0; i<size; i++){
        int mini = (size - i < 7) ? size - i : 7;
        for(int j = 0; j < mini; j++){
            if(distance(Q[i],Q[i+j]) < dmin){
                P1 = Q[i];
                P2 = Q[i+j];
                dmin = distance(Q[i],Q[i+j]);
            }
        }
    }
    return dmin;
}

double closest_pairr(const point* P, const int &n){
    point *sortedX = (point*) malloc(sizeof(point) * n);
    point *sortedY = (point*) malloc(sizeof(point) * n);
    
    for(int i = 0; i<n; i++){
        sortedX[i] = P[i];
        sortedY[i] = P[i];
    }

    std::sort(sortedX,sortedX+n,compareX);
    std::sort(sortedY,sortedY+n,compareY);
    double d = closest_pair(P,sortedX,sortedY,n);
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
    
    n = closest_pairr(P,n);

    printf("%d %d\n", P1.x,P1.y);
    printf("%d %d\n", P2.x,P2.y);

    free(P);
}