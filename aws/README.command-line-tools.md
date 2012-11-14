

AWS Command line tools
----------------------

### Configuring Credentials

Most AWS command line tools need two enviroment variables configured:

    export AWS_ACCESS_KEY_ID="my_key"
    export AWS_SECRET_ACCESS_KEY="my_secret"


On the other hand, just some tools need a *__credential file__* present with the following format:

    #
    # aws-credential-file.cfg
    #
    AWSAccessKeyId=my_key
    AWSSecretKey=my_secret

    #
    # shell
    #
    $ chmod 600 /path/to/credential-file.cfg


To configure your credentials only once, put in your *__~/.bashrc__*:

    #
    # ~/.bashrc
    #
    export   AWS_CREDENTIAL_FILE="~/.aws/aws-credential-file.cfg"
    export     AWS_ACCESS_KEY_ID=$( awk -F= '/AccessKey/ {print $2}' $AWS_CREDENTIAL_FILE )
    export AWS_SECRET_ACCESS_KEY=$( awk -F= '/SecretKey/ {print $2}' $AWS_CREDENTIAL_FILE )





this way, you do not need to repeat your keys in two different places.



Some observations:


1. DO NOT put your credentials directly in your *__~/.bashrc__*
1. DO NOT commit your *__~/.bashrc__* into github, or any public repo, with your credentials in it.
1. DO NOT input your credentials in any public server or service. Create a subset of your credentails, if needed.

1. DO make your credentials file private, via *__chmod 600__*

1. YOU MAY save your credentials file in git, in another separate private(!!) repo.
1. YOU MAY symlink your credentials file to your *__$HOME__*, specially if it is separated in a private path.
1. YOU CAN symlink your credentails file, specially if you have more than one account:


        # Switching to account 1
            ln -nsf /path/to/private/dir/aws-dev-credentials.cfg   ~/.aws/aws-credential-file.cfg
            source ~/.bashrc

        # Switching to account 2
            ln -nsf /path/to/private/dir/aws-prod-credentials.cfg  ~/.aws/aws-credential-file.cfg
            source ~/.bashrc



### Installation

On the MacOSX, use [Homebrew](http://mxcl.github.com/homebrew/) to install.

The list of itens to install is:


    # EC2
    #     $ brew install ec2-ami-tools
    #     $ brew install ec2-api-tools
    --
    # RDS
    #     $ brew install rds-command-line-tools
    --
    # ELB
    #     $ brew install elb-tools
    --
    # AS
    #     $ brew install auto-scaling
    --
    # IAM
    #     $ brew install aws-iam-tools
    --
    # Cloud-Watch
    #     $ brew install cloud-watch
    --
    # ElastiCache
    #     $ brew install aws-elasticache
    --
    # CloudFormation
    #     $ brew install aws-cfn-tools
    --
    # SimpleNotificationService
    #     $ brew install aws-sns-cli


All tools need a specific *__$AWS_<<TOOL>>_HOME__* set. For a complete example, see
[aws.sh](https://github.com/mv/home/blob/master/bash.d/40-aws.sh)

/* vim:ft=markdown */

