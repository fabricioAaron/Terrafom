## 1. Tres tipos de “variables”

    Input
    Son las que defines con variable "nombre" { … }.
    Sirven para parametrizar tu módulo o tu root module (pasar nombres, tamaños, regiones, etc.).

    Output
    Son las que defines con output "nombre" { … }.
    Sirven para sacar información de tu módulo (por ejemplo, el ID de un resource group) y usarlo fuera o verlo al final del apply.

    Local
    Son las locals { … }.
    Sirven para calcular valores intermedios reutilizables dentro del mismo módulo (por ejemplo, concatenar strings, formatear nombres, etc.).
    No se pasan desde fuera ni se devuelven: son “variables internas”.
## 2. Tipos de datos (type constraints)

La lista amarilla son los tipos que puedes usar para declarar variables:

    string → texto.

    number → números.

    bool → verdadero/falso.

    list(T) → lista ordenada de elementos del mismo tipo.

    set(T) → conjunto sin orden, sin duplicados, mismo tipo.

    map(T) → clave/valor, todas las claves string, todos los valores del mismo tipo.

    object({ ... }) → estructura con campos con nombre y tipos definidos.

    tuple([ ... ]) → lista donde cada posición puede tener tipo distinto.

A la izquierda pone any: si no especificas tipo, la variable acepta cualquier cosa, pero se pierde validación fuerte.

La idea de “type constraints” es que, cuando declaras una variable, puedes decirle qué tipo esperas para que Terraform valide los valores de entrada.

Ejemplo mental:

    variable "location" { type = string }

    variable "tags" { type = map(string) }
