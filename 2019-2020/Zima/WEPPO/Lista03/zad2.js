function fib(n){
    if(n === 0 || n === 1){
        return n;
    } else{
        return fib(n-2) + fib(n-1);
    }
}

function memoize(fn){
    var cache = {};

    return function(n){
        
        if(n in cache){
            return cache[n];
        } else{
            let result = fn(n);
            cache[n] = result;
            return result;
        }
    }
}

var fib = memoize(fib);


var cache_fib = {};
function fib_cached(n){
    if(n === 0 || n === 1){
        return n;
    } else{
        cache[n] = fib(n-2) + fib(n-1);
        return cache[n];
    }
}

console.log(fib(40));
console.log(fib(38));
//console.log(fib_cached(40));
