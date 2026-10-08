FROM cypress/included:14.5.4

WORKDIR /e2e

# Copiar primeiro os manifests permite reaproveitar o cache desta camada.
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund

COPY . .

# A imagem cypress/included possui um entrypoint proprio. Ele e removido para
# que o comando do projeto seja o responsavel pela execucao dos testes.
ENTRYPOINT []

CMD ["npm", "test", "--", "--browser", "chrome"]
