function naturalNumbers(){
    var naturals = []
    for(var i=1; i <= 100000; i++){
        var number, lastDigit, sumOfDigits, isDivisibleByDigits, isDivisibleBySum;
        number = i; isDivisibleByDigits = true; sumOfDigits = 0;
        while(number > 0){
            lastDigit = number % 10;
            sumOfDigits += lastDigit;

            if(lastDigit == 0 || i % lastDigit != 0){
                isDivisibleByDigits = false;
                break;
            }         

            number = Math.floor(number / 10);
        }
        isDivisibleBySum = i % sumOfDigits == 0;
        if(isDivisibleByDigits && isDivisibleBySum){
            console.log(i);
        }
    }
}

naturalNumbers();