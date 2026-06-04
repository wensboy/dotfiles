## Dotfiles

**tips: currently under improvement**

> Some considerations regarding personal workflow (work environment):

- past:
  - Frequent switching between Linux distributions makes it difficult to focus on learning the underlying Linux system.
  - Without maintaining a single configuration repository, every time a distro is switched, it requires rethinking and reconfiguring, wasting a lot of time.
  - There is no efficient work standard, and the various definitions are too flexible.
- now:
  - Build a single configuration repository, maintain consistency across multiple devices, synchronize at the repository level, maintain a minimum scalable configuration, and dynamically adjust each device.
  - Focus on the application and in-depth use of a single Linux distribution, avoiding over-configuration as much as possible, and prioritizing efficiency.
  - Keep it simple and clean.

> My personal definition of simplicity:

- No complicated or flashy UI elements.
- Tool combination.
- Text-first.
- Environmental isolation.

> Setting up the personal work environment:

**dependencies**
- terminal interface
    - [st]()
    - [tmux]()
    - [fzf]()
    - [tuigreet](https://github.com/apognu/tuigreet)
- wm
    - [dwm]()
    - [sway]()
    - [i3]()
    - [hypr]()
- menu
    - [rofi]()
- env
    - [nix flake]()
    - [podman]()
- editor
    - [vim]()
    - [vsc]()

**awesome projects**


> How to use the current project:

Note: You should always ensure that you use it on a base arch distro; there is currently no reason to adapt it for other distros.

```bash
git clone --depth=1 <repo_url>
cd dotfiles && chmod u+x ./init.sh
so ./init.sh
sync_config
```

Edit the script file to meet your configuration needs.