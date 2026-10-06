$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$installDirectory = Join-Path $env:LOCALAPPDATA 'JenkinsPortable'
$javaDirectory = Join-Path $installDirectory 'jdk'
$jenkinsWar = Join-Path $installDirectory 'jenkins.war'
$jenkinsHome = Join-Path $installDirectory 'home'

New-Item -ItemType Directory -Force -Path $installDirectory | Out-Null

if (-not (Test-Path $javaDirectory)) {
  $javaArchive = Join-Path $installDirectory 'temurin21.zip'
  $javaExtractDirectory = Join-Path $installDirectory 'jdk-extract'

  Write-Host 'Baixando o Java 21 portatil...'
  Invoke-WebRequest -UseBasicParsing `
    -Uri 'https://api.adoptium.net/v3/binary/latest/21/ga/windows/x64/jdk/hotspot/normal/eclipse?project=jdk' `
    -OutFile $javaArchive

  Expand-Archive -Path $javaArchive -DestinationPath $javaExtractDirectory -Force
  $extractedJava = Get-ChildItem $javaExtractDirectory -Directory | Select-Object -First 1
  Move-Item $extractedJava.FullName $javaDirectory
  Remove-Item $javaExtractDirectory -Recurse -Force
  Remove-Item $javaArchive -Force
}

if (-not (Test-Path $jenkinsWar)) {
  Write-Host 'Baixando o Jenkins LTS...'
  Invoke-WebRequest -UseBasicParsing `
    -Uri 'https://get.jenkins.io/war-stable/latest/jenkins.war' `
    -OutFile $jenkinsWar
}

$env:JENKINS_HOME = $jenkinsHome
$javaExecutable = Join-Path $javaDirectory 'bin\java.exe'

Write-Host 'Jenkins sera iniciado em http://localhost:8080'
& $javaExecutable -jar $jenkinsWar --httpListenAddress=127.0.0.1 --httpPort=8080