
function validateForm() {
    var renk = /^[0-9]{26}$/;
    var renp = /^[0-9]{11}$/;
    var em = /^[a-z0-9\._%-]+@[a-z0-9\.-]+\.[a-z]{2,4}$/i;
    var dt = /^\d{2}\/\d{2}\/\d{4}$/;

    if(!renk.test(document.getElementById('nrKonta').value) || !renp.test(document.getElementById('pesel').value) ||
        !em.test(document.getElementById('email').value) || !dt.test(document.getElementById('data').value)){
        alert("Invalid input");
    }
    else alert("Data sent");
    return false;
}

window.onload=function() {
    document.getElementById('myForm').onsubmit = function() { return validateForm(); };
}

