function forEach(a, f){
    for(let i in a){
        f(i);
    }
}

function map(a,f){
    let new_a = [];
    for(let i in a){
        new_a.push(f(i));
    }
    return new_a;
}

function filter(a,f){
    let new_a = [];
    for(let i in a){
        if(f(a)){
            new_a.push(i);
        }
    }
    return new_a;
}