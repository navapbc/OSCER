<h1 align="center">
  Community Engagement Medicaid
  <img width="300" src="/img/logoname-white.svg#gh-dark-mode-only" alt="infisical">
</h1>
<p align="center">
  <p align="center"><b>A comprehensive platform for managing Medicaid community engagement requirements</b>: built to help states implement and administer work requirements and exemption processes in compliance with federal regulations.</p>
</p>
<p align="center">
  <p align="center"><b>Built with Nava Strata</p>
</p>

<h4 align="center">
  <a href="https://navapbc.com">Website</a> |
  <a href="https://navapbc.com/careers">Hiring (Remote)</a>
</h4>

<h4 align="center">
  <a href="https://github.com/navapbc/community-engagement-medicaid/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-apache_2.0-red" alt="OSCER is released under the Apache 2.0 license" >
  </a>
  <a href="https://github.com/navapbc/community-engagement-medicaid/blob/main/CONTRIBUTING.md">
    <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen" alt="PRs welcome!" />
  </a>
  <a href="https://github.com/navapbc/community-engagement-medicaid/issues">
    <img src="https://img.shields.io/github/commit-activity/m/navapbc/community-engagement-medicaid" alt="git commit activity" />
  </a>
  <a href="https://github.com/navapbc/community-engagement-medicaid/repos/">
    <img alt="GitHub Downloads (all assets, all releases)" src="https://img.shields.io/github/downloads/navapbc/community-engagement-medicaid/total">
  </a>
</h4>

<img src="/img/OSCER_github_repo.png" width="100%" alt="Dashboard" />

## Introduction

Nava’s Open Source Community Engagement Reporting tool (OSCER) is intended to be an open-source, self-contained application that plugs into existing Medicaid systems to handle end-to-end reporting to meet H.R.1 community engagement requirements (eligibility checks, reporting, verification) without locking into proprietary platforms or brittle customizations. 
	•	Open by default - transparent code and approach
	•	Sidecar architecture - integrates with existing cloud systems with minimal and well-defined touchpoints
	•	State-owned - runs in state-hosted cloud environments and states retain full ownership of the deployment, configuration, and data

Why OSCER 
State Medicaid programs face real constraints: 
	•	Proprietary COTS platforms: Slow to change, rigid licensing and customization
	•	Closed custom builds: Every update becomes a costly change order, code often isn’t yours
	•	Vendor lock-in: limited code access, slower security review, no reusable improvements

OSCER is approaching this differently than other vendors with transparent code, modular integration, and an architecture designed for frequent policy change. 

## Architecture

The platform consists of:

- **Reporting Application**: Ruby on Rails web application with modern UI using U.S. Web Design System (USWDS)
- **Cloud Infrastructure**: AWS-based infrastructure with Terraform for Infrastructure as Code
- **Security & Compliance**: Built with security best practices and compliance requirements in mind

### Key Technologies

- **Backend**: Ruby on Rails 7.2, PostgreSQL
- **Frontend**: USWDS, ERB templates, JavaScript
- **Infrastructure**: AWS (ECS, RDS, Cognito, S3, SES), Terraform
- **Testing**: RSpec, Playwright (E2E)
- **CI/CD**: GitHub Actions

## Getting Started

### Prerequisites

- Docker or Finch (container runtime)
- AWS account with appropriate permissions
- Ruby 3.x (for native development)
- Node.js LTS (for native development)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/navapbc/community-engagement-medicaid.git
   cd community-engagement-medicaid
   ```

2. **Set up environment variables**

   ```bash
   cd reporting-app
   make .env
   # Edit .env file with your configuration
   ```

3. **Run with Docker (Recommended)**

   ```bash
   make init-container
   make start-container
   ```

   Or **run natively**:

   ```bash
   make init-native
   make start-native
   ```

4. **Access the application**
   - Open http://localhost:3000 in your browser
   - Default authentication is set to mock mode for development

### Infrastructure Setup

For production deployment, see our comprehensive [infrastructure documentation](docs/infra/).

```bash
# Set up AWS account and infrastructure
make infra-set-up-account ACCOUNT_NAME=your-account-name
make infra-configure-network NETWORK_NAME=dev
make infra-update-app-build-repository APP_NAME=reporting-app
```

## Documentation

- **[System Architecture](docs/system-architecture.md)** - High-level system overview
- **[Reporting App Documentation](docs/reporting-app/)** - Detailed application documentation
- **[Infrastructure Guide](docs/infra/)** - Deployment and infrastructure management
- **[Contributing Guidelines](CONTRIBUTING.md)** - How to contribute to the project
- **[Security Policy](SECURITY.md)** - Security practices and reporting

## Contributing

We welcome contributions from the community! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on:

- Code of conduct
- Development workflow
- Pull request process
- Coding standards

## License

This repo available under the [Apache 2.0 License](https://github.com/navapbc/community-engagement-medicaid/blob/main/LICENSE)

If you are interested in an integration for your state managed by Nava, take a look at [our website](https://navapbc.com/).

## Support

- **Documentation**: Check our [comprehensive documentation](docs/)
- **Issues**: Report bugs and request features via [GitHub Issues](https://github.com/navapbc/community-engagement-medicaid/issues)
- **Discussions**: Join community discussions in [GitHub Discussions](https://github.com/navapbc/community-engagement-medicaid/discussions)
- **Security**: Report security vulnerabilities via our [Security Policy](SECURITY.md)

For more information about Medicaid community engagement requirements and this platform, please visit our [documentation](docs/) or contact the development team.
