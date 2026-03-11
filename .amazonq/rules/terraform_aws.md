# Terraform AWS Best Practices

When generating or modifying Terraform code for AWS, follow these best practices:

## AWS Configuration

- Use the `ippon-data-lab` AWS profile to connect to AWS.
- Amazon Q Jetbrains plugin overrides variable AWS_CONFIG_FILE with an empty temporary file which hides the content
of `~/.aws/config` file. You must force the use of the right file to get AWS credentials in the environment to apply
Terraform code in Amazon Q as such:

```shell
AWS_CONFIG_FILE=~/.aws/config
```

## Init / Plan / Apply

- Amazon Q does not deal well with Terraform colorful outputs so use the -no-color option when performing Terraform commands.
