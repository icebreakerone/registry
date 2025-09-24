# Adding an environment to an existing Trust Framework

This document shows the steps to add `newenv` to the `core` Trust Framework. Replace the names in the instructions.


## Review conditional contents

Search the `registry/core` directory for `IncludeIn` statements, which conditionally include Registry resources depending on the environment name.

The commands take two arguments, a list of environments and a description of the conditional resources.


## Test generated Registry

Run the Registry generation script locally, run a test server, and check the contents in your web browser.

```
script/ib1-registry newenv registry/core && script/server
```

* Visit `http://127.0.0.1:7070` in your browser to view the generated registry. Follow the link to the `/registry` URL, and review the generated RDF.

* If needed, add additional `IncludeIn` statements to remove contents from the Registry. Ensure that the list of environments in your new command is correct.

* Review the output from the command to look for lines beginning `"*** Omitting ..."`. Adjust the `IncludeIn` statements if anything is omitted incorrectly.

* Stop the server and re-run the script, then check the revised version of the Registry in your browser.


## Add new GitHub Workflow

* Find a workflow file in the `.github\workflows\` directory which generates another environment for this Trust Framework.

* Copy the file with a descriptive name.

* Edit the file to change the environment name to `newenv` in the YAML file. The name will appear in commands, hostnames, and descriptive text.

* If you are deploying a production environment, ensure the hostname does NOT contain the environment name.

* Commit the new Workflow file to the `main` branch. The first time it executes, it will take several minutes. Progress can be followed in the GitHub [Actions UI](https://github.com/icebreakerone/registry/actions).


## Troubleshooting

If the Action stalls, look at the logs, and try and work out what has not been created in AWS. For example, using ACM to create the Route 53 DNS entries to allow the certificate to be issued.

