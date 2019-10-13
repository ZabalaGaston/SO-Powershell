###############################################
# NOMBRE DEL SCRIPT:Ejercicio3.ps1            #
# Trabajo Practico Nº 2 - Primer Entrega      #
#                                             #
# Integrantes:                                #
# Cabral, David         39757782              #
# Cela, Pablo           36166867              #
# Pessolani, Agustin    39670584              #
# Sullca, Fernando      37841788              #
# Zabala, Gaston        34614948              #
#                                             #
###############################################

<#
  .SYNOPSIS

      El script se encarga de mover archivos indicados en un CSV a otro directorio.

  .DESCRIPTION

      El script toma la ruta de X cantidad de archivos en un CSV, y los mueve hacia un destino indicado.
      El script tambien genera un archivo log donde guarda las transacciones con sus respectivas fechas.

  .EXAMPLE

      ./ejercicio3.ps1 Entrada.csv Salida.csv

#>

########## ----- DECLARACION DE PARAMETROS ----- ##########

Param (
  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string[]]$Entrada,

  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string[]]$Salida
)

########## ----- VALIDACION DE PARAMETROS ----- ##########

if(!(Test-Path $Entrada)){
  Write-Host "El directorio de Entrada no existe"
  exit
}

########## ----- MAIN ----- ##########

$routes = Import-Csv -Path "$Entrada"

$logs = @()

foreach ($route in $routes) {
  if((Test-Path $route.origen) -And (Test-Path $route.destino)){
    Move-Item -Path $route.origen -Destination $route.destino
    $logs += @{archivo=$route.destino;fecha=Get-Date -DisplayHint Date}
  }
}

$logs | Select-Object -Property archivo,fecha | Export-Csv -Path "$Salida" -Append
