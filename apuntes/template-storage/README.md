# Apuntes de Terraform

## Version de contenedores 
<img width="997" height="636" alt="imagen" src="https://github.com/user-attachments/assets/e59d1637-64cd-446a-8ffd-1beed96842e9" />

~> : significa que se mantendría la version : 3.0.x 
<p>
 
1. Previamente tenemos que cargar un msi cli de azure, hay diferentes maneras de instalarlo, en mi caso utilicé powershell. 
</p>
 --> https://learn.microsoft.com/es-es/cli/azure/install-azure-cli-windows?view=azure-cli-latest&pivots=msi-powershell

2. Comprobamos que funciona correctamente ejecutando en nuestro terminal. 
   <br>
   ```bash
         az version
    ```     
   <br>
       <img width="342" height="152" alt="imagen" src="https://github.com/user-attachments/assets/d2899cae-f30d-40d1-b06c-83eb924221e2" />

3. Iniciar sesión 

    ```bash
    az login 
    ```
    <br>
    Comprobamos: 
    <br>
    
    <img width="540" height="366" alt="imagen" src="https://github.com/user-attachments/assets/2417949e-e5f9-4a60-a495-32c3c5148bfc" />

     <br>
## 4. Servicio principal 
 <p>Este comando se usa para crear una identidad de aplicación en Azure que permite automatizar accesos (por ejemplo con Terraform).
 ¿Para qué sirve?

Se usa para:

* Automatizar despliegues (Terraform, CI/CD)
* Dar acceso a aplicaciones sin login manual
* Conectar scripts con Azure de forma segura
* Evitar usar tu usuario personal 

 </p>

```bash
az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

<br>

<p>
Esto nos devolverá un json, se tomará las variables para Azure provider Terrafom
</p>

Poweshell

```powershell
$env:ARM_CLIENT_ID="appId"
$env:ARM_CLIENT_SECRET="password"
$env:ARM_SUBSCRIPTION_ID="subscription-id"
$env:ARM_TENANT_ID="tenant-id"
```

Linux

```bash
export ARM_CLIENT_ID="appId"
export ARM_CLIENT_SECRET="password"
export ARM_SUBSCRIPTION_ID="subscription-id"
export ARM_TENANT_ID="tenant-id"
```
<br>
<p> Es opcional pero se puede crear un alias: 
ps: Set-Alias tf terraform
sh: alias tf=terraform

* Ejucaremos `tf init` donde inicializaremos nuestro carpeta de trabajo. 
* Compromabacion: 
    tf validate → comprobar que el código es correcto.
    tf plan → ver qué cambios se harían en Azure.

Manera de ver de manera mas interactiva: 
tf plan | grep "will be created"

Aplicaremos `` tf apply ``
* para ejecutar los cambios sin que nos hagn pregunta de confirmación: 

```tf apply --auto-approve```

* Eliminar el template: 

```bash 
tf destroy --auto-approve
```
</P>
