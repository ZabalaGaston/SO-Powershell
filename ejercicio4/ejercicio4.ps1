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
    
        Este script realiza las operaciones basicas sobre archivos ZIP Complimir ,Descomplimir e Informar
    
    .DESCRIPTION
    
    Este script se encarga :
      Descompresion,de un archivo ZIP pasado por parametro con el PathZip y la ruta de destino
      Compresion, de el directorio pasado por parametro con el PathZip y la ruta de destino Zip
      Informacion, de los arvhivo dentro del ZIP. Por patalla
       
    .EXAMPLE
    
    -PathZip -Comprimir -Directorio 
        .\ejercicio4.ps1 'C:\Users\Fernando\Desktop\Carpeta destinos zip' -Comprimir 'Carpeta Origen'
        .\ejercicio4.ps1 '.\Carpeta destinos zip' -Comprimir '.\Carpeta Origen'                      
        .\ejercicio4.ps1 'Carpeta destinos zip' -Comprimir 'C:\Users\Fernando\Desktop\Carpeta Origen'
      

    .EXAMPLE 
    
    -PathZip  -Descomprimir -Directorio
        .\ejercicio4.ps1 Archivo.zip -Descomprimir 'Carpeta Destino' 
    -PathZip  -Imformar
        .\Ejercicio4.ps1 C:\Users\Fernando\Desktop\archivo.zip -Informar        
#>

#--------------------------Declaracion de parametros-------------------------

 [CmdletBinding(DefaultParameterSetName='Informar')]
 Param( 
     [Parameter(Position = 1, Mandatory = $true)]
     [System.IO.DirectoryInfo] $PathZip,
     [Parameter(Position = 3)]
     [System.IO.DirectoryInfo] $Directorio,

     [Parameter(ParameterSetName='Descomprimir', Mandatory=$True)]
     [switch]$Descomprimir,
   #  [Parameter(ParameterSetName='Directorio',Position = 2, Mandatory=$True)]
     [Parameter(ParameterSetName='Comprimir' , Mandatory=$True)]
     [switch]$Comprimir,
   #  [Parameter(ParameterSetName='PathZip', Mandatory=$True)]
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
     # Escritura Final.
      Write-Output $obj 
    };
    
    Add-Type -AssemblyName “system.io.compression.filesystem”;
    
    [io.compression.zipfile]::OpenRead( "$PathZip" ).entries |% {
    
        if( $( -Not $_.Name ) ){
        $Nombre="$($_)";
        }
        else
        {
        $Nombre="$($_.Name)";
        }
        $Tam_Orig="$($($_.Length)/1000000)";
 
        if($($_.Length -eq 0) )
         {
         $Relacion="0";
         }
         else 
        {
        $Relacion="$([math]::Round(($_.CompressedLength/$_.Length),3))";
        }
 
     ArmandoEscritura  $Nombre $Tam_Orig $Relacion
    };
exit 0
}#Fin informar

#--------------------------Funciones comprimir---------
function comprimir {
    param ( [String] $PathZip, [String] $Directorio )
    $existe = Test-Path $PathZip

    if (-Not ($existe)) {
    Write-Host "El PathZip [$PathZip] no existe"
    Write-Host ""
    return
    }
    
    $existe = Test-Path $Directorio
    if ($existe -eq $false) {
    Write-Host "El Directorio [$Directorio] no existe"
    Write-Host ""
    return
    }
#-------------------------------------
    [ System.IO.DirectoryInfo]$_dirOrigen=$Directorio

#--------------------------------------   
        $compress = @{
            LiteralPath= $Directorio
            CompressionLevel = "Optimal"
            DestinationPath = $($PathZip+"\"+$_dirOrigen.BaseName+".zip")
            }
        Compress-Archive @compress

}#Fin comprimir

#--------------------------Funciones descomprimir------------
function descomprimir {
    
    param ([string] $PathZip, [string] $Directorio)

    if (-Not (Test-Path $PathZip)){
        Write-Host "El PathZIP [$PathZip] no existe"
    exit    
    }

    $existe = Test-Path $Directorio
    if ( -Not $existe) {
    Write-Host "El Directorio [$Directorio] no existe "
    exit
    }

    [System.IO.DirectoryInfo]$_dirOrigen=$PathZip
    Expand-Archive -LiteralPath $PathZip -DestinationPath $Directorio"\"$($_dirOrigen.Name)

}#Fin descomprimir

#--------------------------Validación de parametros-------------------------


#if ( $PSCmdlet.ParameterSetName.CompareTo("-Informar"))
if ( $Informar.IsPresent)
{
    Write-Host ("Realizando informe Sobre [$PathZip]") 
    informar $PathZip
}

if ( $Comprimir.IsPresent)
{
    Write-Host ("Realizando compresion Sobre [$Directorio] ") 
    comprimir $PathZip $Directorio
    Write-Host ("Compresion finalizada") 
}

if ( $Descomprimir.IsPresent)
{
    Write-Host ("Realizando descompresion Sobre [$PathZip]") 
    descomprimir $PathZip $Directorio
    Write-Host ("Descompresion Realizada") 
    exit 1
}

exit 1
