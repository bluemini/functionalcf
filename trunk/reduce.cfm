<cfset $("defn red [x y & more]
   (if (< x y)
     (if (next more)
       (recur y (first more) (next more))
       (< y (first more)))
     false)")>

<cfset $("red 2 3")>