terraform {
  backend "gcs" {
    bucket         = "starlake-tfm-state"
    prefix         = "starlake-dev/terraform/state"
    encryption_key = "x5ULeW7R9NNodRfmovnVrzUUuPf1QuL3DduGu1K842g="
  }
}
