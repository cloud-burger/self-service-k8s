# Self-Service Kubernets

> Essa configuração do Terraform provisiona uma infraestrutura robusta na AWS com integração ao Kubernetes e Helm. Inclui um cluster Amazon Elastic Kubernetes Service (EKS), componentes essenciais de rede e gráficos Helm para implantação do Istio.
---

## Componentes Provisionados

### 1. **Provedores**

- **AWS Provider**: Configura a região AWS com base na variável local `region`.
- **Helm Provider**: Configura o cliente Helm para implantar gráficos no cluster Kubernetes.
- **Kubernetes Provider**: Permite interação com o cluster EKS usando credenciais AWS.

### 2. **Variáveis Locais**

Define variáveis reutilizáveis para:

- Nome da infraestrutura (`name`)
- Região AWS (`region`)
- Versão do cluster Kubernetes
- Bloco CIDR da VPC e sub-redes
- Configuração de addons do EKS
- Releases Helm para implantação do Istio

### 3. **Fontes de Dados**

- Recupera a identidade da conta AWS para validação.
- Obtém zonas de disponibilidade AWS disponíveis, excluindo zonas locais.

### 4. **Rede (VPC)**

Provisionada via o módulo `terraform-aws-modules/vpc/aws`:

- Cria uma VPC com bloco CIDR definido.
- Gera sub-redes públicas e privadas em até três zonas de disponibilidade.
- Configura um NAT Gateway para tráfego de saída na internet a partir de sub-redes privadas.
- Marca sub-redes com funções específicas para Kubernetes.

### 5. **Cluster Amazon EKS**

Implantado usando o módulo `terraform-aws-modules/eks/aws`:

- **Nome do Cluster**: Definido como o valor de `local.name`.
- **Versão do Cluster**: Corresponde à versão do Kubernetes especificada.
- **Rede**: Integra-se às sub-redes privadas do módulo VPC.
- **Grupos de Nós**: Configura um grupo de nós gerenciados com escalabilidade (`m5.large`).
- **Addons do Cluster**: Provisiona addons principais como `coredns`, `kube-proxy` e `vpc-cni`, com configurações personalizadas.

### 6. **Service Mesh Istio (via Helm)**

Implanta o Istio usando gráficos Helm:

- **Componentes**:
  - `istio-base`: Instalação base do Istio.
  - `istiod`: Plano de controle do Istio com logging ativado.
  - `istio-ingress`: Configura um gateway de entrada externo com anotações específicas para balanceadores de carga AWS.
- **Namespaces**: Cria o namespace Kubernetes (`istio-system`) para componentes do Istio.

### 7. **Addons do EKS Blueprints**

Utiliza o módulo `aws-ia/eks-blueprints-addons/aws` para habilitar funcionalidades avançadas do EKS:

- Integrações opcionais como `cert-manager`, `Cluster Autoscaler`, `external-dns`, `AWS Load Balancer Controller`, entre outros.
- Releases Helm personalizados são integrados a este módulo.

### 8. **Grupos de Segurança**

Define regras para:

- Tráfego de entrada nas portas `15017` e `15012` para componentes do Istio.
- Comunicação dentro do cluster.

### 9. **Tagging**

Marca recursos com metadados para rastreabilidade e consistência:

- Inclui tags como `Blueprint` e `GithubRepo`.

---

## Requisitos

- **AWS CLI**: Instalado e configurado para autenticação com serviços AWS.
- **Terraform CLI**: Versão compatível com os módulos utilizados.
- **Helm CLI**: Para gerenciar gráficos Helm no Kubernetes.
- **Kubernetes CLI (kubectl)**: Para interação manual com o cluster Kubernetes, se necessário.

---

## Uso

1. Clone o repositório contendo esta configuração.
2. Inicialize o Terraform:

   ```bash
   terraform init
   ```

3. Revise o plano de execução:

   ```bash
   terraform plan
   ```

4. Aplique a configuração:

   ```bash
   terraform apply
   ```

5. Verifique o cluster EKS e os componentes do Istio:

   ```bash
   kubectl get all -n istio-system
   ```

---

## Notas

- A configuração suporta personalização extensiva por meio de variáveis.
- Certifique-se de que o `awscli` está instalado e configurado corretamente na máquina que executará o Terraform.
- Os gráficos Helm do Istio estão fixados na versão `1.23.2` para estabilidade.
