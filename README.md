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
