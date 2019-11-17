function fibRec(num){
    if(num == 0 || num == 1){
        return num;
    }
    else{
        return fibRec(num-1) + fibRec(num-2);
    }
    
}

function fibIter(num){
    var tmp, prev=0, current=1;
    for (var i = 2; i<num;i++){
        tmp = prev;
        prev = current;
        current = prev + tmp;
    }
    return current;
}

function compareFib(){
    for(var i = 10; i <= 42; i++){
        console.time("Rec, i = " + i);
        fibRec(i);
        console.timeEnd("Rec, i = " + i);
        console.time("Iter, i = " + i);
        fibIter(i);
        console.timeEnd("Iter, i = " + i);
    }
}
compareFib();