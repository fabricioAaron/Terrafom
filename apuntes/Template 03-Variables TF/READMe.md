## 1. Tres tipos de “variables”

<br>

<p>
    Input :
    Son las que defines con variable "nombre" { … }.
    Sirven para parametrizar tu módulo o tu root module (pasar nombres, tamaños, regiones, etc.).
</p>

<br>

<p>
    Output :
    Son las que defines con output "nombre" { … }.
    Sirven para sacar información de tu módulo (por ejemplo, el ID de un resource group) y usarlo fuera o verlo al final del apply.
</p> 

<br>
    Local : 
    Son las locals { … }.
    Sirven para calcular valores intermedios reutilizables dentro del mismo módulo (por ejemplo, concatenar strings, formatear nombres, etc.).
    No se pasan desde fuera ni se devuelven: son “variables internas”.

<br>

## 2. Tipos de datos (type constraints)

La lista amarilla son los tipos que puedes usar para declarar variables:

   <p> string → texto.</p>
   <p> number → números.</p>
   <p> bool → verdadero/falso.</p>
   <p> list(T) → lista ordenada de elementos del mismo tipo.</p>
   <p> set(T) → conjunto sin orden, sin duplicados, mismo tipo.</p>
   <p> map(T) → clave/valor, todas las claves string, todos los valores del mismo tipo.</p>
   <p> object({ ... }) → estructura con campos con nombre y tipos definidos.</p>
   <p> tuple([ ... ]) → lista donde cada posición puede tener tipo distinto.</p>




A la izquierda pone any: si no especificas tipo, la variable acepta cualquier cosa, pero se pierde validación fuerte.

La idea de “type constraints” es que, cuando declaras una variable, puedes decirle qué tipo esperas para que Terraform valide los valores de entrada.

Ejemplo mental:

<p>
    variable "location" { type = string }
</p>
<p>
    variable "tags" { type = map(string) }
</p>
