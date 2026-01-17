# td4/scripts/tofu/live/deploy.tftest.hcl

run "deploy" {
  command = apply
}

run "validate" {
  command = apply
  
  module {
    # On pointe vers le module de test (chemin relatif depuis le dossier live)
    source = "../modules/test-endpoint"
  }

  variables {
    # On récupère l'output du premier bloc "run"
    endpoint = "${run.deploy.api_url}/hello" 
  }

  assert {
    condition     = data.http.test_endpoint.status_code == 200
    error_message = "L'API a répondu avec le code : ${data.http.test_endpoint.status_code}"
  }

  assert {
    # Attention : la réponse est un JSON, on vérifie si le texte contient le message
    condition     = can(regex("Hello from Lambda!", data.http.test_endpoint.response_body))
    error_message = "Le corps de la réponse est incorrect : ${data.http.test_endpoint.response_body}"
  }
}