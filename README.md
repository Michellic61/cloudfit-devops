# CloudFit – Projeto DevOps com GitHub Copilot

Infra mínima com Terraform (AWS), API Flask com rota `/status` e pipeline CI/CD no GitHub Actions.

## 🎯 Objetivos
- Provisionar infra simples: 1 EC2 + Security Group porta 80 (e opcional S3).
- API REST com `/status` retornando `{"status":"ok"}`.
- CI/CD: instalar deps, rodar testes e *deploy simulado*.
- Usar GitHub Copilot para acelerar cada etapa (exemplos de prompts no final).

> **Aviso de custos**: ao aplicar o Terraform, você pode gerar custos na AWS. Use `terraform destroy` quando terminar.

---

## 🧰 Requisitos
- **VS Code** com extensões:
  - GitHub Copilot (+ Chat) – opcional, mas recomendado
  - Python
- **Ferramentas locais**: Git, Python 3.11+, Terraform 1.6+, (opcional) AWS CLI configurado
- **Conta GitHub** (para Actions) e **conta AWS** (se for aplicar).

---

## 🚀 Como rodar localmente (sem AWS)
1. Crie um ambiente virtual e instale dependências:
   ```bash
   python -m venv .venv
   # Windows PowerShell
   .venv\Scripts\Activate.ps1
   # Linux/Mac/WSL
   # source .venv/bin/activate

   pip install -r requirements.txt
   ```

2. Rode os testes:
   ```bash
   pytest -q
   ```

3. Suba a API:
   ```bash
   python -m app.main
   # Abra http://127.0.0.1:5000/status
   ```

---

## ☁️ Terraform (AWS)
> Você pode apenas validar (sem criar nada) executando `terraform init` e `terraform validate`.
> Para **aplicar** de fato, configure suas credenciais AWS via `aws configure` ou variáveis de ambiente.

1. Crie um arquivo `terraform/terraform.tfvars` (exemplo):
   ```hcl
   region        = "us-east-1"
   instance_type = "t2.micro"
   create_bucket = true
   ```

2. Inicialize e valide:
   ```bash
   terraform -chdir=terraform init
   terraform -chdir=terraform validate
   terraform -chdir=terraform plan
   ```

3. **(Opcional / gera custos)** Aplique:
   ```bash
   terraform -chdir=terraform apply
   # Saída mostrará "public_ip" e "public_dns"
   # Acesse: http://<public_ip>/status
   ```

4. **Limpeza**:
   ```bash
   terraform -chdir=terraform destroy
   ```

---

## 🤖 CI/CD no GitHub Actions
- Pipeline executa em *push/PR*: instala deps, roda testes e valida Terraform.
- Em *push* no `main`, roda um **deploy simulado** (apenas `echo`).

### Como ativar
1. Crie um repositório no GitHub e faça push deste projeto.
2. Acesse **Actions** para ver a execução.
3. Opcional: adicione segredos se futuramente quiser *deploy real* (AWS creds, etc.).

---

## 🧪 Estrutura
```
cloudfit-devops/
├─ app/
│  ├─ __init__.py
│  ├─ main.py
│  └─ tests/
│     └─ test_status.py
├─ terraform/
│  ├─ main.tf
│  ├─ variables.tf
│  ├─ outputs.tf
│  └─ provider.tf
├─ .github/workflows/ci-cd.yml
├─ scripts/deploy_simulated.sh
├─ requirements.txt
└─ .gitignore
```

---

## 💬 Exemplos de Prompts p/ Copilot
- **Terraform**: “Crie uma instância EC2 com Amazon Linux 2023, abra porta 80/tcp, use o VPC padrão e *user_data* executando um app Flask simples.”
- **API**: “Implemente uma rota Flask `/status` que retorne JSON `{ "status": "ok" }` e escreva um teste pytest.”
- **Actions**: “Crie um workflow com jobs de testes Python, validação do Terraform e um job de deploy simulado que só roda no push para `main`.”
- **README**: “Escreva instruções de execução local, validação do Terraform e steps do pipeline.”

---

## 📄 Licença
MIT
