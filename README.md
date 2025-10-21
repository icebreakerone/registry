# IceBreaker One Registry

This repository contains:

- A tool to use a definition in another repository to create a Registry for a Trust Framework, outputting a static site.
- The definition for the IB1 Root Registry, which includes IB1's RDF Schema.

Registry definitions use Ruby code to create RDF Resources in memory, which are written to files using Apache Jena. The use of Ruby allows definitions to be "type safe" to make it hard to write invalid RDF, and use a full programming language to write definitions which are more concise than raw RDF.

## Downloading dependencies

Install Java and Apache Maven as usual for your OS, then run this script to download the dependencies:

```
script/prepare.sh
```

## Command line tool

To generate a static site for publishing a Registry, run:

```
script/ib1-registry <environment> <registry-definition>
```

`<environment>` is the environment, such as `production`, `preview`, `development`, `demo`, `sandbox`. This affects the hostnames in the generated URLs for the Registry. `production` is special as it sets a 'plain' hostname without an environment name.

`<registry-definition>` is the path of the registry definition.

The static site is generated within the `output` directory.

## Using Docker

As an alternative to installing Java and Maven, you can use the included Dockerfile to build a suitable image:

```
docker build -t ib1-registry .
```

Then to build and output the registry files:

```
docker run --rm -v `pwd`/output/sandbox:/code/output-sandbox -e OUTPUT_DIR='output-sandbox' builder bash -c "script/ib1-registry sandbox registry/core"
```

## Preview web server

Run

```
script/server
```

to start a preview web server, which listens on port 7070.

This doesn't do content negotiation yet, but has a small hack to display the HTML index page for each RDF resource so links can be followed.

## Generating the IB1 Root Registry

Run

```
script/ib1-registry production registry/root
```

The root registry contains:

- The RDF schema definition with the namespace `https://registry.trust.ib1.org/ns/1.0#`
- A "Trust Framework Group" listing all known Trust Frameworks.

## Generating a Registry from a definition in this repository

The Registry definitions are in the [registry](registry) directory. For example, to generate the Core registry, run

```
script/ib1-registry production registry/core
```

## Generating a Registry from another repository

Clone the repository which contains the definition for the registry next to this repository, then refer to the location on the command line. For example,

```
script/ib1-registry production ../registry-example
```

## Deployment

The registries are deployed to AWS using the cdk stack in content_negotiation/. The stack expects a number of inputs: for example, to deploy the core sandbox registry:

```bash
cdk --context deploymentName=sandbox-core \
    --context domainName=registry.core.sandbox.trust.ib1.org \
    --context folderPath=core_sandbox_registry deploy \
    --require-approval never
```

Actions are enabled that will build and deploy all production registries when the main branch is updated.

## Guided tour

[README](README/) -- Documentation for managing Registries.

[registry](registry) -- registry definitions

[registry/root](registry/root/) -- the definition for the root registry.

[model](model/) -- models which define the RDF classes for the namespaces used by IB1.

[script](script/) -- scripts which generate a static site from Registry definitions.

[web](web/) -- static resources and templates to generate the HTML for the Registry.

[pom.xml](pom.xml) -- Java dependencies, including JRuby, as a Maven POM file. It can only be used via the `prepare.sh` script.
