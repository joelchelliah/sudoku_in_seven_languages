Sudoku in seven languages
=========================

### Sudoku solvers implemented in the following 7 languages:
- Ruby
- Io
- Prolog
- Scala
- Erlang
- Clojure
- Haskell

As an additional exercise to working through the book: "Seven Languages in Seven Weeks" by Bruce A. Tate


Thoughts
--------
There were many similarities, but also many differences between the implementation of each of the solvers. Some were subtle and hardly noticable, while others lead to many hours of scratching my head and starting at the screen until it started making sense. The biggest difference however, seemed to come from the programming paradigms supported by each language. For each language, the algorithm used for the solver had to be altered to match the programming style enforced by its programming paradigm. Here's a very short summary...

### Ruby, Io and Scala
The object oriented programming languages made it very easy to define the algorithm in small sequential steps, and their stateful and imperative programming style made it very easy to traverse and update the sudoku board through simple forms of iteration. Ruby's and Scala's support for using code blocks also made it possible to pack some advanced bits of logic within just a few lines of code, while still seeming pretty straightforward at a short glance.

### Prolog
This constraint logic programming language, easily stood out among the rest of the languages in the book. Here there was no room for algorithms, or states, or method definitions like I was used to from the world of object oriented programming. This style of programming was based around defining a set of facts and rules that needed to be satisfied for there to be a valid solution, and then letting the language deal with the problem of figuring a solution that actually fits within the boundaries of these rules.

### Erlang, Clojure and Haskell
Finally, the funtional programming languages, with their inherent declarative programming style, allowed for compact, powerful blocks of code. With advanced concepts such as, higher-order functions, monads and pattern matching it was possible to pack an insane amount of logic into far fewer lines of code than in any of the previous languages. The fact that these languages are optimizd for tail-recursion also made it possible to rely much more heavily on recursion to solve the problem.
