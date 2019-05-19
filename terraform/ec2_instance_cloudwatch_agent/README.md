## Cloudwatch Agent example

**Important!**
This is just an example that should not be used in production as is. https encryption is ommited for simplicity.
Before using this example please have a look at `locals.tf` and adjust it accordingly if needed.

This example will spin up an instance which will install and configure an nginx webserver along with CloudWatch Agent. The nginx webserver will provide a basic auth password protected directory listing. The http username and password will be shown on stdout when terraform apply is finished.
