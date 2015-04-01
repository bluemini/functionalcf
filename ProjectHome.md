An attempt to try and emulate a funcional language syntax, like Lisp or Clojure, in CFML. As much a bit of fun as anything else.

Since the simple bracket notation of Lisp is not possible inside CF, I've made the call as short as possible by adopting the much used $() approach. I started with the idea that you could pass CF functions directly into $, however, this proves complex since CF will evaluate functions immediately it sees them, meaning that they're not easy to pass in the body for recursion etc. As such, I have changed syntax to a quoted string that is parsed by the framework, rather than relying on default CF behaviour. This also means we can get more lisp-y with the removal of commas.

To define a new function, use the defn function:

```
$('defn name comment [variables] (function-body)')
```

So, for example, to create a function that tells you if a number is positive or negative, you could write:

```
$('defn isNegative? [num] (lt num 0)')
```

This would return a function called **isNegative?** and could then be called

```
$('isNegative? 2')
```

and the response from this would be

```
> false
```