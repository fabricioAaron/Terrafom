#terraform {
# backend "azurerm" {
#    access_key           = "tfstate-temp02"        # Can also be set via `ARM_ACCESS_KEY` environment variable.
#    storage_account_name = "temp024"                # Can be passed via `-backend-config=`"storage_account_name=<storage account #name>"` in the `init` command.
#    container_name       = "tfstate"                 # Can be passed via `-backend-config=`"container_name=<container name>"` in #the `init` command.
#    key                  = "dev.terraform.tfstate"  # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` #command.
#}
#}