# GKM - Git 密钥管理器

`GKM` (Git 密钥管理器) 是一款基于 shell 的简单 SSH 密钥管理工具。它允许用户通过命令行操作方便地列出、切换、生成和删除 SSH 密钥。

[English](./README.md)

## 功能

- **列出 SSH 密钥**：列出 `~/.ssh` 文件夹中的所有 SSH 密钥以及关联的电子邮件和用户名。
- **切换 SSH 密钥**：根据索引或用户名轻松切换不同的 SSH 密钥。
- **生成新 SSH 密钥**：通过提供用户名和电子邮件生成新 SSH 密钥。
- **删除 SSH 密钥**：根据列表中的索引删除现有 SSH 密钥。
- **卸载 GKM**：从系统中完全删除 GKM 脚本和所有 SSH 密钥。

## 安装

您可以使用以下命令直接从 GitHub 安装 `gkm`：

```bash
curl -sSL https://raw.githubusercontent.com/Velunce/gkm/main/install.sh | bash
```

此命令将：

1. 下载并将 `gkm.sh` 安装到 `~/.gkm/`。
2. 将别名 `gkm` 添加到您的 shell 配置（支持 bash、zsh 等）。
3. 使 `gkm` 命令立即可用。

## 用法

安装 `gkm` 后，您可以使用以下命令：

### 1. 列出 SSH 密钥

要列出所有 SSH 密钥及其关联的用户名和电子邮件：

```bash
gkm list
```

### 2. 切换 SSH 密钥

您可以通过指定索引号或用户名来切换活动 SSH 密钥：

```bash
gkm use 1
```

或按用户名切换：

```bash
gkm use <username>
```

### 3. 生成新的 SSH 密钥

要生成新的 SSH 密钥，系统将提示您输入用户名和电子邮件。然后，系统会要求您选择密钥类型（`rsa`、`ed25519` 等）：

```bash
gkm new
```

### 4. 删除 SSH 密钥

根据列表中的索引删除 SSH 密钥：

```bash
gkm remove 2
```

### 5. 卸载 GKM

卸载 `gkm` 并从系统中删除所有已安装的 SSH 密钥：

```bash
gkm uninstall
```

## 支持的 Shell

`gkm` 适用于：

- `bash`
- `zsh`
- 其他符合 POSIX 标准的 Shell

它支持 Linux 和 macOS 平台。

## 贡献

请随意分叉存储库并提交拉取请求以进行改进或添加功能。

1. 分叉项目。

2. 创建您的功能分支（`git checkout -b feature/new-feature`）。
3. 提交更改（`git commit -m 'Add some feature'`）。
4. 推送到分支（`git push origin feature/new-feature`）。
5. 打开拉取请求。

## 许可证

此项目根据 MIT 许可证获得许可 - 有关详细信息，请参阅 [LICENSE](./LICENSE.md) 文件。
