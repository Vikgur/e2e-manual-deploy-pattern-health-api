#!/bin/bash

set -e

ENV_DIR=$(basename "$PWD")
if [[ "$ENV_DIR" != "stage" && "$ENV_DIR" != "prod" ]]; then
  echo "Скрипт запускается только из terraform/stage или terraform/prod"
  exit 1
fi

export TF_CLI_CONFIG_FILE="$HOME/.terraformrc"

# Получение параметров из CLI
TOKEN=$(yc iam create-token)
IMAGE_ID=$(yc compute image list --folder-id standard-images --format json | jq -r '.[] | select(
  .name != null and 
  (.name | test("ubuntu-24-04")) and 
  .status == "READY"
) | .id' | head -n1)
CLOUD_ID=$(yc config get cloud-id)
FOLDER_ID=$(yc config get folder-id)
ZONE=$(yc compute zone list --format json | jq -r '.[0].id')

# Функция замены или добавления строки в terraform.tfvars
set_var() {
  local key=$1
  local val=$2
  if grep -q "^${key} *= *" terraform.tfvars; then
    sed -i "s|^${key} *= *\".*\"|${key} = \"${val}\"|" terraform.tfvars
  else
    echo "${key} = \"${val}\"" >> terraform.tfvars
  fi
}

set_var "yc_token" "$TOKEN"
set_var "image_id" "$IMAGE_ID"
set_var "yc_cloud_id" "$CLOUD_ID"
set_var "yc_folder_id" "$FOLDER_ID"
set_var "yc_zone" "$ZONE"

terraform init -upgrade
terraform validate
terraform plan -var-file=terraform.tfvars
