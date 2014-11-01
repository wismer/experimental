module Main where
bigNum = 600851475143

isPrime :: (Integral a) => a -> [a] -> Bool
isPrime x xs = (length [n | n <- xs, mod x n == 0]) == 0

-- primeMe :: (Integral a) => a -> [a] -> [a]
primeMe x list
 | x > bigNum = list
 | isPrime x list && mod bigNum x == 0 = primeMe x (x:list)
 | otherwise = primeMe (succ x) list

main = print (primeMe 2 [2])
