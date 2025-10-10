# Support

Welcome to the Community Engagement Medicaid support resources! This document provides information on how to get help, report issues, and find resources for using and contributing to the project.

## 🆘 Getting Help

### Quick Start Resources

- **[README.md](README.md)**: Project overview and quick start guide
- **[Documentation](docs/)**: Comprehensive technical documentation
- **[Contributing Guide](CONTRIBUTING.md)**: How to contribute to the project
- **[Security Policy](SECURITY.md)**: Security practices and reporting

### Self-Service Resources

Before reaching out for support, please check these resources:

1. **[Project Documentation](docs/)**
   - [System Architecture](docs/system-architecture.md)
   - [Reporting App Documentation](docs/reporting-app/)
   - [Infrastructure Guide](docs/infra/)

2. **[GitHub Issues](https://github.com/navapbc/community-engagement-medicaid/issues)**
   - Search existing issues for similar problems
   - Check closed issues for resolved problems
   - Review issue labels for categorization

3. **[GitHub Discussions](https://github.com/navapbc/community-engagement-medicaid/discussions)**
   - Community Q&A
   - Feature discussions
   - General project discussions

## 🐛 Reporting Issues

### Bug Reports

If you've found a bug, please help us fix it by providing detailed information:

1. **Search existing issues** to avoid duplicates
2. **Use the bug report template** when creating a new issue
3. **Include the following information**:
   - Clear description of the problem
   - Steps to reproduce the issue
   - Expected vs. actual behavior
   - Environment details (OS, browser, version)
   - Screenshots or error messages
   - Any relevant log files

**[Create a Bug Report](https://github.com/navapbc/community-engagement-medicaid/issues/new?template=bug_report.md)**

### Feature Requests

We welcome suggestions for new features and improvements:

1. **Check existing feature requests** to avoid duplicates
2. **Use the feature request template**
3. **Describe**:
   - The problem you're trying to solve
   - Your proposed solution
   - Alternative solutions considered
   - Additional context or use cases

**[Request a Feature](https://github.com/navapbc/community-engagement-medicaid/issues/new?template=feature_request.md)**

### Security Issues

**Do NOT create public issues for security vulnerabilities.**

Instead, please report security issues privately:
- **Email**: [security@navapbc.com](mailto:security@navapbc.com)
- **Subject**: "Security Vulnerability - Community Engagement Medicaid"

See our [Security Policy](SECURITY.md) for detailed reporting guidelines.

## 💬 Community Support

### GitHub Discussions

Our primary community forum for questions and discussions:

- **[Q&A](https://github.com/navapbc/community-engagement-medicaid/discussions/categories/q-a)**: Ask questions and get help
- **[Ideas](https://github.com/navapbc/community-engagement-medicaid/discussions/categories/ideas)**: Share and discuss new ideas
- **[Show and Tell](https://github.com/navapbc/community-engagement-medicaid/discussions/categories/show-and-tell)**: Share your implementations
- **[General](https://github.com/navapbc/community-engagement-medicaid/discussions/categories/general)**: General project discussions

### Community Guidelines

When participating in community discussions:

- Be respectful and inclusive
- Follow our [Code of Conduct](CODE_OF_CONDUCT.md)
- Search existing discussions before posting
- Provide context and details in your questions
- Help others when you can
- Stay on topic and be constructive

## 🏛️ Official Support Channels

### For State Agencies and Government Partners

If you represent a state Medicaid agency or government organization:

- **Partnership Inquiries**: [partnerships@navapbc.com](mailto:partnerships@navapbc.com)
- **Implementation Support**: [implementation@navapbc.com](mailto:implementation@navapbc.com)
- **Compliance Questions**: [compliance@navapbc.com](mailto:compliance@navapbc.com)

### For Organizations and Vendors

If you're an organization looking to implement or integrate with the platform:

- **Technical Integration**: [integration@navapbc.com](mailto:integration@navapbc.com)
- **Business Inquiries**: [business@navapbc.com](mailto:business@navapbc.com)
- **Partnership Opportunities**: [partnerships@navapbc.com](mailto:partnerships@navapbc.com)

## 📚 Documentation and Resources

### Technical Documentation

- **[API Documentation](docs/api/)**: API reference and integration guides
- **[Deployment Guide](docs/infra/)**: Infrastructure and deployment instructions
- **[Development Guide](docs/development/)**: Local development setup and guidelines
- **[Architecture Overview](docs/system-architecture.md)**: System design and components

### User Guides

- **[User Manual](docs/user-guide/)**: End-user documentation
- **[Administrator Guide](docs/admin-guide/)**: System administration instructions
- **[Staff Training Materials](docs/training/)**: Training resources for staff users

### Policy and Compliance

- **[Compliance Documentation](docs/compliance/)**: Regulatory compliance information
- **[Privacy Policy](docs/privacy/)**: Data privacy and protection policies
- **[Accessibility Statement](docs/accessibility/)**: Accessibility compliance and features

## 🔧 Technical Support

### Development Environment Issues

Common development setup issues and solutions:

1. **Docker/Container Issues**
   - Ensure Docker is running and up to date
   - Check available disk space and memory
   - Try rebuilding containers: `make e2e-clean && make init-container`

2. **Database Connection Issues**
   - Verify environment variables are set correctly
   - Check database container is running
   - Review database logs for connection errors

3. **Authentication Issues**
   - Verify AWS Cognito configuration
   - Check environment variables for auth settings
   - Review authentication adapter configuration

4. **Build and Deployment Issues**
   - Check AWS credentials and permissions
   - Verify Terraform configuration
   - Review GitHub Actions logs for CI/CD issues

### Performance and Monitoring

For performance issues or monitoring questions:

- **[Monitoring Guide](docs/infra/monitoring.md)**: CloudWatch and alerting setup
- **[Performance Optimization](docs/performance/)**: Performance tuning guidelines
- **[Troubleshooting Guide](docs/troubleshooting/)**: Common issues and solutions

## 🚀 Professional Services

### Implementation Support

Nava PBC offers professional services for organizations implementing the platform:

- **Technical Implementation**: Architecture design and deployment assistance
- **Custom Development**: Feature development and customization
- **Training and Support**: Staff training and ongoing support
- **Compliance Assistance**: Help meeting regulatory requirements

**Contact**: [services@navapbc.com](mailto:services@navapbc.com)

### Consulting Services

- **Policy Analysis**: Medicaid policy and implementation consulting
- **Technical Architecture**: System design and integration planning
- **User Experience**: UX research and design services
- **Security Assessment**: Security audits and compliance reviews

## 📞 Contact Information

### General Inquiries

- **General Questions**: [info@navapbc.com](mailto:info@navapbc.com)
- **Project Website**: [https://www.navapbc.com/](https://www.navapbc.com/)
- **GitHub Repository**: [https://github.com/navapbc/community-engagement-medicaid](https://github.com/navapbc/community-engagement-medicaid)

### Specialized Support

- **Security Issues**: [security@navapbc.com](mailto:security@navapbc.com)
- **Code of Conduct**: [conduct@navapbc.com](mailto:conduct@navapbc.com)
- **Accessibility**: [accessibility@navapbc.com](mailto:accessibility@navapbc.com)
- **Privacy**: [privacy@navapbc.com](mailto:privacy@navapbc.com)

### Emergency Contact

For critical production issues affecting live systems:
- **Emergency Hotline**: Available to contracted partners
- **Incident Response**: [incident@navapbc.com](mailto:incident@navapbc.com)

## ⏰ Response Times

### Community Support (GitHub)

- **Issues**: We aim to respond within 2-3 business days
- **Pull Requests**: Initial review within 1-2 business days
- **Discussions**: Community-driven, responses vary

### Email Support

- **General Inquiries**: 3-5 business days
- **Security Issues**: 24-48 hours
- **Partnership Inquiries**: 1-2 business days
- **Emergency Issues**: Same day (for contracted partners)

### Business Hours

- **Standard Support**: Monday-Friday, 9 AM - 5 PM EST
- **Emergency Support**: 24/7 for critical production issues (contracted partners)

## 🌐 Additional Resources

### External Resources

- **CMS Resources**: [Centers for Medicare & Medicaid Services](https://www.cms.gov/)
- **USWDS**: [U.S. Web Design System](https://designsystem.digital.gov/)
- **AWS Documentation**: [Amazon Web Services](https://docs.aws.amazon.com/)
- **Ruby on Rails**: [Rails Guides](https://guides.rubyonrails.org/)

### Community Resources

- **Open Source Community**: Connect with other open source healthcare projects
- **Government Technology**: Resources for government technology initiatives
- **Accessibility Community**: Web accessibility resources and communities

## 📈 Feedback and Improvement

We continuously improve our support resources based on community feedback:

- **Documentation Feedback**: Suggest improvements to documentation
- **Support Process Feedback**: Help us improve our support processes
- **Feature Suggestions**: Propose new features or enhancements
- **User Experience Feedback**: Share your experience using the platform

**Feedback Form**: [feedback@navapbc.com](mailto:feedback@navapbc.com)

## 🎓 Training and Education

### Available Training

- **Developer Onboarding**: Getting started with development
- **Administrator Training**: System administration and configuration
- **End-User Training**: Using the platform effectively
- **Policy Training**: Understanding Medicaid community engagement requirements

### Training Resources

- **Video Tutorials**: Step-by-step video guides
- **Webinars**: Regular community webinars and Q&A sessions
- **Documentation**: Comprehensive written guides and tutorials
- **Hands-On Workshops**: Interactive training sessions

**Training Inquiries**: [training@navapbc.com](mailto:training@navapbc.com)

---

Thank you for using the Community Engagement Medicaid platform! We're here to help you succeed in implementing and using this important healthcare technology.
