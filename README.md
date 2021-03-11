# Modules in Terraform 0.13+

:bulb: This demo is to explain how the new `Terraform 0.13` syntax enhance the way we can use modules in `Terraform`.

## Overview

This demo is a single use-case implying:

* 👥 **dev** teams that develop Web applications
* 👤 an **ops** team that manages the whole _Cloud_ platform

🎯 The whole thing is to demonstrate a kind of _infra-as-code_ modularization where these teams might interact via `Terraform` in order to keep the whole _Cloud_ platform management in a single `Terraform` invokation.

![Farming Pokemon](https://assets.pokemon.com/assets/cms2/img/pokedex/full/031.png)

Let's say that a **dev** team is in charge of developping application that farm a **Pokemon** (either Carapuce, or Pikachu, or whatever…).  
At the end of the day, we have multiple applications that are _mostly the same on a technical architecture point of view_:

* all are packaged and deployed as `Docker` container
* all are Web application exposed via a _regular_ endpoint

But they may also rely on specific development with differences in their architecture:

* one needs a _database_
* another one needs an object storage
* another one requires specific _endpoints_…

And the **ops** team is willing to manage a consistent _Cloud_ platform thanks to `Terraform` _infra-as-code_ single repository of code.  
We'll see how to use `Terraform` **modules** to do so…  
And how the new module invokation syntax included in `Terraform 0.13` facilitates this…

## How to set-up your lab for this demo?

See [lab-setup.md](documentation/lab-setup.md).

## Step-1: our 2 first pokemons

:bulb: `Terraform` code is in [step-1](./step-1) folder.  
In this step, we deploy our 2 first pokemons: **Bulbizarre** and **Pikachu**.  
To do so, we create for each pokemon `Google Cloud Run` resources:

* a service
* and _IAM_ credentials to authorize public requests to this service

### How do we deploy?

```bash
cd /code/terraform/step-1
terraform_0.12.30 init
terraform_0.12.30 plan
terraform_0.12.30 apply --auto-approve
```

### What do we see?

`Terraform` code is replicated for each pokemon with variations on resource names.  
Not really scalable.

## Step-2: introducing module

:bulb: `Terraform` code is in [step-2](./step-2) folder.  
In this step, we're adding 2 more pokemons: **Salamèche** and **Carapuce**.  
The difference here is that we use a `Terraform` **module**, to factorize our `Terraform` code.

### How do we deploy?

```bash
cd /code/terraform/step-2
terraform_0.12.30 init
terraform_0.12.30 plan
terraform_0.12.30 apply --auto-approve
```

### What do we see?

We describe `Google Cloud Run` resources **once** :tada: in the module :

* a service
* and _IAM_ credentials to authorize public requests to this service

and we invoke them as many times as we have new pokemons to deploy.  
`Terraform` code is replicated for each pokemon with variations on resource names.  
Not really scalable.

The down sides are:

* for every new pokemon, we have to write a new block of code to invoke the module instance and to value variables in a proper way. In other word, every time a **dev** team deliver a new pokemon, the **ops** team has to alter its `Terraform` code.
* all module invokation has to be the same because of variable inputs/outputs to the module. We cannot have 2 invokations of the module with very different set of variables

### What if?

😎🏝 How cool might it be to give a list of pokemon and the `Terraform` code was able to iterate through it!
