# Terrafrom from 0 ...

- The ideal starting point is here: https://www.terraform.io/

## What is terafrom:
Terraform is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services. Terraform codifies cloud APIs into declarative configuration files.

## Local set up 
- I am completly sold on Docker so my fist check is for a docker container with terrafrom. Luckily enough Hashicorp provide a docker file for this purpose: https://hub.docker.com/r/hashicorp/terraform/

- https://www.terraform.io/docs/cli/commands/console.html
    ```
    $ docker run -i -t hashicorp/terraform:light console
    > 1+5
    6
    > {"f":(1+4)*2}
    {
    "f" = 10
    }
    ```

Debug
The terraform console  command is useful for testing interpolations before using them in configurations. Terraform console will read configured state even if it is remote.
- https://www.terraform.io/docs/configuration-0-11/interpolation.html

### Terraform Configuration Files
 - Terraform Language: https://www.terraform.io/docs/language/index.html
 - Note: tarraform config can be presented in json

The Terraform language consists of only a few elements:
    
    <BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
    # Block body
    <IDENTIFIER> = <EXPRESSION> # Argument
    }

The Terraform language is declarative, describing an intended goal rather than the steps to reach that goal. The ordering of blocks and the files they are organized into are generally not significant; Terraform only considers implicit and explicit relationships between resources when determining an order of operations.

When run, Terraform loads all configuration files from the current directory. So it's a good idea to organize your configurations into separate directories based on your needs (e.g. departments, production vs development, etc).

Terraform recognizes files ending in .tf or .tf.json as configuration files and will load them when it runs.

> Terraform Block: https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-build?in=terraform/gcp-get-started#terraform-block

> Providers: https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-build?in=terraform/gcp-get-started#providers

> Resource: https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-build?in=terraform/gcp-get-started#resource

## Install
 - https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform

## Terraform Initialization

> https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-build?in=terraform/gcp-get-started#initialization

    $ terraform init

## Creating Resources

> https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-build?in=terraform/gcp-get-started#creating-resources

    $ terraform apply

## Local Testing

- At the time of writing this I have browsed through the introductory documentation and starter tutorials but I really dont want to connect to any cloud providers just yet (mainly beccause I dont want to cost my self any $$$)
- So I began investigating does terraform provide any mocking or local testing utilities beyond https://www.terraform.io/docs/language/modules/testing-experiment.html

- Terraform Commands
    - Cli Cmds: https://www.terraform.io/docs/cli/commands/index.html

    ```
    $ docker run --rm -it --name terraform -v $(pwd):/workspace -w /workspace hashicorp/terraform:light 
    Usage: terraform [global options] <subcommand> [args]

    The available commands for execution are listed below.
    The primary workflow commands are given first, followed by
    less common or more advanced commands.

    Main commands:
    init          Prepare your working directory for other commands
    validate      Check whether the configuration is valid
    plan          Show changes required by the current configuration
    apply         Create or update infrastructure
    destroy       Destroy previously-created infrastructure

    All other commands:
    console       Try Terraform expressions at an interactive command prompt
    fmt           Reformat your configuration in the standard style
    force-unlock  Release a stuck lock on the current workspace
    get           Install or upgrade remote Terraform modules
    graph         Generate a Graphviz graph of the steps in an operation
    import        Associate existing infrastructure with a Terraform resource
    login         Obtain and save credentials for a remote host
    logout        Remove locally-stored credentials for a remote host
    output        Show output values from your root module
    providers     Show the providers required for this configuration
    refresh       Update the state to match remote systems
    show          Show the current state or a saved plan
    state         Advanced state management
    taint         Mark a resource instance as not fully functional
    test          Experimental support for module integration testing
    untaint       Remove the 'tainted' state from a resource instance
    version       Show the current Terraform version
    workspace     Workspace management

    Global options (use these before the subcommand, if any):
    -chdir=DIR    Switch to a different working directory before executing the
                    given subcommand.
    -help         Show this help output, or the help for a specified subcommand.
    -version      An alias for the "version" subcommand.
    ```

    ```
    $ docker run -d -it --name terraform --entrypoint "/usr/bin/tail" -v ${PWD}:/workspace -w /workspace hashicorp/terraform:light sh tail -f /dev/null
    7348eefdd8b8a0714f8bfc45b8e04246383eb37beedac7c05f4ec8d62b3d8e4e
    DH@Daryls-MBP-2 terraform-traning $ docker exec -it terraform sh
    /workspace # ls
    README.md  main.tf
    /workspace # terraform 
    ...
    ```

1. Start Localstack running on Docker
    - https://github.com/localstack/localstack

    ```
    $ docker run --rm -it -p 4566:4566 -p 4571:4571 localstack/localstack
    $ curl http://localhost:4566/#/infra
    {"status": "running"}
    ```

2. Create a `main.tf` and add the following: [main.tf](main.tf)
    - Ref: https://github.com/hashicorp/terraform-provider-aws/issues/6629

3. Run Terraform init

    ```
    $ terraform init

    Initializing the backend...

    Initializing provider plugins...
    - Reusing previous version of hashicorp/aws from the dependency lock file
    - Installing hashicorp/aws v3.47.0...
    - Installed hashicorp/aws v3.47.0 (self-signed, key ID 34365D9472D7468F)

    Partner and community providers are signed by their developers.
    If you'd like to know more about provider signing, you can read about it here:
    https://www.terraform.io/docs/cli/plugins/signing.html

    Terraform has made some changes to the provider dependency selections recorded
    in the .terraform.lock.hcl file. Review those changes and commit them to your
    version control system if they represent changes you intended to make.

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ```

4. Run Terraform validate

    ```
    $ terraform validate
    Success! The configuration is valid.
    ```

5. Run Terraform apply
    
    ```
    $ terraform apply -auto-approve
    aws_s3_bucket.b: Creating...
    aws_s3_bucket.b: Creation complete after 1s [id=my-tf-test-bucket]

    Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
    ```

6. Run Terraform plan

    ```
    $ terraform plan
    aws_s3_bucket.b: Refreshing state... [id=my-tf-test-bucket]

    No changes. Infrastructure is up-to-date.

    This means that Terraform did not detect any differences between your
    configuration and real physical resources that exist. As a result, no
    actions need to be performed.
    ```

7. Run Terraform destroy
    
    ```
    $ terraform destroy -auto-approve
    aws_s3_bucket.b: Destroying... [id=my-tf-test-bucket]
    aws_s3_bucket.b: Destruction complete after 0s

    Destroy complete! Resources: 1 destroyed.
    ```

## Logging
- Terraform Turn on Error Logging
- Choose one of the export TF_LOG options below to set your logging level.

    export TF_LOG=DEBUG
    export TF_LOG=ERROR
    export TF_LOG=INFO
    export TF_LOG=WARN
    export TF_LOG=TRACE

## Terraform Conmments
- https://www.terraform.io/docs/language/syntax/configuration.html#comments

# Refs:
- https://www.mrjamiebowman.com/software-development/docker/running-terraform-in-docker-locally/
- https://github.com/UlisesGascon/sample-terraform-localstack