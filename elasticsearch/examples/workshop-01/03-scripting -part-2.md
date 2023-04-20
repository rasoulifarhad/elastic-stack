### scripting part 2

From [Ingest Pipelines](https://cdax.ch/2022/01/30/elastic-workshop-2-ingest-pipelines/)

#### Primitive data types and their reference objects

```
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      boolean a ;
      long market_cap = 8000000000L;
      if (market_cap > 1000){
        a = true ;
      } else {
        a = false;
      }
      return a;
    """
  }
}

Result:

{
  "result" : "true"
}
```

```
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      def a ;
      def market_cap = 8000000000L;
      if (market_cap > 1000){
        a = true ;
      } else {
        a = false;
      }
      return a;
    """
  }
}

Result:

{
  "result" : "true"
}
```

#### non-static methods

- int compareTo(Long)
- double doubleValue()
- boolean equals(Object)
- null toString()
- ..

|primitive    | reference object
|-------------|-----------
|int          | Integer
|long         | Long
|char         | Character
|boolean      | Boolean

```
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      boolean i = true ;
      boolean j = false ;
      return i.equals(j);
    """
  }
}

Result:

{
  "result" : "false"
}
```

```
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      long l = 80000000L;
      return l.toString();
    """
  }
}

Result:

{
  "result" : "80000000"
}
```

```
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      long l1 = 80000000L;
      long l2 = 2000L;
      int a = l1.compareTo(l2);
      return a ;
    """
  }
}

Result:

{
  "result" : "1"
}
```

#### static methods

- static long max(long, long)
- static long divideUnsigned(long, long)
- static int compare(long, long)
- static int numberOfTrailingZeros(long)
-  ..

```
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      long l1 = 80000000L;
      long l2 = 2000L;
      long max = Long.max(l1,l2);
      return max ;
    """
  }
}

{
  "result" : "80000000"
}
```

```
{
  "script": {
    "source": """
      long l1 = 80000000L;
      long l2 = 2000L;
      long a = Long.divideUnsigned(l1,l2);
      return a ;
    """
  }
}

{
  "result" : "40000"
}
```

#### Arrays

Reference type objects are objects that are containing multiple fields of data and methods to manipulate them. Examples for reference data are Arrays, ArrayLists, and HashMaps. Unlike with primitive types, we need the “new” operator to define them.

The standard Arrays in painless are pretty old-school. The size of the Array must be defined when it is initialized, and there are no methods to extend it.

```json
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      int[] intArray = new int[] {1, 2, 3};
      //return intArray[1] ;
      int[][] intArray2d = new int[2][5];
      intArray2d[0][0] = 12 ;
      return intArray2d[0][0] ;
    """
  }
}

Result:

{
  "result" : "12"
}
```

#### ArrayLists

```json
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
    List list = new ArrayList() ;
    list.add(10);
    list.add(20);
    return list.get(0) + list.get(1);
    """
  }
}

Result:

{
  "result" : "30"
}
```

#### HashMaps

A HashMap stores key/value pairs like dictionaries in Python or Hashes in Perl. The size will not be defined and like with the other reference type objects, we use the new operator to initialize them.

```json
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
    Map map = new HashMap() ;
    map.put('one', 1);
    map.put('two', 2);
    return map.get('two');
    """
  }
}

Result:

{
  "result" : "2"
}
```
