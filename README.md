# Testes Cypress com Docker e CI/CD

Projeto de testes automatizados com Cypress, execucao padronizada em container
Docker e pipelines de CI/CD no GitHub Actions e no Jenkins.

## Entrega do exercicio Docker

O arquivo `Dockerfile` usa a imagem oficial `cypress/included:14.5.4`, instala
as dependencias com `npm ci` e executa os testes em modo headless no Chrome.

Nao e necessario ter Docker instalado na maquina local para validar esta
entrega. O workflow **Docker - Testes Cypress** faz o build e executa o
container em uma maquina Linux fornecida pelo GitHub Actions.

### Executar pelo GitHub Actions

1. Abra a aba **Actions** deste repositorio no GitHub.
2. Selecione o workflow **Docker - Testes Cypress**.
3. Clique em **Run workflow** e confirme em **Run workflow**.
4. Abra a execucao concluida e consulte o job **Build e testes no Docker**.
5. Na secao **Artifacts**, baixe `evidencias-docker-cypress`.

O workflow tambem e iniciado automaticamente a cada `push` ou pull request na
branch `main`. O artefato fica disponivel por 30 dias e contem:

- `docker-test.log`: log completo da execucao dos testes dentro do container;
- `allure-results/`: resultados brutos do Allure;
- `screenshots/`: capturas criadas pelo Cypress em caso de falha.

O resumo do job informa a imagem construida, o codigo de saida dos testes e o
nome do artefato. A pagina da execucao e o arquivo `docker-test.log` podem ser
usados como evidencia da atividade.

### Executar com Docker localmente (opcional)

```bash
docker build -t ci-cd-cypress .
docker run --rm ci-cd-cypress
```

O segundo comando retorna o mesmo codigo de saida do Cypress: `0` quando todos
os testes passam e um valor diferente de zero quando existe alguma falha.

## Requisitos

- Git
- Docker, somente para execucao local opcional
- Java 17 ou 21 para executar o Jenkins
- Jenkins LTS
- Node.js 18 ou superior no agente Jenkins
- Plugins Jenkins `Git` e `Pipeline`

## Execucao local sem Docker

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
2. Instalacao das dependencias com `npm ci --no-audit`
3. Execucao dos testes automatizados com `npm test`

Os arquivos de resultado do Allure sao arquivados ao final de cada build.

## Repositorio

https://github.com/sabinemetzner/ci-cd-teste-exemplo
