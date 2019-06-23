# Notatki do egzaminu

### Kod trójkowy
Kod trójkowy (ang. three-address code) to postać pośrednia stosowana przez
kompilatory przy translacji z języka wysokiego poziomu do asemblera. W większości
przypadków można ją bezpośrednio przetłumaczyć na kod maszynowy procesora.

**Instrukcje:**
    
    x := y binop z – gdzie binop jest operatorem binarnym
    x := unop z – gdzie unop jest operatorem unarnym
    x := y – kopiowanie danej
    goto L – skok bezwarunkowy do etykiety L
    if b goto L – skok do etykiety L, jeśli b jest prawdą
    if x relop y goto L – skok do L, jeśli x jest w relacji relop do y
    x := &y – wyznaczenie wkaźnika do zmiennej (referencja)
    x := *y, *x := y – dereferencja wskaźnika
    param x – użyj x jako parametru procedury
    call p, n – wołanie procedury p z n argumentami
    return n – zwróć n z procedury


    binop ∈ { +, -, *, /, ..., &&, ||, ..., &, |, ˆ, ... }
    unop ∈ { -, !, ~ ...}
    relop ∈ { ==, !=, <=, <, ...}

**Przykłady:**

    uint32_t *a;                i := 0
    ...                      L: t1 := i * 4
    int i = 0;                  t2 := a[t1]
    while (a[i] < v) {          if t2 >= v goto E
    i++;                        i := i + 1
    }                           goto L
                             E:

    x := a[i] jest tym samym co t := a + i; x := *t
    a[i] := x jest tym samym co t := a + i; *t := x

### Big Endian, Little Endian

X = 0x01234567

Big Endian:
: 01 23 45 67

Little Endian:
: 67 45 23 01

### Assembly

***Adresowanie pamięci:***
- (R) Mem[Reg[R]]
- D(R) Mem[Reg[R]+D]
- D(Rb,Ri,S) Mem[Reg[Rb]+S*Reg[Ri]+ D]
- (Rb,Ri) Mem[Reg[Rb]+Reg[Ri]]
- D(Rb,Ri) Mem[Reg[Rb]+Reg[Ri]+D]
- (Rb,Ri,S) Mem[Reg[Rb]+S*Reg[Ri]]

***mov src, dst:***
- Nie można zrobić transferu z pamięci do pamięci w jednej instrukcji
- mov var, %eax == lea (var), %eax ([mov vs lea: stackoverflow.com](https://stackoverflow.com/questions/1699748/what-is-the-difference-between-mov-and-lea))

***Arithmetic operations:***
- addq Src,Dest Dest = Dest + Src
- subq Src,Dest Dest = Dest − Src
- imulq Src,Dest Dest = Dest * Src
- salq Src,Dest Dest = Dest << Src Also called shlq
- sarq Src,Dest Dest = Dest >> Src Arithmetic
- shrq Src,Dest Dest = Dest >> Src Logical
- xorq Src,Dest Dest = Dest ^ Src
- andq Src,Dest Dest = Dest & Src
- orq Src,Dest Dest = Dest | Src
- incq Dest Dest = Dest + 1
- decq Dest Dest = Dest − 1
- negq Dest Dest = − Dest
- notq Dest Dest = ~Dest

### Flagi

- CF Carry Flag (for unsigned) 
- SF Sign Flag (for signed)
- ZF Zero Flag
- OF Overflow Flag (for signed)

        Example: addq Src,Dest ↔ t = a+b
        CF set if carry/borrow out from most significant bit (unsigned overflow)
        ZF set if t == 0
        SF set if t < 0 (as signed)
        OF set if two’s-complement (signed) overflow
        (a>0 && b>0 && t<0) || (a<0 && b<0 && t>=0)

- **cmpq b,a** like computing a-b without setting destination
- **testq b,a** like computing a&b without setting destination 

Jumps:
- jg(greater), jl(less) (signed)
- ja(above), jb(below) (unsigned)
### DRAM

- #### Odczyt
Żeby przeczytać dowolny bajt pamięci DRAM należy przejść przez nastepujące etapy:

    • precharge: przygotowanie układów wzmacniających sygnał odczytywany z kondensatorów,

    • row-select: wybór wiersza, próbkowanie ładunku i wpisanie wyników to bufora (szybka pamięć SRAM),

    • column-select: wybór kolumny i wybór operacji (odczyt lub zapis)
    • data-transfer: wymiana danych między procesorem, a pamięcią.
Najszybszy dostęp jest gdy wiersz jest otwarty (załadowany do bufora) i czytamy skwencyjnie (tryb burst).
Najwolniejszy, gdy co dostęp do pamięci musimy zamykać i otwierać wiersz.

### Pamięć wirtualna
- #### TLB

> Jakie zadanie pełni TLB w procesie translacji adresów?

TLB jest pamięcią podręczną dla tablicy stron. Przechowuje niedużą (z reguły 64 dla TLB L1) liczbę wpisów
tablicy stron. Tak długo jak dostępy do pamięci są w zasięgu zasięgu TLB to procesor nie musi czytać tablicy
stron z DRAM’u. Translacja adresów musi być szybka, bo procesor wykonuje ją przy każdym dostępie do pamięci.

>Kiedy procesor modyfikuje zawartość wpisów w TLB?

Procesor modyfikuje zawartość wpisów stron w TLB, jeśli program robił dostępy do strony – ustawia bit «referenced», gdy strona została odczytana, a «modified» gdy zapisana. System operacyjny używa tych bitów by analizować zbiór rezydentny programu.

> W jakich przypadkach system operacyjny zmienia zawartość TLB?

Jądro systemu operacyjnego usuwa wpisy z TLB, gdy przełącza przestrzenie adresowe, jeśli procesor nie dys-
ponuje identyfikatorami przestrzeni adresowych ASID. Dodatkowo w momencie zmiany uprawnień dostępu do strony, lub usuwania mapowania.