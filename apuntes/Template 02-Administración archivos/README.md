# Estados de los archivos de Terraform 

## ¿Qué es el archivo de estado?

    Es un archivo JSON (normalmente terraform.tfstate) donde Terraform guarda la foto actual de la infraestructura que está gestionando.

    Es la “memoria” de Terraform: mapea lo que hay en tus .tf con los recursos reales en la nube (IDs, atributos, dependencias).

<br>

## ¿Para qué sirve?

    Permite a Terraform saber qué recursos ya existen, cuáles hay que crear, actualizar o destruir.

    Evita que en cada terraform apply se intente recrear todo desde cero.

    Se usa para detectar cambios hechos fuera de Terraform (drift).

## ¿Cómo lo usa Terraform?

En cada terraform plan/apply:

    Lee el terraform.tfstate (estado conocido).

    Consulta al proveedor (Azure, etc.) para refrescar la realidad.

    Compara configuración (.tf) ↔ estado ↔ realidad y calcula el plan de cambios.

    Ejecuta los cambios y actualiza el tfstate con el nuevo estado real.

## ¿Dónde se guarda?

    Por defecto: local en el directorio del proyecto (terraform.tfstate).

    En equipos y CI/CD se recomienda guardarlo en un backend remoto (por ejemplo, Azure Storage) para compartir estado, bloquear concurrencia y tener copias seguras.

