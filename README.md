![Screenshot_2024-09-19_17_45_09](https://github.com/user-attachments/assets/873ef98a-48e0-445b-b5dc-eb5959ad5b34)

# <h1 align="center">Burpsuite Professional v2025 latest</h1>

<p align="center"> Burp Suite Professional is the web security tester's toolkit of choice. Use it to automate repetitive testing tasks - then dig deeper with its expert-designed manual and semi-automated security testing tools. Burp Suite Professional can help you to test for OWASP Top 10 vulnerabilities - as well as the very latest hacking techniques. Advanced manual and automated features empower users to find lurking vulnerabilities more quickly. Burp Suite is designed and used by the industry's best.</p>

<br>

# NixOS Installation
## Add this repo's flake to your flake inputs
```
# flake.nix
{
  # ...
  inputs = {
    burpsuitepro = {
      type = "github";
      owner = "xiv3r";
      repo = "Burpsuite-Professional";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # ...
}
```

## Installing the package provided by the flake
### You can install it with either `environment.systemPackages` or `home.packages`
> With `environment.systemPackages` (nixosModules)

  ```
    { inputs, ... }: {
      environment.systemPackages = [
        inputs.burpsuitepro.packages.${system}.default
      ];
    }
  ```

> With `home.packages` (home-manager)
 ```
    { inputs, ... }: {
      home.packages = [
        inputs.burpsuitepro.packages.${system}.default
      ];
    }
  ```

NOTE: `loader.jar` is symlinked to `burpsuite.jar` so burpsuite recognizes the license keys. You can access the `loader` command from the terminal only

<br>

## Updating the flake
Just run the update script:
```bash
./update_flake.sh
```
in order to update the Nix flake to the newest NixOS-unstable

<br>

## Credits

 <details><summary>Credit</summary>

* Loader.jar 👉 [h3110w0r1d-y](https://github.com/h3110w0r1d-y/BurpLoaderKeygen)
* Script 👉 [cyb3rzest](https://github.com/cyb3rzest/Burp-Suite-Pro)

</details>
