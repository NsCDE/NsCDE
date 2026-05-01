# NsCDE-zh 项目 TODO 评估报告

> 评估日期：2026-05-01
> 扫描范围：全项目代码库（54 个标记）

全项目扫描发现 **54 个标记**，按来源分为三大类：项目自研、上游/第三方、自动生成。

---

## 一、项目级 TODO（`TODO` 文件，3 项）

这是项目维护者定义的核心待办事项：

| # | 描述 | 实现方法 | 难度 |
|---|------|----------|------|
| **T1** | 集成默认文件管理器（偏好 pcmanfm-qt），实现 subpanels 和菜单的交互 | 编写 Shell/KSH 脚本封装 pcmanfm-qt 调用，在 `nscde_tools/` 中新增工具，修改 `NsCDE.conf` 和相关 FvwmScript 添加配置项 | ⭐⭐⭐ 中等 |
| **T2** | 替换 PyQt4/PyQt5 依赖，用 Gtk/Qt 原生 API 重写主题集成 | **最大工程量**。需重写 `lib/python/` 下的 Python 主题引擎（`PaletteManager.py.in` 等），改用 GTK3/Qt 原生 API。涉及 `.py.in` 模板、`configure.ac` 依赖声明、`Makefile.am` 安装规则 | ⭐⭐⭐⭐⭐ 困难 |
| **T3** | 编写 FvwmScript 设置默认终端/编辑器/文件管理器 | 新建 FvwmScript GUI 对话框（参考 `lib/scripts/` 下现有 40 个对话框模式），读写 `$FVWM_USERDIR/NsCDE.conf` | ⭐⭐ 中低 |

---

## 二、源码内 TODO/FIXME/XXX 标记（项目自研代码）

### 🟡 需要关注（6 个）

| 标记 | 文件 | 内容 | 实现方法 | 难度 |
|------|------|------|----------|------|
| **XXX** | `lib/scripts/FontMgr.in:460` | 删除字体集后未自动选中默认项 | 在删除操作后添加逻辑：刷新列表 → `ChangeTitle` 选中第一个可用项 | ⭐⭐ 简单 |
| **XXX** | `nscde_tools/sysinfo.in:76` | `syslastbooted` 功能被注释 | 实现 `last` 或 `who -b` 输出解析，替换 `XXX` 占位符 | ⭐ 简单 |
| **TODO** | `gtk-3.20/widgets-messagedialog.css:793` | Calendar 文本颜色不正确 | 调试 GTK3 CSS 的 `calendar` 选择器，修正 `color` 属性 | ⭐⭐ 简单 |
| **HMM** ×6 | `gtk-3.20/widgets-*.css` | SpinButton 图片在不同 DPI/字体下无法居中对齐 | 已有 workaround（硬编码 `min-width: 19px`），真正修复需动态计算 parity。**CSS 层面几乎无解** | ⭐⭐⭐⭐ 极难 |
| **HMM** | `gtk-2.0/gtkrc:2376` | Toolbar 按钮保持 flat 不响应 style | 调试 GTK2 widget_class 匹配规则，可能需要更精确的选择器 | ⭐⭐⭐ 中等 |
| **XXX** ×4 | `thunderbird/*.css` | 按钮 padding 覆盖 + `about:` URL 作用域限制 | Thunderbird CSS 主题 hack，`margin: -3px` 已是当前最优方案；`about:` 前缀需 Thunderbird 扩展 manifest 配合 | ⭐⭐⭐ 中等 |

### 🟢 低优先级/信息性（4 个）

| 标记 | 文件 | 说明 |
|------|------|------|
| **XXX** | `src/pclock/src/getopt.c:274` | GNU libc 上游 getopt 代码注释，非项目代码，**不应修改** |
| **DEBUG** ×3 | `src/XOverrideFontCursor/XOverrideFontCursor.c` | 标准 `#ifdef DEBUG` 条件编译块，属于正常代码，**无需处理** |
| **NOTE** ×10 | 散布于 `pclock/`、`gtk-3.20/` CSS | 信息性注释，无需行动 |

---

## 三、自动生成文件中的标记（不应直接修改）

| 标记 | 文件 | 说明 |
|------|------|------|
| **FIXME** ×11 | `configure`、`aclocal.m4`、`ac-aux/*` | **全部来自 GNU autotools 上游**。会在 `autoreconf -f -i -v` 时被覆盖。修改无意义 |
| **WORKAROUND** ×7 | 多个 FvwmScript | 不是 TODO 标记，而是运行时环境变量 `NSCDE_REDRAW_WORKAROUND` 的正常引用 |

---

## 四、难度总览

```
极难 ⭐⭐⭐⭐⭐  T2: PyQt→Gtk/Qt 主题引擎重写（影响面最大，涉及 Python + 构建系统）
困难 ⭐⭐⭐⭐    HMM: GTK3 SpinButton DPI parity 问题（CSS 层面几乎无通用解）
中等 ⭐⭐⭐     T1: 文件管理器集成 / HMM: GTK2 toolbar / XXX: Thunderbird CSS
中低 ⭐⭐       T3: FvwmScript 默认应用设置 / XXX: FontMgr 删除后选中 / CSS calendar 颜色
简单 ⭐         XXX: sysinfo lastbooted 实现
无需处理         FIXME(autotools)、DEBUG、NOTE、WORKAROUND
```

---

## 五、建议优先级

1. **先做简单项**：`sysinfo.in` 的 `syslastbooted`、`FontMgr.in` 删除后选中逻辑、calendar CSS 颜色
2. **再做中等项**：T3（FvwmScript 默认应用设置），有大量现有对话框可参考
3. **长期规划**：T1（文件管理器集成）需要设计交互方案
4. **技术债/重构**：T2（PyQt 替换）工程量最大，建议作为独立里程碑
