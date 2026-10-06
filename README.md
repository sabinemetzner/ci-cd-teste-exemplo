# CI/CD com Cypress e Jenkins

Projeto de testes automatizados com Cypress e pipeline declarativo do Jenkins.

## Requisitos

- Git
- Java 17 ou 21 para executar o Jenkins
- Jenkins LTS
- Node.js 18 ou superior no agente Jenkins
- Plugins Jenkins `Git` e `Pipeline`

## Execucao local

```bash
npm ci
npm test
```

O Cypress executa em modo headless com o Electron incluido na instalacao. Os
resultados do Allure sao gravados em `allure-results`.

## Configuracao do Jenkins

Caso nao consiga instalar o Jenkins no Windows, abra o PowerShell na pasta do
projeto e execute a versao portatil, que nao requer permissao de administrador:

```powershell
powershell -ExecutionPolicy Bypass -File .\start-jenkins.ps1
```

Quando a mensagem `Jenkins is fully up and running` aparecer, acesse
http://localhost:8080. Na primeira inicializacao, a senha temporaria fica em
`%LOCALAPPDATA%\JenkinsPortable\home\secrets\initialAdminPassword`.

1. Inicie o Jenkins LTS instalado ou use o script portatil acima.
2. No Jenkins, acesse **Manage Jenkins > Plugins** e confirme que os plugins
	`Git` e `Pipeline` estao instalados.
3. Crie um item do tipo **Pipeline**.
4. Em **Pipeline**, selecione **Pipeline script from SCM**.
5. Escolha **Git** e informe:
	`https://github.com/sabinemetzner/ci-cd-teste-exemplo.git`.
6. Em **Branch Specifier**, use `*/main` e mantenha `Jenkinsfile` como o caminho
	do script.
7. Salve e clique em **Build Now** para a primeira execucao manual.

O `Jenkinsfile` consulta o GitHub a cada cinco minutos e inicia uma nova
execucao quando encontra alteracoes. Para acionamento imediato, instale o
plugin `GitHub`, marque **GitHub hook trigger for GITScm polling** no job e
adicione no repositorio um webhook apontando para:
`https://SEU-JENKINS/github-webhook/`.

O pipeline possui os estagios:

1. Preparacao do ambiente
2. Instalacao das dependencias com `npm ci`
3. Execucao dos testes automatizados com `npm test`

Os arquivos de resultado do Allure sao arquivados ao final de cada build.

## Repositorio

https://github.com/sabinemetzner/ci-cd-teste-exemplo
