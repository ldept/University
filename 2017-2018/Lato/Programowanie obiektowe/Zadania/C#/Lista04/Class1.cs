using System;
using System.Collections;

public class Prime 
{
    public int prime_num;

    public Prime()
    {
        this.prime_num = 2;
    }
}
public class PrimeCollection : IEnumerable
{
    IEnumerator IEnumerable.GetEnumerator()
    {
        return (IEnumerator)GetEnumerator();
    }
    public PrimeEnum GetEnumerator()
    {
        return new PrimeEnum();
    }

}
public class PrimeEnum : IEnumerator
{
    int first = 2;
    public Prime pc;
    public PrimeEnum(int first)
    {
        pc.prime_num = first;
    }
    public bool isPrime(int p)
    {
        
        for (int i = 2; i * i <= p; i++)
        {
            if (p % i == 0)
                return false;
        }
        return true;
    }

    public bool MoveNext()
    {
        while (!isPrime(pc.prime_num))
        {
            pc.prime_num++;
        }
        return (pc.prime_num < Int32.MaxValue);
    }
    public object Current
    {
        get
        {
            return Current;
        }
        
    }
    public Prime Current
    {
        get
        {
            return pc.prime_num;
        }
    }
    public void Reset()
    {
        first = 2;
    }
}
class App
{
    static void Main()
    {
        PrimeCollection pc = new PrimeCollection();
        foreach(Prime p in pc)
        {
            Console.WriteLine(p.prime_num + " ");
        }
    }
}
