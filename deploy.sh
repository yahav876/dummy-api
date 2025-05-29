#!/bin/bash

# --- CONFIGURABLE VARIABLES ---
AWS_REGION="us-east-1"  # 🔁 Your AWS region
CLUSTER_NAME="example-eks"  # 🔁 Your EKS cluster name
ENV_DIR="terraform/env/dev"  # 🔁 Path to your Tofu code
POSTGRES_URI="postgresql://postgres:YourPassword@your-rds-host:5432/your-db-name"  # 🔁 Replace this!

SSH_KEY_NAME="airflow-git-key"
SECRET_NAME="airflow-git-ssh-secret"
NAMESPACE="airflow"

# --- STEP 1: Authenticate to AWS ---
echo "[Step 1] Checking AWS credentials..."
aws sts get-caller-identity > /dev/null || { echo "❌ AWS CLI not authenticated. Run 'aws configure' first."; exit 1; }

# --- STEP 2: Provision Infrastructure with OpenTofu ---
echo "[Step 2] Provisioning infrastructure with OpenTofu..."
cd "$ENV_DIR"
tofu init
tofu plan
tofu apply -auto-approve
cd - > /dev/null

# --- STEP 3: Configure kubeconfig for EKS ---
echo "[Step 3] Updating kubeconfig for cluster: $CLUSTER_NAME..."
aws eks update-kubeconfig --region "$AWS_REGION" --name "$CLUSTER_NAME"

# --- STEP 4: Apply Kubernetes Manifests ---
echo "[Step 4] Applying Kubernetes manifests..."
kubectl apply -f manifests/storage-class.yaml
kubectl apply -f manifests/nodeport-airflow.yaml

# --- STEP 5: Generate SSH key & create Git Secret ---
if [[ -f "$SSH_KEY_NAME" ]]; then
  echo "✅ SSH key '$SSH_KEY_NAME' already exists. Skipping generation."
else
  echo "🔑 Generating SSH key..."
  ssh-keygen -t rsa -b 4096 -C "airflow-git" -f "./$SSH_KEY_NAME" -N ""
fi

echo -e "\n➡️ Copy the following public key to your GitHub repo as a Deploy Key:"
echo "🔗 GitHub → Your Repo → Settings → Deploy keys → Add deploy key"
echo "📋 Public key:"
cat "$SSH_KEY_NAME.pub"
echo
read -p "❗ After adding the SSH key to GitHub, press [Enter] to continue..."

echo "🔐 Encoding and applying Kubernetes Secret..."
BASE64_KEY=$(base64 < "$SSH_KEY_NAME" | tr -d '\n')
cat <<EOF > ssh-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: $SECRET_NAME
  namespace: $NAMESPACE
type: Opaque
data:
  gitSshKey: $BASE64_KEY
EOF
kubectl apply -f ssh-secret.yaml

# --- STEP 6: Deploy Applications using Helm ---
echo "[Step 6] Deploying Airflow..."
helm upgrade --install airflow ./helm/airflow \
  --namespace airflow --create-namespace

echo "[Step 6] Deploying Mockoon..."
helm upgrade --install mockoon ./helm/mockoon \
  --namespace airflow --create-namespace

# --- STEP 7: Output NLB DNS ---
echo "[Step 7] NLB DNS Output:"
tofu -chdir="$ENV_DIR" output -raw nlb_dns_name || echo "⚠️ NLB output not defined."

# --- STEP 8: Wait for Airflow Webserver Pod ---
echo "[Step 8] Waiting for Airflow webserver pod..."
kubectl wait --for=condition=Ready pod -l component=webserver -n airflow --timeout=120s

# --- STEP 9: Add Airflow Connection ---
echo "[Step 9] Adding Airflow connection for 'postgres_default'..."
kubectl exec -it $(kubectl get pod -n airflow -l component=webserver -o jsonpath="{.items[0].metadata.name}") -n airflow -- bash -c \
  "airflow connections add 'postgres_default' --conn-uri='$POSTGRES_URI'"

# --- STEP 10: Port-forward to access UI ---
echo "[Step 10] Access Airflow UI:"
kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow &
sleep 5
echo "👉 http://localhost:8080"
echo "🔐 Username: admin | Password: admin"

# --- STEP 11: Final Resource Check ---
echo "[Step 11] Kubernetes resources:"
kubectl get all -A



# #!/bin/bash

# # --- CONFIGURABLE VARIABLES ---
# AWS_REGION="us-east-1"
# CLUSTER_NAME="example-eks"
# ENV_DIR="terraform/env/dev"
# POSTGRES_URI="postgresql://postgres:6(|EqH<G9B7n(lpMI>pkK)xZkivU@demodb.co5lfeik9e1a.us-east-1.rds.amazonaws.com:5432/demodb"  # Replace this!

# # --- STEP 1: Authenticate to AWS ---
# echo "[Step 1] Make sure you've run 'aws configure' before executing this script."
# aws sts get-caller-identity > /dev/null || { echo "❌ AWS CLI not authenticated."; exit 1; }

# # --- STEP 2: Provision Infrastructure with OpenTofu ---
# echo "[Step 2] Provisioning infrastructure with OpenTofu..."
# cd "$ENV_DIR"
# tofu init
# tofu plan
# tofu apply -auto-approve
# cd - > /dev/null

# # --- STEP 3: Configure kubeconfig for EKS ---
# echo "[Step 3] Updating kubeconfig for cluster: $CLUSTER_NAME..."
# aws eks update-kubeconfig --region "$AWS_REGION" --name "$CLUSTER_NAME"

# # --- STEP 4: Apply Kubernetes Manifests ---
# echo "[Step 4] Applying Kubernetes manifests..."
# kubectl apply -f manifests/storage-class.yaml
# kubectl apply -f manifests/nodeport-airflow.yaml

# # --- STEP 5: Deploy Applications using Helm ---
# echo "[Step 5] Deploying Airflow..."
# helm upgrade --install airflow ./helm/airflow \
#   --namespace airflow --create-namespace

# echo "[Step 5] Deploying Mockoon..."
# helm upgrade --install mockoon ./helm/mockoon \
#   --namespace airflow --create-namespace


# Default Webserver (Airflow UI) Login credentials:
#     username: admin
#     password: admin
#  kubectl port-forward svc/airflow-webserver 8080:8080 --namespace airflow


# # --- STEP 6: Output NLB DNS (if output is defined in Tofu) ---
# echo "[Step 6] NLB DNS Output:"
# tofu -chdir="$ENV_DIR" output -raw nlb_dns_name || echo "⚠️ NLB output not defined."

# # --- STEP 7: Wait for Airflow webserver pod to be ready ---
# echo "[Step 7] Waiting for Airflow webserver pod..."
# kubectl wait --for=condition=Ready pod -l component=webserver -n airflow --timeout=120s



# # --- STEP 8: Add Airflow Connection "postgres_default" ---
# echo "[Step 8] Adding Airflow connection..."
# kubectl exec -it $(kubectl get pod -n airflow -l component=webserver -o jsonpath="{.items[0].metadata.name}") -n airflow -- bash -c \
#   "airflow connections add 'postgres_default' --conn-uri='$POSTGRES_URI'"


# # --- STEP 9: Final Verification ---
# echo "[Step 9] All resources:"
# kubectl get all -A


