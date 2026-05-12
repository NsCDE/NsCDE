# NsCDE-zh 打包脚本审计与改进计划 (Packaging Audit & Improvement Plan)

本计划旨在修复和优化 `pkg/` 目录下各发行版的构建脚本，确保跨平台的一致性和构建的健壮性。

## 1. 发现的问题总结

### 1.1 Debian (`pkg/debian/`)
- **依赖精度**：`ksh` 依赖应明确指向 `ksh93`，以避免在某些系统上调用兼容性较差的旧版 ksh。
- **缺失工具**：建议显式列出 `x11-xserver-utils` 之外的子工具（如 `xmodmap`, `xrefresh`）。

### 1.2 Arch Linux (`pkg/pacman/PKGBUILD`)
- **源码解压路径硬编码**：`cd "NsCDE-zh-${pkgver}_zh"` 在上游标签命名微调时会失效。
- **架构支持限制**：目前仅标注 `x86_64`，建议增加 `aarch64`。

### 1.3 RPM (`pkg/rpm/NsCDE.spec`)
- **路径歧义**：未显式定义 `libexecdir`，导致不同发行版间工具路径不统一。
- **文件列表过宽**：`%{_bindir}/*` 存在打包构建环境无关文件的风险。
- **依赖冗余**：Noto 字体依赖项中普通版与可变字体（VF）版重复。

## 2. 拟实施的改进步骤

### 步骤 1: 优化 Debian 配置
- 修改 `pkg/debian/control`，将依赖锁定为 `ksh`（Debian 规范中代表 ksh93）。
- 确保 GitHub Workflow 安装正确的编译依赖。

### 步骤 2: 增强 Arch 构建脚本健壮性
- 将 `PKGBUILD` 中的 `cd` 指令改为动态路径匹配。
- 将 `arch` 扩展为 `('x86_64' 'aarch64')`。

### 步骤 3: 精细化 RPM Spec 文件
- 在 `%configure` 中增加 `--libexecdir=%{_libexecdir}/NsCDE` 参数。
- 精确化 `%files` 列表，显式列出主程序文件。
- 合并并精简 `google-noto-sans-cjk-fonts` 及其相关依赖。

### 步骤 4: 增加 FreeBSD Port 支持
- 在 `pkg/freebsd/` 下创建符合 BSD 规范的 `Makefile`。
- 配置 `USES=python` 和 `USE_GITHUB` 以利用 FreeBSD 自动化构建框架。
- 显式锁定 `textproc/gsed` 和 `shells/ksh93` 依赖。

## 3. 验证方案
- **Linux 平台**: 在干净的容器环境（pbuilder/mock/devtools）中分别触发各平台的构建流程。
- **FreeBSD 平台**: 在真机或虚拟机中使用 `make install` 验证，检查生成的 `pkg-plist` 完整性。
- **全局检查**: 检查生成的包内文件权限（特别是 `XOverrideFontCursor.so` 具备可执行权限），并验证 `/usr/lib/NsCDE` 路径在各平台是否统一。

---

## 4. 实施状态 (Implementation Status)

截至 2026年4月23日，以下改进已在分支 `fix/packaging-improvements` 中完成实施并验证：

| 平台 | 状态 | 关键变更 |
| :--- | :--- | :--- |
| **Debian/Ubuntu** | ✅ 已验证 | 修复了 `ksh` 包名兼容性问题，CI 构建成功。 |
| **Arch Linux** | ✅ 已验证 | 源码路径适配动态匹配，增加了 `aarch64` 支持。 |
| **RPM (Fedora)** | ✅ 已验证 | 统一了 `libexecdir` 路径，精简了 Noto 字体依赖。 |
| **FreeBSD** | 🕒 待真机验证 | 已提交 Port 配置文件，符合 BSD 标准。 |

---
**生成日期**：2026年4月23日
**执行者**：Gemini CLI
