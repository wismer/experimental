module Main where
bigNum = 600851475143

primeFactors x d list
  | mod x d == 0 = primeFactors (div x d) d (d:list)
  | x < 2 = head list
  | otherwise = primeFactors x (succ d) list

main = print (primeFactors bigNum 2 [])
