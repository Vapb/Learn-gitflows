# HCL
# Not Deprecated

resource "aws_s3_bucket" "datalake" {
  # Paramentros de config do recurso escolhido
  # bucket = "datalake-vapb-id"
  bucket = "${var.base_bucket_name}-${var.ambiente}-${var.numero_conta}"

  tags = {
    IES   = "IGTI",
    CURSO = "EDC"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "aws_encryption_example" {
  bucket = aws_s3_bucket.datalake.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "aws_acl_example" {
  bucket = aws_s3_bucket.datalake.id
  acl    = "private"
}

resource "aws_s3_object" "codigo_spark" {
  bucket = aws_s3_bucket.datalake.id
  key    = "emr-code/pyspark/job_spark_from_tf.py"
  acl    = "private"
  source = "../job_spark.py"
  # Faz uma tag no arquivo e só faz o overwrite se o arquivo for mudado.
  etag = filemd5("../job_spark.py")
}

provider "aws" {
  region = "us-east-1"
}