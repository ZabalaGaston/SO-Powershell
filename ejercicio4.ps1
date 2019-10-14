# Trabajo práctico N2 Ejercicio 4
# Script: ejercicio1.ps1
# Integrantes:
# Cabral, David         39757782
# Cela, Pablo           36166867
# Pessolani, Agustin    39670584
# Sullca, Fernando      37841788
# Zabala, Gaston        34614948


<#  

    .SYNOPSIS
    
        Este script realiza las operaciones basicas sobre archivos ZIP 
    
    .DESCRIPTION
    
    Este script se encarga :
      Descompresion,de un archivo ZIP pasado por parametro
      Compresion, de el directorio pasado a ZIP
      Informacion, de los arvhivo dentro del ZIP. Por patalla
       
    .EXAMPLE
    
       -PathZip
       -Directorio
       -Descompresion
       -Comprimir
       -Imformar

    .EXAMPLE
        .\Ejercicio4.ps1 -PathZip C:\Users\Rodrigo\Desktop\archivo.zip

    .EXAMPLE
        .\Ejercicio4.ps1 -PathZip in.zip
        .\ejercicio4.ps1 'Carpeta Origen' -Complimir 'Carpeta Destino'                                     
#>



#--------------------------Declaracion de parametros-------------------------
<#
[CmdletBinding()]
Param(
    [Parameter(Position = 1, Mandatory = $true)]
    [String] $pathZIP,
    [Parameter(Position = 2, Mandatory = $true)]
    [String] $opciones,
    [Parameter(Position = 3, Mandatory = $false)]
    [String] $pathDirectorio
    )
#>
       [CmdletBinding()]
 Param( 
     [Parameter(Position = 1, Mandatory = $true)]
     [String] $pathZIP,

     [Parameter(ParameterSetName='pathDirectorio',Position = 2, Mandatory=$true)]
     [String] $pathDirectorio,
     [Parameter(ParameterSetName='Descomplimir', Mandatory=$True)]
     [switch]$Descomplimir,

     [Parameter(ParameterSetName='pathDirectorio',Position = 2, Mandatory=$True)]
     [Parameter(ParameterSetName='Complimir' ,Mandatory=$True)]
     [string]$Complimir,

     [Parameter(ParameterSetName='Informar')]
     [switch]$Informar
        )
function informar {
 
    [CmdletBinding()]
    Param(
      [Parameter(Mandatory=$True,Position=1)]
       [string]$PathZip
    )
    
    if (-Not (Test-Path $PathZip)){
        Write-Host ""
        Write-Warning "El archivo especificado [$PathZip] no existe."
        Write-Host ""
        return
    }
    
    function ArmandoEscritura { 
    param([string]$inputString1,[string]$inputString2,[string]$i0nputString3,[string]$inputString4) 
      $obj = New-Object PSObject 
      $obj | Add-Member NoteProperty Nombre($inputString1) 
      $obj | Add-Member NoteProperty Tamanio_original($inputString2) 
      $obj | Add-Member NoteProperty Tamanio_comprimido($inputString3)
      $obj | Add-Member NoteProperty Relacion($inputString4)  
      Write-Output $obj 
    };
    
    Add-Type -AssemblyName “system.io.compression.filesystem”;
    
    [io.compression.zipfile]::OpenRead("$PathZip").entries |% {
    
    $cadena1="$($_.Name)";
    $cadena2="$($($_.Length)/1000000)";
    $cadena3="$($($_.CompressedLength)/1000000)";
    $cadena4="$([math]::Round(($_.CompressedLength/$_.Length),2))";
    
    ArmandoEscritura $cadena1 $cadena2 $cadena3 $cadena4
    };
}#Fin informar

function complimir {
    param (
        [Parameter(Position = 1, Mandatory = $true)]
    [String] $pathZIP,
    [Parameter(Position = 2, Mandatory = $false)]
    [String] $pathDirectorio
    )
    $existe = Test-Path $pathZIP

    if ($existe -eq $true) {
        Write-Host "El pathZIP Es correcto"
    } else {
    Write-Host "El pathZIP no existe"
    }
    
        $compress = @{
            LiteralPath= $pathZIP
            CompressionLevel = "Optimal"
            DestinationPath = $pathDirectorio+"\archivoZIP.zip"
            }
            Compress-Archive @compress
    exit 1

}#Fin complimir

function Expandir {
    param (
        [Parameter(Position = 1, Mandatory = $true)]
    [String] $pathZIP,
    [Parameter(Position = 2, Mandatory = $false)]
    [String] $pathDirectorio
    )
    existe = Test-Path $pathZIP

    if ($existe -eq $true) {
        Write-Host "El pathZIP Es correcto"
    } else {
    Write-Host "El pathZIP no existe"
    }
    
    Expand-Archive -LiteralPath $pathZIP -DestinationPath $pathDirectorio
exit 1
}#Fin expandir

#--------------------------Validación de parametros-------------------------

$existe = Test-Path $pathZIP
if ($existe -eq $true) {
    Write-Host "El pathZIP Es correcto"
} else {
Write-Host "El pathZIP no existe"
}

$existe = Test-Path $pathDirectorio
if ($existe -eq $true) {
    Write-Host "El pathDirectorio Es correcto"
} else {
Write-Host "El pathDirectorio no existe"
}

Write-Host "[String] pathZIP $pathZIP,
[String] pathDirectorio $pathDirectorio"


Write-Host ("Parameter set in action: " + $PSCmdlet.ParameterSetName)
Write-Host ("informar: " + $Informar)
Write-Host ("Descomplimir: " + $Descomplimir)
Write-Host ("Complimir: " + $complimir) 

exit 1


