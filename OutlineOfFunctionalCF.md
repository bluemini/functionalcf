# Introduction #

The functional languages like Lisp and more recently Clojure (a form of Lisp for the JVM) bring enormous power to the table. Functions as first class objects allow for truly expressive code, however, CFML lags a little in its ability to create and return functions on the fly.

# Details #

FunctionalCF is a look at making a CFML based functional language, syntactically similar (as is reasonable) to Lisp/Clojure. A base run function $() replaces the simple bracket syntax (we have to have a function to run) and in the same vein you don't assign values only return functions. The argument to this $() function is a single string value, this is a change from my initial thoughts, as it now requires parsing on within the framework, however, this is the only way I could see to allow the definition of functions without the CFML engine actually executing them. The argument should be wrapped in double quotes, whilst string within the argument should be wrapped in single quotes. Since the argument is a standard CF string, single quotes can be escaped by writing them twice.

Since this is built on CFML, the basic functions in the underlying CFML are (or will be) all alised into the functional pattern. That means, for example, output is given as:

```
$("println 'hello ' 'world'");
```

Defining new functions simply uses the 'defn' function with place holders for values defined using [.md](.md) around names.

To define a new function '**sayHi**' that takes a name parameter:
```
$("defn sayHi [name] (str 'Hi, ' name)");
```
there is no assignment, since like other functional languages all things are immutable.
```
$("sayHi, 'Nick'");
>Hi, Nick
```