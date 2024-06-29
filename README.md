# Git Key Manager (GKM)
##### Git ssh-keys switch shell command tool
---
### About
For different projects, I have been facing the problem of using different SSH Key.
Some excellent tools such as NVM, GVM, RBENV. So based on my own understanding of the shell command, why can't I write such a tool for myself to manage SSH Key?
**Windows operating systems are currently not supported.**
At present, this function is enough for me. If you have a good idea, we can improve it together. 
Please use your **"Star"** to create our **"Code Galaxy"**.

### How to install
1. Create new folder **".gkm"** under your home.
2. Move the **gkm.sh** file into the **.gkm** folder, which under your home directory.
3. Take the following commands to set the **gkm** command.

```shell
# Use the following command to update the permission.
chmod +x $HOME/.gkm/gkm.sh
```

```shell
# Add this line into your .zshrc or .bashrc file.
alias gkm=$HOME'/.gkm/gkm.sh'
```

### Tips
Please refer the link to [Generating a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key).

***Please distinguish the name of the key, the name should be easy to remember.***
```shell
Enter file in which to save the key (/c/Users/YOU/.ssh/id_ALGORITHM):[Press enter]
```
