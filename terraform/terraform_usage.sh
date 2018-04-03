terraform plan \
  -var "do_token=${DO_PAT}" \
  -var "pub_key=$HOME/.ssh/id_ed25519.pub" \
  -var "pvt_key=$HOME/.ssh/id_ed25519" \
  -var "ssh_fingerprint=$SSH_FINGERPRINT"

terraform apply \
  -var "do_token=${DO_PAT}" \
  -var "pub_key=$HOME/.ssh/id_ed25519.pub" \
  -var "pvt_key=$HOME/.ssh/id_ed25519" \
  -var "ssh_fingerprint=$SSH_FINGERPRINT"
