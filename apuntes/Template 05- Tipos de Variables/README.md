# Creación de variables 

<p> 

En variables.tf, creamos varios tipos, para que solo en main.tf podamos agregarlos. 
</p>

Comprobamos lo que terrafom va a crear con nuetro template. 

```bash

tf plan | grep -i "will be created"

```
Para poder ejecutar sin que nos pida confirmación 

```bash

th apply --auto-approve

```
Las variables que son de tipo lista se contará desde el [0].


# Terraform – Tipos de variables (recordatorio rápido)

Este resumen está pensado para recordar **qué tipo usar, para qué sirve y cómo se usa dentro de los recursos**.

---

## 1. Tipos escalares

### `string`

- Representa texto.
- Ejemplos típicos: entorno (`dev`, `staging`, `prod`), nombres, regiones.

```hcl
variable "environment" {
  type        = string
  description = "Tipo de entorno"
  default     = "staging"
}
```

Uso:

```hcl
name = "${var.environment}-vm"
```

---

### `number`

- Representa números (enteros o decimales).
- Se usa para tamaños, cantidades, puertos, etc.

```hcl
variable "storage_disk" {
  type        = number
  description = "Tamaño del disco del SO en GB"
  default     = 40
}
```

Uso:

```hcl
storage_os_disk {
  disk_size_gb = var.storage_disk
}
```

---

### `bool`

- Representa valores lógicos: `true` o `false`.
- Se usa para activar / desactivar comportamientos.

```hcl
variable "vm_delete" {
  type        = bool
  description = "Eliminar disco del SO al borrar la VM"
  default     = true
}
```

Uso:

```hcl
delete_os_disk_on_termination = var.vm_delete
```

---

## 2. Colecciones simples

### `list(T)`

- Lista **ordenada** de elementos del mismo tipo.
- Permite duplicados.
- Acceso por índice: `lista[0]`, `lista[1]`, etc.

```hcl
variable "ubicacion_permitida" {
  type        = list(string)
  description = "Ubicaciones permitidas para desplegar recursos"
  default     = ["Norway East", "Spain Central", "France Central"]
}
```

Usos:

```hcl
# Primera ubicación de la lista
location = var.ubicacion_permitida

# Segunda ubicación, si existe
# location = var.ubicacion_permitida[1]
```

---

### `map(T)`

- Mapa de **clave → valor**, todas las claves son `string`.
- Todos los valores son del mismo tipo `T`.
- Acceso por clave: `mapa["clave"]`.

```hcl
variable "etiqueta_recursos" {
  type        = map(string)
  description = "Etiquetas comunes para aplicar a los recursos"
  default = {
    environment = "staging"
    managed_by  = "terraform"
    department  = "DevOps"
  }
}
```

Uso típico en `tags`:

```hcl
tags = {
  environment = var.etiqueta_recursos["environment"]
  managed_by  = var.etiqueta_recursos["managed_by"]
  department  = var.etiqueta_recursos["department"]
}
```

---

## 3. Colecciones avanzadas

### `tuple([T1, T2, ...])`

- Secuencia **ordenada y de tamaño fijo**.
- Cada posición puede tener un tipo distinto.
- Acceso por índice: `tupla[0]`, `tupla[1]`, etc.

```hcl
variable "configuración_network" {
  type        = tuple([string, string, number])
  description = "Config de red (VNet CIDR, Subnet CIDR, prefijo)"
  default     = ["10.0.0.0/16", "10.0.2.0/24", 24]
}
```

Usos:

```hcl
# 0 → VNet
address_space = [var.configuración_network]

# 1 → Subnet
address_prefixes = [var.configuración_network][1]

# 2 → número (por ejemplo, 24) disponible si lo necesitas
```

Idea: empaquetas varios valores relacionados en una sola variable, manteniendo el orden.

---

## 4. Objetos

### `object({ ... })`

- Estructura con **campos con nombre** y tipo definido.
- Similar a un “struct” o “record”.

```hcl
variable "vm_config" {
  type = object({
    size      = string
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Configuración completa de la máquina virtual"
  default = {
    size      = "Standard_B2as_v2"
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
```

Uso integrado en el recurso:

```hcl
resource "azurerm_virtual_machine" "main" {
  name                = "${var.environment}-vm"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  vm_size             = var.vm_config.size

  storage_image_reference {
    publisher = var.vm_config.publisher
    offer     = var.vm_config.offer
    sku       = var.vm_config.sku
    version   = var.vm_config.version
  }
}
```

Ventaja: un solo input (`vm_config`) agrupa todos los datos de la imagen y tamaño de la VM.

---

## 5. Listas como catálogo de opciones

Otro ejemplo práctico con `list(string)`:

```hcl
variable "sizes_vm" {
  type        = list(string)
  description = "Tamaños de VM permitidos"
  default     = [
    "Standard_B2as_v2",
    "Standard_B1as_v2",
    "Standard_B1s"
  ]
}
```

Uso:

```hcl
# Primer tamaño de la lista
vm_size = var.sizes_vm

# Podrías elegir otro índice según entorno o lógica
# vm_size = var.sizes_vm[2]
```

---

## 6. Resumen mental rápido

- `string` → texto (`"dev"`, `"Spain Central"`…).  
- `number` → números (`40`, `443`…).  
- `bool` → `true` / `false`.  
- `list(T)` → lista ordenada, acceso por índice (`[0]`).  
- `map(T)` → diccionario clave→valor (`mapa["clave"]`).  
- `tuple([...])` → lista fija donde cada posición puede ser de tipo distinto.  
- `object({ ... })` → estructura con campos con nombre y tipos fijos.

---

¿Quieres que prepare también un bloque de README con **ejemplos completos de recursos** (resource group, VNet, VM) usando todas estas variables juntas, para tenerlo como “plantilla base” en tu repo?
