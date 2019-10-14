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
       -PathZip  -Descomprimir -Directorio
       -PathZip  -Imformar

    .EXAMPLE 
        .\Ejercicio4.ps1 -PathZip C:\Users\Fernando\Desktop\archivo.zip -Informar
        .\Ejercicio4.ps1 -PathZip in.zip (informar)
        .\ejercicio4.ps1 -PathZip in.zip -Descomprimir 'Carpeta Destino' 
        .\ejercicio4.ps1 -PathZip in.zip -Comprimir 'Carpeta Origen'                                     
#>

#--------------------------Declaracion de parametros-------------------------

 [CmdletBinding(DefaultParameterSetName='Informar')]
 Param( 
     [Parameter(Position = 1, Mandatory = $true)]
     [String] $PathZip,
     [Parameter(Position = 3)]
     [String] $Directorio,

     [Parameter(ParameterSetName='Descomprimir', Mandatory=$True)]
     [switch]$Descomprimir,
   #  [Parameter(ParameterSetName='Directorio',Position = 2, Mandatory=$True)]
     [Parameter(ParameterSetName='Comprimir' , Mandatory=$True)]
     [switch]$Comprimir,

     [Parameter(ParameterSetName='Informar')]
     [switch]$Informar

     )

#--------------------------Declaracion Funciones-----------------------------

#--------------------------Funciones Informar--------
function informar {
 
    param([string]$PathZip) 
    if (-Not (Test-Path $PathZip)){
        Write-Warning "El archivo  [$PathZip] no existe."
        Write-Host ""
        return
    }
    
    function ArmandoEscritura { 
   param([string]$name,[string]$tam_Orig,[string]$relacion)   
      $obj = New-Object PSObject 
      $obj | Add-Member NoteProperty Nombre($name) 
      $obj | Add-Member NoteProperty Peso_original_MB($tam_Orig) 
      $obj | Add-Member NoteProperty 'Relacion_Comp(P. Comp /P. Orig)'($relacion)  
      Write-Output $obj 
    };
    
    Add-Type -AssemblyName “system.io.compression.filesystem”;
    
    [io.compression.zipfile]::OpenRead( "$PathZip" ).entries |% {
    
  $Nombre="$($_.Name)";
    $Tam_Orig="$($($_.Length)/1000000)";

    if($_.Length.Equals(0)) {
    $Relacion="$([math]::Round(($_.CompressedLength/$_.Length),3))";
    }
    else 
    {$Relacion="$([math]::Round(($_.CompressedLength/1),3))";
    }
    
   ArmandoEscritura  $Nombre $Tam_Orig $Relacion
    };

}#Fin informar

#--------------------------Funciones comprimir---------
function complimir {
    param ( [String] $PathZip, [String] $Directorio )
    $existe = Test-Path $Directorio

    if ($existe -eq $false) {
    Write-Host "El PathZip no existe"
    Write-Host ""
    return
    }
    
    $existe = Test-Path $Directorio
    if ($existe -eq $false) {
    Write-Host "El Directorio no existe"
    Write-Host ""
    return
    }

        $compress = @{
            LiteralPath= $Directorio
            CompressionLevel = "Optimal"
            #DestinationPath = $Directorio+"\"+$PathZip
            DestinationPath = $PathZip
            }
            Compress-Archive @compress

}#Fin comprimir

#--------------------------Funciones expandir------------
function expandir {
    param (
    [String] $PathZip, [String] $Directorio
    )
    $existe = Test-Path $PathZip

    if ($existe -eq $false) {
    Write-Host "El PathZIP no existe"
    exit    
    }

    $existe = Test-Path $Directorio
    if ($existe -eq $false) {
    Write-Host "El Directorio no existe"
    exit
    }

    [string]$nombre=Get-ChildItem $PathZip | Select-Object -Property Name

    Expand-Archive -LiteralPath $PathZip -DestinationPath $Directorio"\"$($($nombre.TrimStart("@{Name=")).TrimEnd('}'))

}#Fin expandir

#--------------------------Validación de parametros-------------------------

#Write-Host ("Parameter set in action: " + $PSCmdlet.ParameterSetName)
#Write-Host ("informar: " + $Informar)
#Write-Host ("Descomprimir: " + $Descomprimir)
#Write-Host ("Comprimir: " + $complimir) 

#if ( $PSCmdlet.ParameterSetName.CompareTo("-Informar"))
if ( $Informar.IsPresent)
{
    Write-Host ("Realizando informe Sobre [$PathZip]") 
    informar $PathZip
}

if ( $Comprimir.IsPresent)
{
    Write-Host ("Realizando compresion Sobre [$Directorio] ") 
    complimir $PathZip $Directorio
    #Write-Host ("Nombre asignado Sobre [$Directorio] es $PathZip ") 
    Write-Host ("Compresion finalizada") 
}

if ( $Descomprimir.IsPresent)
{
    Write-Host ("Realizando descompresion Sobre [$PathZip]") 
    expandir $PathZip $Directorio
    Write-Host ("Descompresion Realizada") 
    exit 1
}

exit 1

