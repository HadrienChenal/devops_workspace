# td4/scripts/tofu/live/deploy.tftest.hcl

run "deploy" {
  command = apply
}

run "validate" {
  command = apply
  
  module {
    source = "../modules/test-endpoint"
  }

  variables {
    endpoint = "${run.deploy.api_url}/hello" 
  }

assert {
    condition     = data.http.test_endpoint.status_code == 201
    error_message = "L'API a répondu : ${data.http.test_endpoint.status_code} au lieu de 201"
  }

  assert {
    condition     = can(regex("Hello from DevOps ESIEE!", data.http.test_endpoint.response_body))
    error_message = "Le corps de la réponse est incorrect"
  }
}