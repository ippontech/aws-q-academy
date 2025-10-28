resource "tls_private_key" "self_signed" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "self_signed" {
  private_key_pem = tls_private_key.self_signed.private_key_pem

  subject {
    common_name  = "${local.name}.local"
    organization = var.project
  }

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_iam_server_certificate" "self_signed" {
  name             = "${local.name}-self-signed-cert"
  certificate_body = tls_self_signed_cert.self_signed.cert_pem
  private_key      = tls_private_key.self_signed.private_key_pem
}
