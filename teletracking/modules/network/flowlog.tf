resource "aws_flow_log" "hub-flow-logs" {
  log_destination      = aws_s3_bucket.hub-fl-bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.vpc.vpc_id
}

resource "aws_flow_log" "pod-flow-logs" {
  log_destination      = aws_s3_bucket.pod-fl-bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.vpc_pod.vpc_id
}

resource "aws_s3_bucket" "hub-fl-bucket" {
  bucket = "hub-fl-bucket"
}

resource "aws_s3_bucket" "pod-fl-bucket" {
  bucket = "pod-fl-bucket"
}