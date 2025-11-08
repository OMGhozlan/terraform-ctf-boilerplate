# Terraform CTF Challenge - Complete Solution Template

<div align="center">

🎯 **Learn Terraform by Capturing Flags!**

[![Terraform](https://img.shields.io/badge/terraform-1.13.5-purple.svg)](https://www.terraform.io)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D6?logo=windows)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-5391FE?logo=powershell)](https://docs.microsoft.com/powershell/)

[Getting Started](#-quick-start) •
[Installation](#-installation) •
[Challenges](#-challenges) •
[Documentation](#-documentation)

</div>

---

## 📖 About

This repository provides a **complete working solution** for the Terraform CTF Challenge. It's designed to help you learn Terraform through interactive challenges following the **Capture The Flag (CTF)** paradigm.

### 🎮 How CTF Works

1. 📚 **Read the challenge** - Understand what you need to accomplish
2. 💻 **Build your solution** - Write Terraform code to meet requirements  
3. ✅ **Submit proof of work** - Validate your solution with the provider
4. 🏴 **Capture the flag** - If successful, the flag is revealed as your reward!

---

## 🚀 Quick Start

### Prerequisites

- Windows 10/11
- PowerShell 5.1 or later
- Internet connection for downloading required tools

## ⚙️ Installation

### Automated Installation (Recommended)

We provide a PowerShell script to install all necessary tools automatically:

1. Open PowerShell as Administrator
2. Navigate to the project directory
3. Run the installation script:
   ```powershell
   .\Install-CTFTools.ps1
   ```

This will install:
- Terraform CLI (v1.13.5)
- Visual Studio Code (Latest)
- Recommended VS Code Extensions
  - HashiCorp Terraform
  - GitLens

### Manual Installation

#### 1️⃣ Terraform CLI (v1.13.5)

```
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│ HashiCorp Terraform 1.13.5                                                                  │
│─────────────────────────────────────────────────────────────────────────────────────────────│
│ Description: Infrastructure as Code tool                                                    │
│ Type: Executable (ZIP archive)                                                              │
│ Size: ~40 MB                                                                                │
│ Download: https://releases.hashicorp.com/terraform/1.13.5/terraform_1.13.5_windows_amd64.zip│
└─────────────────────────────────────────────────────────────────────────────────────────────┘
```

- **Official Page**: https://developer.hashicorp.com/terraform/
- **Documentation**: https://developer.hashicorp.com/terraform/docs
- **Learn**: https://developer.hashicorp.com/terraform/tutorials

#### 2️⃣ Visual Studio Code

```
┌─────────────────────────────────────────────────────────────────────────┐
│ Visual Studio Code (Latest Stable)                                      │
│─────────────────────────────────────────────────────────────────────────│
│ Description: Microsoft's free code editor                               │
│ Type: Installer (User or System)                                        │
│ Size: ~85 MB                                                            │
│ Download: https://code.visualstudio.com/download                        │
└─────────────────────────────────────────────────────────────────────────┘
```

- **User Installer**: https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user
- **System Installer**: https://code.visualstudio.com/sha/download?build=stable&os=win32-x64
- **Official Page**: https://code.visualstudio.com/
- **Documentation**: https://code.visualstudio.com/docs

#### 3️⃣ VS Code Extensions

##### Terraform Extension
```
┌──────────────────────────────────────────────────────────────────────────────────┐
│ Terraform                                                                        │
│──────────────────────────────────────────────────────────────────────────────────│
│ Description: Syntax highlighting, IntelliSense, and formatting for Terraform     │
│ Type: VS Code Extension                                                          │
│ Size: ~5 MB                                                                      │
│ Download: https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform│
└──────────────────────────────────────────────────────────────────────────────────┘
```

- **Extension ID**: hashicorp.terraform
- **Install via CLI**: `code --install-extension hashicorp.terraform`

##### GitLens Extension
```
┌──────────────────────────────────────────────────────────────────────────────┐
│ GitLens                                                                      │
│──────────────────────────────────────────────────────────────────────────────│
│ Description: Git visualization and code authorship                           │
│ Type: VS Code Extension                                                      │
│ Size: ~5 MB                                                                  │
│ Download: https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens│
└──────────────────────────────────────────────────────────────────────────────┘
```

- **Extension ID**: eamodio.gitlens
- **Install via CLI**: `code --install-extension eamodio.gitlens`

### 📊 Total Download Size: ~130 MB

---

## 🏆 Challenges

This repository includes solutions for all challenges:

| # | Challenge | Difficulty | Points | Status |
|---|-----------|------------|--------|--------|
| 1 | Terraform Basics | 🟢 Beginner | 100 | ✅ Solved |
| 2 | Expression Expert | 🟡 Intermediate | 350 | ✅ Solved |
| 3 | State Secrets | 🟢 Beginner | 200 | ✅ Solved |
| 4 | Module Master | 🔴 Advanced | 400 | ✅ Solved |
| 5 | Dynamic Blocks | 🟡 Intermediate | 300 | ✅ Solved |
| 6 | For-Each Wizard | 🟡 Intermediate | 250 | ✅ Solved |
| 7 | Data Source Detective | 🟢 Beginner | 150 | ✅ Solved |
| 8 | Cryptographic Compute | 🔴 Advanced | 500 | ✅ Solved |

**Total Points: 2,250** 🏅

---

## 🏗️ Project Structure

```
terraform-ctf-boilerplate/
├── solutions/           # Contains challenge solutions
│   ├── challenge-01-terraform-basics.tf
│   ├── challenge-02-expression-expert.tf
│   ├── challenge-03-state-secrets.tf
│   ├── challenge-04-module-master.tf
│   ├── challenge-05-dynamic-blocks.tf
│   ├── challenge-06-foreach-wizard.tf
│   ├── challenge-07-data-source-detective.tf
│   └── challenge-08-cryptographic-compute.tf
├── Install-CTFTools.ps1 # Installation script
└── README.md            # This file
```

---

## 🔒 Security Notes

- ✅ All downloads are from official vendor websites
- ✅ Terraform: HashiCorp official releases
- ✅ VS Code: Microsoft official downloads
- ✅ Extensions: Official VS Code Marketplace

### 💾 Installation Locations
- Terraform: `C:\Users\<username>\.terraform\bin`
- VS Code: 
  - User: `C:\Users\<username>\AppData\Local\Programs\Microsoft VS Code`
  - System: `C:\Program Files\Microsoft VS Code`
- Temp files: `%TEMP%\TerraformSetup`

### 🔧 System Changes
- Adds Terraform to User PATH (no admin required)
- Adds VS Code to PATH (for 'code' command)
- No system files modified (unless you choose system-wide install)

---

## 📚 Documentation

- **Terraform Documentation**: https://www.terraform.io/docs
- **VS Code Documentation**: https://code.visualstudio.com/docs
- **Terraform Provider Documentation**: https://registry.terraform.io/providers/omghozlan/ctfchallenge

---

## 🙏 Acknowledgments

- [HashiCorp Terraform](https://www.terraform.io/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Terraform VS Code Extension](https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform)
- [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)

---

<div align="center">

## 🏴 Happy Hacking!

</div>
