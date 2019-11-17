var person = {
    name : "Andrew",
    lastName : "Badong",
    get ln() {
        return this.lastName.toUpperCase();
    },
    set ln(ln) {
        this.lastName = ln;
    },
    say : function() {
        console.log("hey");
    }
}

person.age = 20;

person.haha = function() {
    console.log("haha, that's so funny");
}

Object.defineProperty(person, "isAdult", { get : function () { return this.age >= 21; } });
Object.defineProperty(person, "birthday", { get : function() { this.age++; }});
Object.defineProperty(person, "changeName", { set : function(name) {this.name = name;}});

console.log(person.isAdult);
person.birthday;
console.log(person.isAdult);
console.log(person.name);
person.changeName = "Reggie";
console.log(person.name);