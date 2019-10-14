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
    
       -PathZip -Comprimir -Directorio
       -PathZip  -Descompresion -Directorio
       -PathZip  -Imformar

   .EXAMPLE 
        .\Ejercicio4.ps1 -PathZip C:\Users\Fernando\Desktop\archivo.zip -Informar
        .\Ejercicio4.ps1 -PathZip in.zip (informar)
        .\ejercicio4.ps1 -PathZip in.zip -Descomplimir 'Carpeta Destino' 
        .\ejercicio4.ps1 -PathZip in.zip -Complimir 'Carpeta Origen'#>

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
#> [CmdletBinding(DefaultParameterSetName='Informar')]
 Param( 
     [Parameter(Position = 1, Mandatory = $true)]
     [String] $pathZIP,
     [Parameter(Position = 3)]
     [String] $pathDirectorio,

     [Parameter(ParameterSetName='Descomplimir', Mandatory=$True)]
     [switch]$Descomplimir,
   #  [Parameter(ParameterSetName='pathDirectorio',Position = 2, Mandatory=$True)]
     [Parameter(ParameterSetName='Complimir' )]
     [switch]$Complimir,

     [Parameter(ParameterSetName='Informar')]
     [switch]$Informar
     )
     
#--------------------------Declaracion Funciones-----------------------------


#--------------------------Funciones Informar-----------------------------

function informar {
 
    param([string]$PathZip) 
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
    
  $Nombre="$($_.Name)";
    $Tam_Orig="$($($_.Length)/10000)";
    $tam_compr="$($($_.CompressedLength)/10000)";
    if($_.Length.Equals(0)) {
    $Relacion="$([math]::Round(($_.CompressedLength/$_.Length),2))";
    }
    else 
    {$Relacion="$([math]::Round(($_.CompressedLength/1),2))";
    }
    ArmandoEscritura  $Nombre $Tam_Orig $tam_compr $Relacion
    };

}#Fin informar
#--------------------------Funciones complimir-----------------------------
function complimir {
     param ( [String] $pathZIP, [String] $pathDirectorio )
    $existe = Test-Path $pathDirectorio

    if ($existe -eq $true) {
       Write-Host "El Directorio a Complimir  Es correcto"
    } else {
    Write-Host "El Directorio no existe"
    }
    
        $compress = @{
             LiteralPath= $pathDirectorio
            CompressionLevel = "Optimal"
            DestinationPath = $pathDirectorio+"\"+$pathZIP
            }
            Compress-Archive @compress
    #exit 1

}#Fin complimir
#--------------------------Funciones expandir-----------------------------
function expandir {
   param (
    [String] $pathZIP, [String] $pathDirectorio
    )
    existe = Test-Path $pathZIP

   if ($existe -eq $true) {
        Write-Host "El PathZIP Es correcto"
    } else {
    Write-Host "El PathZIP no existe"
    }
    $existe = Test-Path $pathDirectorio

    if ($existe -eq $true) {
        Write-Host "El Directorio Es correcto"
    } else {
    Write-Host "El Directorio no existe"
    }
    
    Expand-Archive -LiteralPath $pathZIP -DestinationPath $pathDirectorio
exit 1
}#Fin expandir

#--------------------------Validación de parametros-------------------------

Write-Host ("Parameter set in action: " + $PSCmdlet.ParameterSetName)
Write-Host ("informar: " + $Informar)
Write-Host ("Descomplimir: " + $Descomplimir)
Write-Host ("Complimir: " + $complimir) 

#if ( $PSCmdlet.ParameterSetName.CompareTo("-Informar"))
if ( $Informar.IsPresent)
{
    Write-Host ("Realizando informe Sobre $pathZIP") 
    informar $pathZIP
}

if ( $Complimir.IsPresent)
{
    Write-Host ("Realizando complesion Sobre $pathDirectorio ") 
    complimir $pathZIP $pathDirectorio
    Write-Host ("Nombre asignado Sobre $pathDirectorio es $pathZIP ") 
}

if ( $Descomplimir.IsPresent)
{
    Write-Host ("Realizando descompresion Sobre $pathZIP") 
    expandir $pathZIP $pathDirectorio
    Write-Host ("Descompresion Realizada") 
    exit 1
}

exit 1



