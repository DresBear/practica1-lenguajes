module Main where

-- Funcion principal: junta las 4 partes del resultado en un solo texto.
-- Usamos "where" para separar cada paso del calculo.
decodificar :: Int -> String
decodificar codigo =
    periodoTexto ++ " " ++ categoriaTexto ++ " num" ++ show consecutivo ++ " " ++ paridadTexto
  where
    codigoTexto    = show codigo                       -- pasamos el numero a texto para poder cortarlo
    prefijo        = read (take 3 codigoTexto) :: Int          -- digitos 1 a 3
    digitosCat     = read (take 2 (drop 3 codigoTexto)) :: Int -- digitos 4 y 5
    consecutivo    = read (drop 5 codigoTexto) :: Int          -- digitos 6 a 8 (read ya quita los ceros)
    periodoTexto   = obtenerPeriodo prefijo
    categoriaTexto = obtenerCategoria digitosCat
    paridadTexto   = if consecutivo `mod` 2 == 0 then "even" else "odd"

-- Convierte el prefijo (por ejemplo 262 o 271) al formato "Año-Semestre".
-- Usa guardas para validar el rango pedido (262 a 292).
obtenerPeriodo :: Int -> String
obtenerPeriodo prefijo
    | prefijo < 262 || prefijo > 292 = error "El periodo esta fuera del rango 262-292"
    | otherwise                      = show anio ++ "-" ++ show semestre
  where
    anio     = 2000 + (prefijo `div` 10)   -- los dos primeros digitos del prefijo
    semestre = prefijo `mod` 10            -- el ultimo digito del prefijo

-- Calcula la suma de los divisores propios de n (todos menos el mismo n).
-- Es una comprension de listas sencilla: recorremos del 1 a n-1 y nos
-- quedamos con los que dividen a n exactamente (resto 0).
sumaDivisores :: Int -> Int
sumaDivisores n = sum [d | d <- [1 .. n - 1], n `mod` d == 0]

-- Clasifica el numero de dos digitos segun la suma de sus divisores
-- (numero de Nicomaco: abundante, perfecto o deficiente).
obtenerCategoria :: Int -> String
obtenerCategoria n
    | suma > n  = "Administrativa"   -- abundante
    | suma == n = "Ingeniería"       -- perfecto
    | otherwise = "Humanidades"      -- deficiente
  where
    suma = sumaDivisores n

-- main solo se usa para probar el programa con algunos ejemplos.
main :: IO ()
main = do
    putStrLn (decodificar 26276002)  -- ejemplo del enunciado
    putStrLn (decodificar 27110123)  -- otro ejemplo de prueba
    putStrLn (decodificar 26228002)  -- ejemplo con numero perfecto (28)
    putStrLn (decodificar 26212003)  -- ejemplo con numero abundante (12)
