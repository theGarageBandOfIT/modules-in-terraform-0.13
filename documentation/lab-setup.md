# How to set-up your lab for this demo?

:bulb: This demo runs on `Google Cloud Platform` so you have to setup a consistent working environment to use `Terraform` with a `GCP` project.

## Google Cloud Platform

You need:

* a `GCP` account
* a `GCP` project (here the name is `modules-terraform-013`)
* a `GCP` service account that is able to manipulate the right `GCP` resources (here the name is `test-lpiot@modules-terraform-013.iam.gserviceaccount.com` and it is **owner** of the `GCP` project i.e. it can manipulates any type of `GCP` resources)
* a _JSON_ key file including the credentials to impersonate this service account (here it is a file named `../credentials/gcp-key.json`)
* a `Google Cloud Storage` _bucket_ `Terraform` will use as its backend to store its `tfstate` and other work files (here the bucket is named `modules-terraform-013-tfstate`)
* a _lab_ environment including [Google Cloud SDK command-line](https://cloud.google.com/sdk/) (version 330.0.0 as of now)

## Terraform

* _lab_ environment including [Terraform CLI](https://www.terraform.io/)
  * `Terraform 0.12` (the latest subversion is [0.12.30](https://releases.hashicorp.com/terraform/)) for the first steps of the demo and to see the limitations of version `0.12` in modules invokation
  * `Terraform 0.13` (the latest subversion is [0.13.6](https://releases.hashicorp.com/terraform/)) for the next steps of the demo and to see how the new module invokation syntax enhances the way to handle it
  * you may then use the latest available version of `Terraform CLI` ([0.14.8](https://releases.hashicorp.com/terraform/) as of now) to upgrade your `tfstate`.

## Containerised lab envs

:bulb: You may use `docker` container to run these different versions of `Terraform`.  
[docker folder](../docker) includes a `dockerfile` to build a lab environnement including these 3 versions of Terraform.

To build the container image:

```bash
cd docker
sudo docker image build --tag lab .
```

To use this image as lab env:

```bash
# from the root of this actual repository clone
sudo docker container run -it --volume "$(pwd)":/code --env GOOGLE_PROJECT=modules-terraform-013 --env GOOGLE_APPLICATION_CREDENTIALS=/code/credentials/gcp-key.json --name sandbox lab:latest
```

## test a first terraform invokation

From within your lab env…

```bash
bash-5.1# terraform_0.12.30 --version
Terraform v0.12.30

Your version of Terraform is out of date! The latest version
is 0.14.8. You can update by downloading from https://www.terraform.io/downloads.html

bash-5.1# cd /code/terraform/step-0

bash-5.1# terraform_0.12.30 init

Initializing the backend...

Successfully configured the backend "gcs"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "google" (hashicorp/google) 3.59.0...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

bash-5.1# terraform_0.12.30 plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_compute_project_metadata.default will be created
  + resource "google_compute_project_metadata" "default" {
      + id       = (known after apply)
      + metadata = {
          + "echo" = "hello world"
        }
      + project  = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.

bash-5.1# terraform_0.12.30 apply --auto-approve
google_compute_project_metadata.default: Creating...
google_compute_project_metadata.default: Still creating... [10s elapsed]
google_compute_project_metadata.default: Creation complete after 12s [id=modules-terraform-013]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

You did it!  Your lab env is up-and-running!
