# IceBreaker One Registry

This repository contains:

  * A tool to use a definition in another repository to create a Registry for a Trust Framework, outputting a static site.
  * The definition for the IB1 Root Registry, which includes IB1's RDF Schema.

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

  * The RDF schema definition with the namespace `https://registry.ib1.org/ns/1.0#`
  * A "Trust Framework Group" listing all known Trust Frameworks.

## Generating another Registry

Clone the repository which contains the definition for the registry next to this repository, for example, the Core Trust Framework, then run:

```
script/ib1-registry production ../registry-core
```

## Guided tour

[registry/root](registry/root/) -- the definition for the root registry.

[model](model/) -- models which define the RDF classes for the namespaces used by IB1.

[script](script/) -- scripts which generate a static site from Registry definitions.

[web](web/) -- static resources and templates to generate the HTML for the Registry.

[pom.xml](pom.xml) -- Java dependencies, including JRuby, as a Maven POM file. It can only be used via the `prepare.sh` script.
