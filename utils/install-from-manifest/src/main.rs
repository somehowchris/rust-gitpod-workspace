use std::{process::{Command, ExitStatus}, thread::Thread, time::Duration};

use cargo_toml::Manifest;
use indicatif::ProgressStyle;
use yansi::Paint;
use indicatif::ProgressBar;

// TODO input path
// TODO input name
// TODO input force
// TODO input verbose

// TODO support binstall whenever possible
// TODO use proper error handling/returning


fn main() {    
    let manifest = Manifest::from_path(".renovate/Cargo.toml").unwrap();
    
    let bar = ProgressBar::new(manifest.dependencies.len().try_into().unwrap());
    println!("     {} found {} crates to install", Paint::green("Peeking").bold(), manifest.dependencies.len());

    bar.set_style(
        ProgressStyle::default_bar()
            .template(&format!("  {} [{{bar:25.white/white}}] {{pos:>7}}/{{len:7}} {{msg}}", Paint::green("Installing").bold()))
            .progress_chars("=> "),
    );

    for (name, dependency) in manifest.dependencies.iter() {
        match dependency {
            cargo_toml::Dependency::Simple(version ) => {
                let mut command = Command::new("cargo");
                command.args(&[
                    "binstall",
                    name,
                    "--version",
                    version,
                    "--no-confirm"
                ]);

                bar.set_message(name.to_owned());

                let output = command.output().unwrap();

                if !output.status.success() {
                    bar.finish_and_clear();
                    println!("Failed during install of {}: {}", name, String::from_utf8(output.stdout).unwrap());
                    break;
                }
                bar.inc(1);
            }
            cargo_toml::Dependency::Detailed(details) => {
                let mut command = Command::new("cargo");

                command.args(&[
                    "install",
                    &details.package.to_owned().unwrap_or(name.to_owned()),
                ]);

                if let Some(ref version) = details.version {
                    command.args(&[
                        "--version",
                        version
                    ]);
                }

                if let Some(ref registry) = details.registry {
                    command.args(&[
                        "--registry",
                        registry
                    ]);
                }

                if let Some(ref registry_index) = details.registry_index {
                    command.args(&[
                        "--index",
                        registry_index
                    ]);
                }

                if let Some(ref path) = details.path {
                    command.args(&[
                        "--path",
                        path
                    ]);
                }

                if let Some(ref git) = details.git {
                    command.args(&[
                        "--git",
                        git
                    ]);
                }

                if let Some(ref branch) = details.branch {
                    command.args(&[
                        "--branch",
                        branch
                    ]);
                }

                if let Some(ref tag) = details.tag {
                    command.args(&[
                        "--tag",
                        tag
                    ]);
                }
                
                if let Some(ref rev) = details.rev {
                    command.args(&[
                        "--rev",
                        rev
                    ]);
                }

                command.args(&[
                    "--features",
                    &details.features.join(",")
                ]);

                if let Some(false) = details.default_features {
                    command.args(&[
                        "--no-default-features",
                    ]);
                }

                command.spawn().unwrap().wait_with_output().unwrap();
            }
        }
    }
    bar.set_message("");
    bar.finish();

    println!("  {}", Paint::green("Finished install").bold())
}
