# Certificate Generation with CFSSL

This guide explains how to generate TLS certificates using CloudFlare's PKI/TLS toolkit (CFSSL) for your K8s setup.

## Prerequisites

### Install CFSSL and CFSSLJSON:
```bash
# Install CFSSL and CFSSLJSON
sudo curl -LO https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssl_1.6.5_linux_amd64
sudo curl -LO https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssljson_1.6.5_linux_amd64

sudo install -m 755 cfssl_1.6.5_linux_amd64 /usr/local/bin/cfssl
sudo install -m 755 cfssljson_1.6.5_linux_amd64 /usr/local/bin/cfssljson

# Or install using Go (if you have Go installed)
go install github.com/cloudflare/cfssl/cmd/cfssl@latest
go install github.com/cloudflare/cfssl/cmd/cfssljson@latest

# Add Go bin to PATH if not already added
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
source ~/.bashrc
```

## Certificate Generation Steps

### 1. Verify the Configuration Files

- `0-config.json`: Contains the certificate configuration
- `1-ca-csr.json`: Contains the Certificate Authority (CA) details
- `2-api-svestor-link-csr.json`: Contains the API certificate details

### 2. Generate the Certificate Authority (CA)

```bash
# Generate CA private key and certificate
cfssl gencert -initca 1-ca-csr.json | cfssljson -bare ca
```

This will create three files:
- `ca.pem`: The CA certificate
- `ca-key.pem`: The CA private key
- `ca.csr`: The certificate signing request (can be deleted after generation)

### 3. Generate the API Certificate

```bash
# Generate API certificate signed by the CA for api.svestor.link subdomain
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=0-config.json \
  -profile=svestor \
  2-api-svestor-link-csr.json | cfssljson -bare api-svestor-link
```

This will create:
- `api-svestor-link.pem`: The API certificate
- `api-svestor-link-key.pem`: The API private key
- `api-svestor-link.csr`: The certificate signing request (can be deleted after generation)

### 4. Verify the Certificates

```bash
# Verify the CA certificate
cfssl certinfo -cert ca.pem

# Verify the API certificate
cfssl certinfo -cert api-svestor-link.pem

# Verify the certificate chain
openssl verify -CAfile ca.pem api-svestor-link.pem

# To decode the certificate and view its contents
openssl x509 -in api-svestor-link.pem -text -noout
```

### 5. Create Kubernetes TLS Secret

To use the certificate in Kubernetes, create a TLS secret:

```bash
kubectl create secret tls api-svestor-link-tls \
  --cert=api-svestor-link.pem \
  --key=api-svestor-link-key.pem \
  --namespace=production  # Specify your namespace
```

## Security Considerations

1. **Private Keys**: Never commit private keys (files ending with `-key.pem`) to version control.
2. **File Permissions**: Set appropriate file permissions:
   ```bash
   chmod 600 *-key.pem
   chmod 644 *.pem
   ```
3. **Certificate Rotation**: Plan for regular certificate rotation.
4. **Certificate Revocation**: Maintain a Certificate Revocation List (CRL) if needed.

## Troubleshooting

- **CFSSL not found**: Ensure CFSSL is in your PATH or use the full path to the binary
- **Permission denied**: Use `sudo` or ensure you have write permissions in the current directory
- **Invalid certificate**: Verify all fields in your JSON files are correctly formatted

## References

- [CFSSL Documentation](https://github.com/cloudflare/cfssl)
- [Kubernetes TLS Secrets](https://kubernetes.io/docs/concepts/configuration/secret/#tls-secrets)
