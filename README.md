
### 🔧 Prerequisites

Before you begin, ensure the following tools are installed on your local machine:

| Tool       | Description                                          | Install Link |
|------------|------------------------------------------------------|--------------|
| [Tofu](https://opentofu.org) | Infrastructure as Code engine (Terraform alternative) | https://opentofu.org |
| [Helm](https://helm.sh)      | Kubernetes package manager for deploying charts        | https://helm.sh/docs/intro/install/ |
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | CLI to interact with Kubernetes clusters               | https://kubernetes.io/docs/tasks/tools/ |
| [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) | Interface to AWS services for EKS, IAM, etc.           | https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html |





### -------------------------------------------
### 🚀 Quick Start
### -------------------------------------------
### ⚠️ IMPORTANT: Update the variables and configuration (values.yaml) before running!

Make scripts executable

``
chmod +x *.sh
``


Generate SSH key and create Kubernetes secret

``
./setup-ssh.sh
``

Deploy infrastructure and applications

``
./deploy.sh
``

### -------------------------------------------
### Step 1: Authenticate to AWS
### -------------------------------------------
aws configure


 Enter your:
 - AWS Access Key ID
 - AWS Secret Access Key
 - Region (e.g., us-west-2)
 - Output format (optional: json)

### -------------------------------------------
### Step 2: Provision Infrastructure with OpenTofu
### -------------------------------------------
cd dummy-api/terraform/env/dev  
tofu init
tofu plan
tofu apply -auto-approve

### -------------------------------------------
### Step 3: Configure kubeconfig for EKS
### -------------------------------------------
aws eks update-kubeconfig \
  --region us-west-2 \
  --name {dummy-api-cluster}

### -------------------------------------------
### Step 4: Apply Kubernetes Manifests
### -------------------------------------------
kubectl apply -f manifests/storage-class.yaml
kubectl apply -f manifests/nodeport-airflow.yaml


### -------------------------------------------
### Step 5: Configure Git Access for Airflow DAGs via SSH
### -------------------------------------------

### 1. Generate SSH key pair (no passphrase)
ssh-keygen -t rsa -b 4096 -C "airflow-git" -f ./airflow-git-key -N ""

### 2. Display the public key to add as a Deploy Key in GitHub
echo -e "\n➡️  Copy and add the following public key to your GitHub repo:"
cat airflow-git-key.pub
echo -e "\n🔗 Add it under: GitHub → Your Repo → Settings → Deploy keys"

### 3. Base64-encode the private key (compatible with Linux/macOS)
base64 < airflow-git-key | tr -d '\n' > airflow-git-key.b64

### 4. Create Kubernetes Secret manifest with encoded key

```
cat <<EOF > ssh-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: airflow-git-ssh-secret
  namespace: airflow
type: Opaque
data:
  gitSshKey: $(cat airflow-git-key.b64)
EOF
```

### ✅ 5. Apply the secret to your cluster
kubectl apply -f ssh-secret.yaml





### -------------------------------------------
### Step 6: Deploy Applications using Helm
### -------------------------------------------

### Deploy Airflow
helm upgrade --install airflow ./helm/airflow \
  --namespace airflow --create-namespace

### Deploy Mockoon
helm upgrade --install mockoon ./helm/mockoon \
  --namespace airflow --create-namespace

### -------------------------------------------
### Step 7: Verify Everything
### -------------------------------------------
kubectl get all -A



### -------------------------------------------
### Step 8: Add Airflow Connection "postgres_default"
### -------------------------------------------

kubectl exec -it $(kubectl get pod -n airflow -l component=webserver -o jsonpath="{.items[0].metadata.name}") -n airflow -- bash -c "airflow connections add 'postgres_default' --conn-uri='postgresql://postgres:postgres@<your-host>:5432/<your-db>'"


### -------------------------------------------
### Step 9: Access Airflow UI & Verify DAG
### -------------------------------------------

kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow
Now open your browser to:

👉 http://localhost:8080

Login with default credentials:

Username: admin

Password: admin

Navigate to the DAGs tab and confirm that your DAG (from the Git repo) appears and runs successfully.