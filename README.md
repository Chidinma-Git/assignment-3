# Assignment 3 — Docker, CI/CD & Automated Testing

A containerized Diagnostic CLI tool with automated testing and a GitHub Actions CI/CD pipeline.

## Project Structure

```text
assignment-3/
├── app/
│   ├── app.sh
│   └── health-check.sh
├── scripts/
│   ├── build.sh
│   └── lint.sh
├── tests/
│   └── test.sh
├── .github/
│   └── workflows/
│       └── ci.yml
├── .dockerignore
├── Dockerfile
└── compose.yaml

Features
- Display system information
- Check host connectivity
- Check TCP port connectivity
- Validate command arguments
- Run automated tests
- Build a Docker image
- Run the application inside Docker
- Run CI checks with GitHub Actions

Local Usage
Make scripts executable: chmod +x app/*.sh scripts/*.sh tests/*.sh
Run the CLI: ./app/app.sh
Display system information: ./app/app.sh system-info
Check a host: ./app/app.sh check-host localhost
Check a TCP port: ./app/app.sh check-port localhost 80
Run tests: ./tests/test.sh
Run lint: ./scripts/lint.sh
Docker
Build the image: docker build -t devops-tool .
Run the container: docker run --rm devops-tool system-info
Run the help command: docker run --rm devops-tool help
Docker Compose
Validate the Compose configuration: docker compose config
Run the application: docker compose run --rm diagnostic help

CI/CD
GitHub Actions automatically:
1. Checks out the repository
2. Makes scripts executable
3. Runs the test suite
4. Runs lint checks
5. Builds the Docker image
6. Performs a Docker smoke test

Testing
The test suite validates:
- Help command
- System information command
- Host checks
- Missing arguments
- Invalid commands
- Missing ports
- Non-numeric ports
- Invalid port ranges

Current test result:
Passed: 8
Failed: 0

Author: Chidinma Florence Amaobi
