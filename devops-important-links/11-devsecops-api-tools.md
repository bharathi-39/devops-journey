# DevSecOps and API Tools

## Official References

- [OWASP Documentation](https://owasp.org/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Trivy Documentation](https://trivy.dev/latest/docs/)
- [SonarQube Documentation](https://docs.sonarsource.com/sonarqube-server/)
- [HashiCorp Vault Documentation](https://developer.hashicorp.com/vault/docs)
- [curl Documentation](https://curl.se/docs/)
- [Postman Learning Center](https://learning.postman.com/docs/)
- [jq Manual](https://jqlang.org/manual/)

## Use These For

- Security scanning and secure delivery practices
- Container, dependency, filesystem, and IaC scanning
- Secret management
- Testing APIs and parsing JSON responses in automation scripts

## Useful Commands

```bash
curl -sS https://api.example.com | jq .
trivy image <image-name>
jq -r '.items[].name' response.json
```
