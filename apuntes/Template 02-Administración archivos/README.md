# Estados de los archivos de Terraform 

## ¿Qué es el archivo de estado?

<p>
    Es un archivo JSON (normalmente terraform.tfstate) donde Terraform guarda la foto actual de la infraestructura que está gestionando.
    Es la “memoria” de Terraform: mapea lo que hay en tus .tf con los recursos reales en la nube (IDs, atributos, dependencias). </p>


## ¿Para qué sirve?
<P>
    Permite a Terraform saber qué recursos ya existen, cuáles hay que crear, actualizar o destruir.
    Evita que en cada terraform apply se intente recrear todo desde cero.
    Se usa para detectar cambios hechos fuera de Terraform (drift).
</P>

## ¿Cómo lo usa Terraform?

En cada terraform plan/apply:

<P>
    Lee el terraform.tfstate (estado conocido).
    Consulta al proveedor (Azure, etc.) para refrescar la realidad.
    Compara configuración (.tf) ↔ estado ↔ realidad y calcula el plan de cambios.
    Ejecuta los cambios y actualiza el tfstate con el nuevo estado real.
</P>

## ¿Dónde se guarda?

<P>
    Por defecto: local en el directorio del proyecto (terraform.tfstate).
    En equipos y CI/CD se recomienda guardarlo en un backend remoto (por ejemplo, Azure Storage) para compartir estado, bloquear concurrencia y tener copias seguras.
</P>


<img width="1510" height="934" alt="imagen" src="https://github.com/user-attachments/assets/f5f05d6f-3c74-4a4d-a17c-6b7bf2e1795c" />

