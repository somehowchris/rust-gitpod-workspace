# Gitpod Rust Workspace

### Why is this needed?

Gitpod workspaces have rust installed, well actually most of the time you are not running the version they specify in the docs which makes it hard to use new(er) features with old(er) versions of rust.

The main workspaces also do not include rust components, addons and binaries such as rls, rust-analysis, clippy, flamegraph, udeps and many more to make the setup more productive.

Gitpod also builds your base images everytime you create a workspace which takes some hours if you're into installing rust tooling fresh everytime.

### What's included

Heres a summary of what's done:
 - installs docker buildx
 - Installs and updates rust stable and nightly
 - Adds the rustup components clippy, rustfmt, rls and rust-analysis
 - Installs the binaries of diesel_cli, cargo-watch, cargo-outdated, cargo-audit, cargo-binstall, cargo-geiger, cargo-all-features, cargo-whatfeatures, cargo-spellcheck, cargo-udeps, flamegraph, cargo-edit, cargo-whatfeatures, cargo-expand
 - Adds debugging support for rust (according to https://www.gitpod.io/docs/languages/rust#debugging) within vs code
 - Installs jq, yq, mysql client and gh-cli

### How to get it setup

This approach let's you be notified when this image updates and let's you opt in at your pace.

First let's create a `.gitpod.Dockerfile` file (or where and however you would save and name it)
```dockerfile
FROM chweicki/gitpod-rust-workspace:0.0.2
```

Next lets add the following lines to your `.gitpod.yml` file:
```yml
image:
  file: .gitpod.Dockerfile
```

Commit these changes and your workspace will be setup with this image as it's base image.

If you would like to get notified about image updates, opt into services like [renovate](https://www.whitesourcesoftware.com/free-developer-tools/renovate/) or [dependabot](https://docs.github.com/en/code-security/supply-chain-security/managing-vulnerabilities-in-your-projects-dependencies/configuring-dependabot-security-updates)


#### VS Code Extensions

VS Code workspaces on gitpod usually do not come with rust extensions. Here are the ones I like to use (if you feel like using them just copy paste the yaml into your `.gitpod.yml`):
```yml
vscode:
  extensions:
    - ms-azuretools.vscode-docker
    - rust-lang.rust
    - pinage404.rust-extension-pack
    - belfz.search-crates-io
    - webfreak.debug
    - Swellaby.vscode-rust-test-adapter
```


#### Debugging

To support debugging within vscode you need to install the vs code extension `webfreak.debug` and add the following `launch.json` and `tasks.json` in a `.vscode/` folder.

__launch.json__
```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    "version": "0.2.0",
    "configurations": [
        {
            "type": "gdb",
            "request": "launch",
            "name": "Debug Rust Code",
            "preLaunchTask": "cargo",
            "target": "${workspaceFolder}/target/debug/<bin-name>",
            "cwd": "${workspaceFolder}",
            "valuesFormatting": "parseText"
        }
    ]
}
```
> Replace `<bin-name>` with the name of your actual binary


__tasks.json__
```tasks.json
{
    "tasks": [
        {
            "command": "cargo",
            "args": [
                "build"
            ],
            "type": "process",
            "label": "cargo"
        }
    ]
}
```

> if you need any support setting this up, head over to the [gitpod tutorial about debugging](https://www.gitpod.io/docs/languages/rust#debugging)

After this setup, head into the debug pannel of vs code, setup breakpoints and click "Debug Rust Code" in the debug pannel