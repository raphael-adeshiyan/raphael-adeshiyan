# 📖 Setting up Ubuntu Server and CentOS Server on Hyper-V

## 🏷️ Documentation Details
**Name:** Raphael Adeshiyan  
**Professor:** Adrianna Holden-Gouveia  
**Course:** Spring 2025 Linux Administration (CIS-245-O1A) (1322.202501)  
**Assignment:** Getting Your System Setup Part 1  

---

This guide will walk you through setting up **Ubuntu Server** and **CentOS Server** as virtual machines (VMs) on a **Windows machine using Hyper-V**. This setup is useful for learning server administration, testing software, or creating a development environment.

---

## 🖥️ Host System Specifications

- **RAM:** 16GB total (4GB allocated to each server VM, leaving 8GB for the host OS).
- **Host OS:** Windows 11 with **Hyper-V enabled**.
  > *Note:* Hyper-V is a feature that allows your computer to create and manage virtual machines. You can enable it via *"Turn Windows features on or off"* in the Control Panel. If you need help, search online for "enable Hyper-V Windows 11".
- **Storage:** 500GB total disk space (each server VM starts with a 20GB virtual hard disk).
- **Dynamic Disk Sizing:** The virtual hard disks are set to *dynamic*, meaning they start small and expand up to **20GB** as needed. If more space is required, they expand further, provided there is enough space on the host drive.

---

## 🟢 Part 1: Setting Up Ubuntu Server on Hyper-V

### 📥 Download Ubuntu Server
1. Go to the official Ubuntu website: [Ubuntu Server Download](https://ubuntu.com/download/server#system-requirements-lts)
2. Download the **latest LTS (Long-Term Support)** version of Ubuntu Server.
3. Save the ISO file in a location where you can easily find it later.

### ⚙️ Create a New Virtual Machine in Hyper-V
1. Open **Hyper-V Manager** (search for it in the Windows Start Menu).
2. In the *Actions* pane, click **New** → **Virtual Machine...** (launches the wizard).
3. **Before You Begin:** Click **Next**.
4. **Specify Name and Location:**
   - Enter a name like **"Ubuntu Server"**.
   - Choose a custom storage location if needed.
   - Click **Next**.

   ![VM Creation](image-placeholder)

5. **Specify Generation:**
   - Select **Generation 2** (for UEFI firmware, Secure Boot, and better performance).
   - Click **Next**.

6. **Assign Memory:**
   - Enter **4096 MB (4GB)** for startup memory.
   - Keep "Use Dynamic Memory" enabled.
   - Click **Next**.

   ![Memory Allocation](image-placeholder)

7. **Configure Networking:**
   - Select **Default Switch** (simplest option, provides DHCP networking).
   - Click **Next**.

   ![Networking](image-placeholder)

8. **Connect Virtual Hard Disk:**
   - Select **Create a virtual hard disk**.
   - Name it (e.g., `UbuntuServerDisk`).
   - Set size: **20GB**.
   - Choose **Dynamically expanding disk**.
   - Click **Next**.

   ![Disk Setup](image-placeholder)

9. **Installation Options:**
   - Select **Install an operating system from a bootable CD/DVD-ROM**.
   - Choose **Image file (.iso)**.
   - Click **Browse...** and select the downloaded Ubuntu Server ISO.
   - Click **Next**.

   ![ISO Selection](image-placeholder)

10. **Summary:**
    - Review settings, then click **Finish** to create the VM.

### 🏗️ Install Ubuntu Server
1. In **Hyper-V Manager**, right-click your Ubuntu VM → **Connect...**.
2. Click the **Start** button (green play icon) to boot the VM.
3. Follow the **Ubuntu installer** prompts:

   - **Language:** Select and press Enter.
   - **Keyboard:** Choose your layout.
   - **Network:** The Default Switch should provide an automatic IP (via DHCP). Click **Done**.
   - **Proxy:** Leave blank (unless you use a proxy).
   - **Mirror:** Leave as default.
   - **Storage:** Select **Use an entire disk** → **Done**.
   - **Confirm Partitioning:** Click **Continue**.
   - **User Setup:** Enter:
     - Name
     - Server Name (e.g., `myubuntuserver`)
     - Username
     - Password
   - **SSH Setup:** Check **Install OpenSSH Server** (for remote access).
   - **Snaps:** Skip.
   - **Installation:** Wait for it to complete.
   - **Reboot when prompted.**

   ![Ubuntu Install](image-placeholder)

### 🔄 Update and Upgrade
After rebooting, log in and run:
```sh
sudo apt update && sudo apt upgrade
```

---

## 🔵 Part 2: Setting Up CentOS Server on Hyper-V

### 📥 Download CentOS Server
1. Go to: [CentOS Download](https://www.centos.org/download/)
2. Download the **latest CentOS Stream ISO**.
3. Save the ISO file.

### ⚙️ Create a New Virtual Machine in Hyper-V
Follow the same steps as **Ubuntu**, but:
- Name it **"CentOS Server"**.
- Use the **CentOS ISO file**.

### 🏗️ Install CentOS Server
1. Start and **connect** to the CentOS VM.
2. The **Anaconda installer** boots.
3. Follow the **installation prompts**:
   - **Language:** Choose and click **Continue**.
   - **Installation Summary:**
     - **Keyboard, Language Support, Time & Date:** Configure as needed.
     - **Software Selection:** Choose *Server with GUI* (or *Minimal Install* for CLI only).
     - **Storage:** Select the 20GB disk → Choose **Automatic Partitioning**.
     - **Network:** Turn **ON** the default switch (ensures DHCP assigns an IP).
     - **User Setup:**
       - **Root Password:** Set a strong password.
       - **Create a User:** Check "Make administrator" to allow `sudo` access.
4. Click **Begin Installation**.
5. Once completed, **Reboot**.

### 🔄 Update and Upgrade
After rebooting, log in and run:
```sh
sudo dnf update
```

---

## 🎯 Conclusion
You now have two virtual machines running:
- **Ubuntu Server** ✅
- **CentOS Server** ✅

These servers can be accessed via **Hyper-V console** or **SSH** for further configuration. 🚀

