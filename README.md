# Modules in Terraform 0.13+

:bulb: This demo is to explain how the new `Terraform 0.13` syntax enhance the way we can use modules in `Terraform`.

- [Modules in Terraform 0.13+](#modules-in-terraform-013)
  - [Overview](#overview)
  - [How to set-up your lab for this demo?](#how-to-set-up-your-lab-for-this-demo)
  - [Step-1: our 2 first pokemons](#step-1-our-2-first-pokemons)
    - [How do we deploy?](#how-do-we-deploy)
    - [What do we see?](#what-do-we-see)
  - [Step-2: introducing module](#step-2-introducing-module)
    - [How do we deploy?](#how-do-we-deploy-1)
    - [What do we see?](#what-do-we-see-1)
    - [What if?](#what-if)
  - [Step-3: iterating module invokations through a list](#step-3-iterating-module-invokations-through-a-list)
    - [How do we deploy?](#how-do-we-deploy-2)
    - [What do we see?](#what-do-we-see-2)
    - [What if?](#what-if-1)
  - [Step-4: iterating module invokations through a list of JSON files](#step-4-iterating-module-invokations-through-a-list-of-json-files)
    - [How do we deploy?](#how-do-we-deploy-3)
    - [What do we see?](#what-do-we-see-3)
    - [What's next?](#whats-next)

## Overview

This demo is a single use-case implying:

- 👥 **dev** teams that develop Web applications
- 👤 an **ops** team that manages the whole _Cloud_ platform

🎯 The whole thing is to demonstrate a kind of _infra-as-code_ modularization where these teams might interact via `Terraform` in order to keep the whole _Cloud_ platform management in a single `Terraform` invokation.

![Farming Pokemon](https://assets.pokemon.com/assets/cms2/img/pokedex/full/031.png)

Let's say that a **dev** team is in charge of developping application that farm a **Pokemon** (either Carapuce, or Pikachu, or whatever…).  
At the end of the day, we have multiple applications that are _mostly the same on a technical architecture point of view_:

- all are packaged and deployed as `Docker` container
- all are Web application exposed via a _regular_ endpoint

But they may also rely on specific development with differences in their architecture:

- one needs a _database_
- another one needs an object storage
- another one requires specific _endpoints_…

And the **ops** team is willing to manage a consistent _Cloud_ platform thanks to `Terraform` _infra-as-code_ single repository of code.  
We'll see how to use `Terraform` **modules** to do so…  
And how the new module invokation syntax included in `Terraform 0.13` facilitates this…

## How to set-up your lab for this demo?

See [lab-setup.md](documentation/lab-setup.md).

## Step-1: our 2 first pokemons

:bulb: `Terraform` code is in [step-1](./step-1) folder.  
In this step, we deploy our 2 first pokemons: **Bulbizarre** and **Pikachu**.  
To do so, we create for each pokemon `Google Cloud Run` resources:

- a service
- and _IAM_ credentials to authorize public requests to this service

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

- a service
- and _IAM_ credentials to authorize public requests to this service

and we invoke them as many times as we have new pokemons to deploy.  
`Terraform` code is replicated for each pokemon with variations on resource names.  
Not really scalable.

The down sides are:

- for every new pokemon, we have to write a new block of code to invoke the module instance and to value variables in a proper way. In other word, every time a **dev** team deliver a new pokemon, the **ops** team has to alter its `Terraform` code.
- all module invokation has to be the same because of variable inputs/outputs to the module. We cannot have 2 invokations of the module with very different set of variables

### What if?

😎🏝 How cool might it be to give a list of pokemon and the `Terraform` code was able to iterate through it!

## Step-3: iterating module invokations through a list

:bulb: `Terraform` code is in [step-3](./step-3) folder.  
In this step, we refactor our code so that we can invoke the pokemon module automatically as many times as we have entries in a list.  
:warning: This code syntax is not available in `Terraform 0.12`: this is a new feature of `Terraform 0.13` and beyond.

### How do we deploy?

```bash
cd /code/terraform/step-3
terraform_0.13.6 init
terraform_0.13.6 plan
terraform_0.13.6 apply --auto-approve
```

### What do we see?

To be more specific, we duplicate the module so that we can easily compare the behaviour, invokation syntaxes and embedded codes: the new module is names pokemon_iterator.  

For a single pokemon, in a single invokation of the `pokemon_iterator` module, we pass all the variables _via_ a map named `pokemon_attributes`.  
This has several benefits:

- invokating a module is quite of a rigid interface between the main Terraform code and the module. By using a map, this interface becomes **lazy-coupled**: we can have more entries in the map on the main code than are required in the module and _vice-versa_.
- at scale, it is far easier to manipulate a map than several single variables

If we have more than one pokemon to deploy, we concatenate the maps of pokemon attributes in a map of maps named `pokemon_herd`.  
To automatically invoke the `pokemon iterator` module **as many times** as we have new pokemons to deploy, we just loops in the list of keys of `pokemon_herd` map of maps.  

The down side is:

- for every new pokemon, we still have to write a new entry into this `pokemon_herd` map of maps.

### What if?

😎🏝 How cool might it be to dynamically reconstruct this list of pokemons by retrieving a single file the dev teams might published when a new pokemon is ready to deploy!

## Step-4: iterating module invokations through a list of JSON files

:bulb: `Terraform` code is in [step-4](./step-4) folder.  
In this step, we consider that dev teams will publish a single `JSON` file for every new to-be-deployed pokemon.  
In this file, we find the _key-value pairs_ that formerly constituted the `pokemon_attributes` map of each pokemon.  
Here, we consider that the files have already been retrieved (through CI/CD automation) into a local folder named `pokemon_corral`.

:warning: This step cleans up all the former step-[0-2] pokemon creation.

### How do we deploy?

```bash
cd /code/terraform/step-4
terraform_0.13.6 init
terraform_0.13.6 plan
terraform_0.13.6 apply --auto-approve
```

### What do we see?

We finally made it: in this version of code, devs only have to publish a `JSON` file with their pokemon attributes et voilà!  
On **ops** side, once this `JSON` file has been retrieved, any new `plan/apply` of `Terraform` code will proceed to creation of `GCP` resources for this new pokemon.  

### What's next?

By decoupling platform management and instance needs that way, we may think about having a pokemon iterator which is capable of handling heterogeneous cases:

- being able to publish a new version of an already existing pokemon (a simple new `version` entry in the `pokemon_attributes` map should do the job)
- being able to create a kind of blueprint or another depending of a _toggle switch_ variable in `pokemon_attributes`. Ex: a pokemon that needs a DB or not. A pokemon that needs the V2 of the module (with a proxy to route to each Cloud Run service)

_To be continued_…
