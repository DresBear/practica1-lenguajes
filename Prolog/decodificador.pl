:- initialization(main).

decodificar(Codigo, Resultado) :-
    number_string(Codigo, CodigoTexto),
    string_length(CodigoTexto, Largo),
    Largo =:= 8,                                   % debe tener exactamente 8 digitos

    sub_string(CodigoTexto, 0, 3, _, TextoPeriodo), % digitos 1 a 3
    number_string(Prefijo, TextoPeriodo),
    obtener_periodo(Prefijo, Periodo),              % falla si esta fuera de 262-292

    sub_string(CodigoTexto, 3, 2, _, TextoCategoria),% digitos 4 y 5
    number_string(NumCategoria, TextoCategoria),
    obtener_categoria(NumCategoria, Categoria),

    sub_string(CodigoTexto, 5, 3, _, TextoConsec),  % digitos 6 a 8
    number_string(Consecutivo, TextoConsec),        % number_string ya quita los ceros

    obtener_paridad(Consecutivo, Paridad),

    format(atom(Resultado), "~w ~w num~w ~w", [Periodo, Categoria, Consecutivo, Paridad]).

% obtener_periodo(+Prefijo, -Periodo)

obtener_periodo(Prefijo, Periodo) :-
    Prefijo >= 262,
    Prefijo =< 292,
    Anio is 2000 + (Prefijo // 10),
    Semestre is Prefijo mod 10,
    format(atom(Periodo), "~w-~w", [Anio, Semestre]).


% divisores_propios(+Numero, -Divisores)

divisores_propios(Numero, Divisores) :-
    findall(D,
            ( between(1, Numero, D),
              D < Numero,
              0 is Numero mod D
            ),
            Divisores).

suma_divisores(Numero, Suma) :-
    divisores_propios(Numero, Divisores),
    sum_list(Divisores, Suma).

% obtener_categoria(+Numero, -Categoria)

obtener_categoria(Numero, "Administrativa") :-
    suma_divisores(Numero, Suma),
    Suma > Numero,
    !.
obtener_categoria(Numero, "Ingeniería") :-
    suma_divisores(Numero, Suma),
    Suma =:= Numero,
    !.
obtener_categoria(_Numero, "Humanidades").

% obtener_paridad(+Numero, -Paridad)

obtener_paridad(Numero, "even") :-
    0 is Numero mod 2,
    !.
obtener_paridad(_Numero, "odd").

% generar_codigos(+Periodo, +Categoria, -Codigos)
% Consulta en modo "generar"

generar_codigos(Periodo, Categoria, Codigos) :-
    Desde is Periodo * 100000,
    Hasta is Periodo * 100000 + 99999,
    findall(Codigo,
            ( between(Desde, Hasta, Codigo),
              decodificar(Codigo, Resultado),
              sub_string(Resultado, _, _, _, Categoria)
            ),
            Codigos).

% main/0: Pruebas del programa

main :-
    probar(26276002),   % ejemplo del enunciado
    probar(27110123),   % otro ejemplo
    probar(26228002),   % numero perfecto (28)
    probar(26212003),   % numero abundante (12)
    ( decodificar(1234567, _)   % 7 digitos: debe fallar
    -> writeln('ERROR: no debia funcionar con 7 digitos')
    ;  writeln('OK: fallo correctamente con codigo de 7 digitos')
    ),
    ( decodificar(30012345, _)  % periodo fuera de rango: debe fallar
    -> writeln('ERROR: no debia funcionar con periodo fuera de rango')
    ;  writeln('OK: fallo correctamente con periodo fuera de rango')
    ),
    generar_codigos(292, "Ingeniería", CodigosIngenieria),
    length(CodigosIngenieria, Cantidad),
    format("Codigos 2029-2 Ingenieria encontrados: ~w~n", [Cantidad]),
    writeln(CodigosIngenieria),
    halt.

probar(Codigo) :-
    ( decodificar(Codigo, Resultado)
    -> writeln(Resultado)
    ;  writeln('El codigo no es valido')
    ).
