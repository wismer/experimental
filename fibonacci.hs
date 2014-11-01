module Main where

fib 0 = 0
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

recurMe x
  | (fib x) < 4000000 = recurMe (succ x)
  | otherwise = sum [fib n | n <- [1..x], even (fib n)]


main = print (recurMe 0)
