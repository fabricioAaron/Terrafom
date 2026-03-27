# Meta- Argumentos

<img width="1582" height="976" alt="imagen" src="https://github.com/user-attachments/assets/691580a7-7560-47aa-8b17-e13b108fafc7" />


En ese esquema están los meta-arguments de Terraform: son parámetros especiales que puedes poner dentro de un resource, module, etc., para controlar cómo se crea, cuántas veces, con qué provider y su ciclo de vida. No definen recursos nuevos, modifican su comportamiento.


1. depends_on – dependencia explícita

Sirve para decirle a Terraform: “este recurso A debe esperar a que B termine”, aunque en el código no haya una referencia directa.

```text
resource "azurerm_resource_group" "rg" {
  name     = "example-rg"
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "example-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [
    azurerm_resource_group.rg
  ]
}
```
<p>

  Normalmente Terraform deduce dependencias cuando usas atributos (rg.name), pero depends_on te permite marcar una dependencia extra y explícita cuando no hay referencia directa.

</p>

2. count – repetir un recurso N veces

Convierte un recurso en un “array” de recursos, repetido count veces.

```text
variable "vm_count" {
  type    = number
  default = 3
}

resource "azurerm_virtual_machine" "vm" {
  count = var.vm_count

  name   = "vm-${count.index}"
  # resto de config...
}
```
<p>
    count recibe un número.
    count.index va de 0 a count-1.
    Útil cuando todas las copias son casi iguales y solo cambian en algo simple (nombre, IP, etc.).
</p>


3. ### for_each – repetir por elementos de un mapa/lista

Más flexible que count. Cada instancia se indexa por clave en vez de por número.


```text
variable "subnets" {
  type = map(string)
  default = {
    web = "10.0.1.0/24"
    db  = "10.0.2.0/24"
  }
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = each.key          # "web", "db"
  address_prefixes     = [each.value]      # el CIDR
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_resource_group.example.name
}
```
<p>
    each.key → clave (web, db).
    each.value → valor (10.0.1.0/24, 10.0.2.0/24).
    Ideal cuando quieres una instancia por cada entrada de un mapa (subnets, tags, reglas, etc.).
</p>

4. provider – elegir qué provider (o alias) usar

Permite decir qué instancia del provider debe usar ese recurso (por ejemplo, varias suscripciones / regiones).

```text
provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "otra_sub"
  features        = {}
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

resource "azurerm_resource_group" "rg_1" {
  name     = "rg-principal"
  location = "westeurope"
}

resource "azurerm_resource_group" "rg_2" {
  provider = azurerm.otra_sub
  name     = "rg-secundario"
  location = "northeurope"
}
```
 <p>  
    Sin provider, usa el provider por defecto.
    Con provider = azurerm.otra_sub le dices que use el provider con alias (otra suscripción, otro tenant, etc.).
</p>

5. lifecycle – controlar cómo se crea/actualiza/borra

Permite cambiar el comportamiento por defecto del recurso.

Ejemplos típicos:

```text
resource "azurerm_virtual_machine" "main" {
  # ...

  lifecycle {
    create_before_destroy = true   # crear la nueva VM antes de borrar la vieja
    prevent_destroy       = true   # impedir destruir este recurso con apply
    ignore_changes        = [tags] # no aplicar cambios si solo cambian las tags
  }
}
```

  <p>  create_before_destroy </p>
  <p> Evita downtime: primero crea el nuevo recurso y luego borra el antiguo. </p>
  <p> prevent_destroy: Protege recursos críticos (prod DB, VNet principal, etc.). </p>
  <p>ignore_changes = [campo]
    Ignora cambios en ciertos atributos (por ejemplo, si alguien cambia una tag a mano y no quieres que Terraform la “corrija”).</p>

También existe replace_triggered_by para forzar recreación cuando cambia otra cosa, pero eso ya es más avanzado.
