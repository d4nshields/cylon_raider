# Deployment Guide

## Prerequisites

1. **Oracle Cloud Account** (free tier)
   - Sign up at https://www.oracle.com/cloud/free/
   - Requires credit card for verification (no charges)

2. **Local Tools**
   - Git
   - Terraform (>= 1.0)
   - Python 3 (for OCI CLI)

## Step-by-Step Deployment

### 1. Setup Oracle Cloud Credentials

Run the automated setup script:
```bash
./setup-cylon-credentials.sh
```

This will:
- Install OCI CLI if needed
- Configure Oracle Cloud credentials
- Generate SSH keys
- Create Terraform variables file
- Update .gitignore

### 2. Deploy Infrastructure

```bash
cd infrastructure/terraform
terraform init
terraform plan  # Review what will be created
terraform apply # Deploy (takes 5-10 minutes)
```

### 3. Access Your VM

After deployment, get the IP address:
```bash
terraform output vm_public_ip
```

SSH into your VM:
```bash
ssh ubuntu@<your-vm-ip>
```

### 4. Verify Services

Check that everything is running:
```bash
# On the VM
~/cylon-raider/system-info.sh
```

Test the API endpoints:
```bash
curl http://localhost:8080/health
```

## GitHub Actions Setup (Optional)

For automatic deployment on code changes:

1. **Fork this repository**

2. **Add repository secrets** in GitHub:
   - Go to Settings → Secrets and variables → Actions
   - Add these secrets from your `~/.oci/config`:
     - `OCI_CLI_USER`: Your user OCID
     - `OCI_CLI_TENANCY`: Your tenancy OCID  
     - `OCI_CLI_FINGERPRINT`: Your API key fingerprint
     - `OCI_CLI_REGION`: Your region (e.g., us-ashburn-1)
     - `OCI_CLI_KEY_CONTENT`: Your private API key content

3. **Push changes** or manually trigger the workflow

## Troubleshooting

### Common Issues

**OCI CLI Installation Fails**
```bash
pip3 install oci-cli
```

**Terraform Provider Issues**
```bash
cd infrastructure/terraform
rm -rf .terraform/
terraform init
```

**VM Not Responding**
- Check Oracle Cloud Console for VM status
- Verify security list allows inbound traffic on ports 22, 8080, 11434

**Ollama Models Not Loading**
```bash
# SSH to VM
ollama list
ollama pull llama3.2:8b-instruct-q4_K_M
```

### Resource Limits

**Always Free Tier Limits:**
- 4 ARM Ampere A1 OCPUs total
- 24GB RAM total  
- 200GB block storage total
- 10TB monthly egress

If you hit limits, other free resources might be using your allocation.

### Logs and Debugging

**Service Logs:**
```bash
# Ollama logs
journalctl -u ollama -f

# Cylon API logs  
journalctl -u cylon-api -f

# System logs
dmesg | tail
```

**Performance Monitoring:**
```bash
htop           # CPU/RAM usage
iostat -x 1    # Disk I/O
nvidia-smi     # GPU (if available)
```

## Cleanup

To destroy all resources:
```bash
cd infrastructure/terraform
terraform destroy
```

This will delete:
- VM instance
- Storage volumes
- Network resources
- All data

**Note**: Always backup important data before destroying resources.

## Security Considerations

- **SSH Keys**: Keep your private keys secure
- **API Access**: VM is accessible from internet by default
- **Firewall**: Consider restricting access to your IP only
- **Updates**: Keep VM updated with security patches

## Cost Monitoring

The deployment uses only Always Free resources, but monitor:
- Oracle Cloud Console for usage
- Set up billing alerts as precaution
- Review monthly usage reports

## Next Steps

After successful deployment:
1. **Test the API endpoints** with your projects
2. **Explore different models** (7B vs 8B performance)
3. **Customize system prompts** for your use cases
4. **Integrate with your development workflow**
