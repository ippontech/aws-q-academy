# GitHub Actions Best Practices

When generating or modifying GitHub actions template files, follow these best practices:

## Code Best Practices

- When you use setup-* actions, try to get the latest versions of the software you need to install
- Use pre-commit to run the hooks of the repository in the CI and install required software so hooks can work
