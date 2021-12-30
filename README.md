# Gitpod Rust Workspace

### Why is this needed?

Gitpod workspaces have rust installed. Well actually not the latest releases which makes it hard to use new(er) features with old(er) versions of rust.

The main workspaces also do not include rust components, addons and binaries such as rls, rust-analysis, clippy, flamegraph, udeps and many more to make the setup more productive.

Gitpod also doesn't really look after cleaning their k8s caches after releasing a new version of an image for workspaces which is poor support for _latest_ (unversioned) images

### What id does

Heres a summary of what's done:
 - Sets the default shell to bash
 - installs docker supporting docker buildx
 - installs poadmn
 - Installs and updates rust stable and nightly
 - Adds the rustup components clippy, rustfmt, rls and rust-analysis
 - Installs the binaries of cargo-watch, cargo-outdated, cargo-audit, diesel_cli, cargo-binstall, cargo-geiger, cargo-all-features, cargo-whatfeatures, cargo-spellcheck, cargo-udeps, flamegraph

### How to get it setup

This approach let's you be notified when this image updates and let's you opt in at your pace.

First let's create a `.gitpod.Dockerfile` file (or where and however you would save and name it)
```dockerfile
FROM chweicki/gitpod-rust-workspace:0.0.1
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
```


