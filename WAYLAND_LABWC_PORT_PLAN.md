# NsCDE-zh Wayland + labwc 移植可行性分析与计划

本文档记录对 `NsCDE-zh` 移植到 Wayland + labwc 的可行性分析、技术风险、可复用资产、重写范围和分阶段实施计划。

## 1. 总体结论

`NsCDE-zh` 可以做 Wayland + labwc 方向的移植，但不能进行“平移式移植”。当前项目本质上是一个围绕 FVWM/FVWM3 深度定制的桌面环境，大量功能依赖 FVWM 配置语言、FvwmButtons、FvwmScript、FvwmCommand 以及 X11 工具链。

Wayland 版目标应明确为可安装的完整桌面环境套件。默认组件应兼容非 systemd 系统，同时继续支持 systemd 系统。可以允许用户通过 Xwayland 运行旧 X11 应用，但 `NsCDE-labwc` 自带会话组件不能依赖 Xwayland，也不能把 systemd 作为唯一 init 或 user service manager。

如果目标是在 labwc 上复刻 NsCDE 的 CDE 风格外观、面板、菜单、主题、中文本地化体验，那么技术上可行，并且项目中大量视觉素材和主题逻辑可以复用。

如果目标是让现有 `data/fvwm/*.fvwmconf`、`FvwmScript` 和 `FvwmButtons` 原样跑在 labwc 上，则基本不可行。labwc 不兼容 FVWM 模块生态，Wayland 的安全模型也不允许许多 X11 时代的全局窗口控制和读屏操作。

建议方向是新建一个 `NsCDE-labwc` 或 `NsCDE-Wayland` 分支/子项目，复用 NsCDE-zh 的视觉资产、调色板、图标、本地化和主题算法，重写桌面 shell 层。

## 2. 当前项目架构概览

| 模块 | 路径 | 当前作用 | Wayland/labwc 可复用性 |
|---|---|---|---|
| 启动入口 | `bin/nscde.in` | 设置环境变量、DPI、X resources，然后启动 `fvwm` | 需要重写 |
| FVWM 主配置 | `data/fvwm/` | 窗口管理、菜单、键鼠绑定、前面板、pager、样式 | 基本需要重写 |
| 前面板 | `data/fvwm/FrontPanel.fvwm3.fvwmconf` | 用 `FvwmButtons` 实现 CDE 前面板和子面板 | 需要重写 |
| FVWM 函数 | `data/fvwm/Functions.fvwmconf.in` | 移动、最大化、工作区、铺窗、菜单等操作 | 需要映射到 labwc action 或重写 |
| FvwmScript 对话框 | `lib/scripts/` | 色彩管理器、字体管理器、窗口管理器、系统信息等 GUI | 需要重写为 GTK/Qt/yad |
| 运行工具 | `nscde_tools/` | 主题生成、菜单生成、背景、配置、系统信息等脚本 | 部分可复用，X11 相关要替换 |
| Python 主题引擎 | `lib/python/` | 生成 GTK2/GTK3/Qt 风格主题 | 较高可复用 |
| 视觉素材 | `data/backdrops/`、`data/palettes/`、`data/icons/`、`xdg/icons/` | CDE 风格背景、调色板、图标 | 高度可复用 |
| 本地化 | `po/` | gettext 翻译 | 可复用 |
| X11 C 工具 | `src/colorpicker/`、`src/XOverrideFontCursor/`、`src/pclock/` | 取色、FvwmScript 光标 hack、时钟等 | 多数要替换或仅 Xwayland 可用 |

## 3. 当前强耦合点

简单统计显示当前代码和 X11/FVWM 深度绑定：

| 关键字 | 出现次数 |
|---|---:|
| `Fvwm` | 1644 |
| `fvwm` | 2396 |
| `xrandr` | 96 |
| `xdotool` | 61 |
| `xrdb` | 80 |
| `xset` | 277 |
| `xprop` | 51 |
| `xclip` | 53 |
| `fvwm-root` | 14 |
| `XOpenDisplay` | 43 |

这说明移植重点不是调整少量配置，而是重新实现 Wayland 桌面 shell。

## 4. 为什么不能直接迁移

### 4.1 FVWM 是 NsCDE 的核心运行时

NsCDE 不是普通主题包，它把 FVWM 当作桌面框架使用：

- `FvwmButtons` 实现 CDE 前面板和子面板。
- `FvwmScript` 实现设置窗口和管理器。
- `FvwmPager` / FVWM desk/page 逻辑实现工作区与分页。
- `FvwmCommand` 允许外部脚本远程控制 FVWM。
- `PipeRead` 动态生成菜单、配置和状态。
- `InfoStore` 保存桌面运行状态。
- `Colorset` 驱动 CDE/Motif 视觉风格。

labwc 没有这些机制，也不支持 FVWM 配置语言和模块。

### 4.2 Wayland 安全模型限制 X11 风格工具

| X11 行为 | 当前实现 | Wayland 问题 |
|---|---|---|
| 全局读屏取色 | `src/colorpicker/colorpicker.c` 使用 `XGetImage` | Wayland 不允许普通客户端随意读屏 |
| 控制窗口、改标题 | `xdotool`、`xprop`、`FvwmCommand` | Wayland 原生窗口不能被任意外部进程控制 |
| 屏幕/显示器信息 | `xrandr`、`xdpyinfo` | 需要 `wlr-randr`、`wayland-info`、`kanshi` 等替代 |
| X resources | `xrdb`、`Xdefaults` | 原生 Wayland/GTK4/Qt6 多数不使用 `xrdb` |
| 设置背景 | `fvwm-root` | 需要 `swaybg`、`wbg` 等 Wayland 背景程序 |
| 剪贴板 | `xclip` | 需要 `wl-clipboard` |
| 鼠标键盘模拟 | `xdotool` | 需要 `wtype`、`ydotool`，能力也更受限 |

## 5. labwc 适配性评估

labwc 适合作为 NsCDE Wayland 版的窗口合成器基础，但不能代替 FVWM 的桌面框架能力。

### 优势

- 轻量，符合 NsCDE 的轻量桌面理念。
- Openbox 风格配置，适合传统桌面工作流。
- 支持 Openbox 风格主题，较适合制作复古窗口边框。
- 可搭配外部 panel、menu、notification、wallpaper、launcher。
- 比 GNOME/KDE 更适合构建自定义桌面环境外壳。

### 不足

- 没有 FVWM 模块系统。
- 没有内置 CDE 风格前面板。
- 没有 FVWM 的 `InfoStore`、`PipeRead`、`Colorset`、复杂函数语言。
- workspace/page 模型与 FVWM 不同。
- 远程窗口控制能力比 FVWM 弱很多。

## 6. 可复用资产

### 高度可复用

| 路径 | 内容 |
|---|---|
| `data/backdrops/` | CDE 风格背景 |
| `data/palettes/` | CDE 调色板 |
| `data/icons/` | NsCDE/CDE 风格图标 |
| `xdg/icons/` | XDG 图标主题 |
| `xdg/applications/` | 桌面入口，可调整后继续使用 |
| `po/` | 中文翻译 |
| `lib/python/MotifColors.py.in` | Motif/CDE 调色算法 |
| `lib/python/Theme*.py.in` | GTK 主题生成逻辑，可扩展输出 labwc theme |
| `data/integration/firefox/` | Firefox CDE 风格 CSS |

### 部分可复用

| 路径 | 当前作用 | 移植方式 |
|---|---|---|
| `nscde_tools/themegen.in` | 生成 GTK2/GTK3 主题 | 增加 labwc/Openbox theme 输出、GTK4 输出 |
| `nscde_tools/generate_app_menus.in` | 生成 FVWM 菜单 | 改成生成 labwc `menu.xml` 或 pipe-menu |
| `nscde_tools/bootstrap.in` | 初始化 `~/.NsCDE` | 改成初始化 `~/.config/labwc`、`~/.config/nscde-wayland` |
| `nscde_tools/getdpi.in` | 通过 X11 获取 DPI | 改用 Wayland/环境变量/配置 |
| `nscde_tools/get_logical_screens.in` | 通过 `xrandr` 获取显示器 | 改用 `wlr-randr` 或 `kanshi` |
| `nscde_tools/xrandr_backer.in` | 多显示器背景合成并 `fvwm-root` 设置 | 改用 `swaybg`/`wbg`，或生成每输出背景 |

### 基本必须重写

| 路径 | 原因 |
|---|---|
| `data/fvwm/*.fvwmconf` | labwc 不支持 FVWM 配置语言 |
| `data/fvwm/FrontPanel.fvwm3.fvwmconf` | `FvwmButtons` 不存在于 Wayland/labwc |
| `lib/scripts/*` | `FvwmScript` 依赖 FVWM/X11 |
| `bin/nscde.in` | 当前启动逻辑以 X11/FVWM 为中心 |
| `bin/nscde_fvwmclnt.in` | labwc 没有 `FvwmCommand` |
| `src/XOverrideFontCursor/` | 只针对 X11/FvwmScript |
| `src/colorpicker/` | Xlib 读屏，Wayland 下不可直接使用 |
| `src/pclock/` | X11 风格小程序，建议替换为 panel widget |
| `nscde_tools/xdowrapper.in` | 专门绕 `xdotool` + `FvwmButtons` 子面板问题 |

## 7. 建议替代技术栈

原则：可以保留 Xwayland 让用户运行旧 X11 应用，但 `NsCDE-labwc` 自带会话组件必须原生 Wayland。默认组件应避免 systemd 硬依赖：会话启动和后台组件管理不能只依赖 `systemctl --user`，seat 管理应支持 `seatd`、`elogind` 和 `systemd-logind`。不要把 `rofi`、`tint2`、`polybar`、`stalonetray`、`xclip`、`xdotool`、`xrandr`、`xrdb`、`xset`、`xscreensaver`、`fvwm-root`、`lxappearance` 作为 Wayland 版默认组件。

| 功能 | 当前实现 | Wayland/labwc 替代 |
|---|---|---|
| 窗口管理器 | FVWM3 | `labwc` + `seatd` / `elogind` / `systemd-logind`，可启用 Xwayland 兼容用户应用 |
| 面板/前面板 | FvwmButtons | `sfwbar` + `lavalauncher`，后续自研 layer-shell panel |
| 菜单 | FVWM menu | labwc `menu.xml` / pipe-menu / 自研 XDG menugen |
| 背景 | `fvwm-root` | `swaybg`、`wbg` |
| 显示器配置 | `xrandr` | `wlr-randr`、`kanshi` |
| 剪贴板 | `xclip` | `wl-copy`、`wl-paste` |
| 通知 | `dunst` | `fnott`，避免默认依赖 `mako` 的 systemd-libs 打包 |
| 启动器 | `rofi` / FVWM ExecDialog | `fuzzel` |
| 文件管理器 | 外部 XDG 默认应用 | `PCManFM-Qt`，用 Qt Wayland 后端启动 |
| 终端 | `xterm` | `foot`，备用 `QTerminal` |
| 取色 | Xlib `XGetImage` | `grim` + `slurp` + 取像素，或 `hyprpicker`/`wl-color-picker` |
| 截图 | X11 工具 | `grim`、`slurp` |
| 主题 | FVWM colorsets + GTK theme | labwc/Openbox theme + GTK CSS + Qt theme |
| 托盘 | `stalonetray` XEmbed | `sfwbar` SNI tray |
| GTK/Qt 设置 | `xrdb`、`xsettingsd` | `nwg-look`、`gsettings`、`qt5ct`、`qt6ct`、`Kvantum`，按发行版确认 Qt 包是否拉入 systemd-libs |
| 快捷键 | FVWM keybindings | labwc `rc.xml` |
| 鼠标绑定 | FVWM mousebindings | labwc `rc.xml` |
| 窗口动作 | FVWM functions | labwc actions，复杂逻辑需要外部工具或降级 |

## 8. 推荐目录设计

建议新增独立目录，避免污染现有 FVWM 版本：

- `wayland/`：Wayland/labwc 版主目录。
- `wayland/labwc/`：labwc 配置模板，如 `rc.xml.in`、`menu.xml.in`、`autostart.in`。
- `wayland/panel/`：自研 CDE 前面板实现。
- `wayland/tools/`：Wayland 替代工具脚本。
- `wayland/themes/`：labwc/Openbox/GTK/Qt 主题模板。
- `wayland/session/`：`nscde-labwc.desktop` 和启动脚本。
- `wayland/docs/`：Wayland 版说明文档。

也可以使用 `nscde_wayland/` 作为 Python 包/工具目录。

## 9. 分阶段实施计划

### 阶段 0：技术验证

目标：确认 labwc 环境、依赖和基础能力。

任务：

1. 在测试机或虚拟机安装 labwc。
2. 验证 `seatd`、`elogind` 和 `systemd-logind` 启动 labwc，确保 systemd 是受支持路径但不是唯一依赖。
3. 验证 `swaybg`/`wbg` 设置背景。
4. 验证 `fnott` 通知。
5. 验证 `wl-clipboard`。
6. 验证 `grim` + `slurp` 截图/取色替代方案。
7. 验证 labwc `rc.xml` 的窗口动作、快捷键、鼠标绑定能力。
8. 验证 labwc `menu.xml` 和 pipe-menu 可行性。
9. 验证启动脚本和 `autostart` 不强制调用 `systemctl --user`；如提供 systemd user units，应有非 systemd 启动路径。

交付物：

- 一份最小 labwc 会话配置。
- 一份 Wayland 依赖列表，并标注非 systemd 兼容依赖、systemd 增强依赖和可选依赖。
- 一份功能差异清单。

预计时间：2 到 5 天。

### 阶段 1：NsCDE-labwc Lite 外观原型

目标：在 labwc 会话中快速获得 NsCDE/CDE 风格外观。

任务：

1. 新增 `nscde-labwc` 启动脚本。
2. 新增 Wayland session desktop 文件。
3. 生成 labwc `rc.xml`、`menu.xml`、`autostart`。
4. 复用 NsCDE 图标、背景、调色板。
5. 写 labwc/Openbox theme 生成器。
6. 使用 `swaybg` 或 `wbg` 设置背景。
7. 用 `sfwbar` + `lavalauncher` 临时模拟前面板、任务栏、托盘和固定启动按钮。
8. 用 `fnott` 处理通知。
9. 用 `foot`、`fuzzel`、`PCManFM-Qt`、`wl-clipboard`、`grim`、`slurp` 替换基础工具。

交付物：

- 可登录的 `NsCDE-labwc Lite` 会话。
- CDE 风格窗口装饰。
- CDE 风格菜单。
- CDE 背景和图标主题。
- 基础快捷键和鼠标行为。

预计时间：1 到 3 周。

### 阶段 2：菜单和主题生成器改造

目标：复用现有主题逻辑，生成 labwc/Wayland 所需配置。

任务：

1. 扩展 `themegen`，支持生成 labwc/Openbox 主题。
2. 继续生成 GTK2/GTK3 主题，评估 GTK4 CSS 支持。
3. 生成 Qt5/Qt6 适配配置或主题提示。
4. 将 `generate_app_menus` 改造成 labwc `menu.xml` 生成器。
5. 保留 XDG 分类、图标、本地化逻辑。
6. 增加 Firefox CSS 主题安装/更新逻辑。

交付物：

- `nscde-labwc-themegen`。
- `nscde-labwc-menugen`。
- 可从现有 palette 生成 labwc + GTK + Qt 主题。

预计时间：2 到 4 周。

### 阶段 3：原生 CDE 前面板

目标：替代 `FvwmButtons`，实现真正的 NsCDE 风格前面板。

建议实现一个独立程序，例如 `nscde-panel`。

可选技术：

- GTK3 + `gtk-layer-shell`。
- GTK4 + layer-shell 绑定。
- Qt + layer-shell。
- Rust + GTK/layer-shell。
- C + GTK/layer-shell。

核心功能：

1. 主菜单按钮。
2. 左右启动器。
3. 子面板弹出。
4. 工作区切换器。
5. 时钟。
6. 托盘区域。
7. 小程序区域。
8. 前面板上下位置。
9. CDE 3D 边框和调色板。
10. 配置热重载。

交付物：

- `nscde-panel` 可执行程序。
- 基础子面板功能。
- 工作区切换显示。
- 可读取 NsCDE palette。

预计时间：4 到 8 周。

### 阶段 4：设置管理器重写

目标：替换 `lib/scripts/` 中的 FvwmScript 对话框。

建议用 PyQt5/PyQt6 或 GTK 重写。

优先级建议：

1. `StyleMgr`：设置中心入口。
2. `ColorMgr`：色彩/调色板管理器。
3. `FontMgr`：字体管理器。
4. `BackdropMgr`：背景管理器。
5. `WindowMgr`：labwc 配置管理器。
6. `Sysinfo`：系统信息界面。
7. `DefaultAppsMgr`：默认应用管理器。

交付物：

- `nscde-control-center`。
- 主题、字体、背景、窗口配置可视化编辑。
- 配置写入 `~/.config/nscde-wayland` 和 `~/.config/labwc`。

预计时间：1 到 2 个月。

### 阶段 5：功能等价与体验补齐

目标：接近传统 NsCDE/FVWM 版的日常体验。

任务：

1. 完善 workspace pager。
2. 完善 task switcher。
3. 增加 session shutdown dialog。
4. 完整 XDG 菜单生成。
5. 多显示器背景支持。
6. DPI/字体联动。
7. GTK/Qt/Firefox 主题联动。
8. 中文字体默认配置。
9. Debian/RPM/Arch 打包。
10. 提供完整桌面环境元包。
11. 文档和迁移指南。

交付物：

- `NsCDE-labwc Full` 预览版。
- 基础打包产物。
- 用户文档。

预计时间：2 到 4 个月以上。

## 10. 风险与应对

| 风险 | 影响 | 应对 |
|---|---|---|
| FvwmButtons 无等价替代 | 前面板体验缺失 | 自研 layer-shell panel，先用 waybar/nwg-panel 过渡 |
| FvwmScript 重写工作量大 | 设置管理器迁移慢 | 先保留 CLI/配置文件，逐步重写高优先级 UI |
| Wayland 禁止全局读屏和窗口控制 | 取色、窗口脚本等功能受限 | 使用 portal、grim/slurp、compositor 协议或功能降级 |
| labwc action 不如 FVWM 丰富 | 某些窗口行为无法等价 | 只保留常用行为，复杂逻辑放进辅助 daemon/panel |
| workspace/page 模型不同 | CDE workspace manager 难以完全复刻 | 初版只支持 workspace，后续模拟 page 或放弃 page |
| 主题一致性难 | GTK/Qt/Xwayland/Firefox 风格不统一 | 分层生成主题，明确支持矩阵 |
| 发行版包引入 systemd-libs | 非 systemd 发行版兼容性下降 | 默认依赖避免 systemd-only 组件；Qt、idle、通知组件按发行版做条件依赖 |
| 多显示器行为复杂 | 背景、面板位置、DPI 处理复杂 | 先单显示器稳定，再引入 `wlr-randr`/`kanshi` 支持 |

## 11. 建议的首批文件

第一阶段可以新增以下文件：

- `wayland/README.md`
- `wayland/session/nscde-labwc.desktop.in`
- `wayland/bin/nscde-labwc.in`
- `wayland/labwc/rc.xml.in`
- `wayland/labwc/menu.xml.in`
- `wayland/labwc/autostart.in`
- `wayland/tools/nscde-labwc-themegen.in`
- `wayland/tools/nscde-labwc-menugen.in`
- `wayland/themes/labwc/themerc.in`
- `wayland/packaging/nscde-wayland-desktop.md`

## 12. 完整桌面环境打包方案

Wayland 版建议拆成独立包，不要并入现有 `nscde-zh` FVWM/X11 主包：

| 包名 | 作用 | 内容 |
|---|---|---|
| `nscde-zh` | 现有 FVWM/X11 版 | 保持不动 |
| `nscde-wayland-session` | Wayland 会话核心 | `nscde-labwc` 启动脚本、`nscde-labwc.desktop`、labwc 配置模板 |
| `nscde-wayland-themes` | 主题资源 | labwc/Openbox theme、GTK CSS、Qt/Kvantum、sfwbar、fuzzel、foot、fnott 配色 |
| `nscde-wayland-tools` | 生成器和辅助工具 | menu/theme/autostart 生成器、迁移脚本 |
| `nscde-wayland-desktop` | 完整桌面环境元包 | 拉起默认组件依赖，不放代码或只放说明 |

打包规则：

- `nscde-wayland-desktop` 默认依赖必须可在非 systemd 系统上满足，同时支持 systemd 发行版。
- 使用 `seatd | elogind | systemd-logind` 表达 seat 管理能力，不要求其中某一个作为唯一实现。
- 可以提供 systemd user units 作为增强集成，但不能只依赖它们；默认会话组件必须也能由 `nscde-labwc` 和 labwc `autostart` 启动。
- `mako`、`swayidle`、Waybar 等可能带 systemd 依赖的组件只能作为可选依赖。
- 发行版若将 Qt 基础库打包为依赖 `systemd-libs`，Qt 相关组件需要单独标注为“按发行版验证”。

## 13. 推荐依赖

基础依赖：

- `labwc`
- `seatd`、`elogind` 或 `systemd-logind`
- `wayland-utils`
- `wlr-randr`
- `kanshi`（可选）
- `swaybg` 或 `wbg`
- `sfwbar`
- `lavalauncher`
- `fuzzel`
- `PCManFM-Qt`
- `foot`
- `fnott`
- `wl-clipboard`
- `grim`
- `slurp`
- `swaylock`
- `nwg-look`
- `qt5ct` / `qt6ct`
- `Kvantum`
- `python3`
- `python3-yaml`
- `python3-pyxdg`
- `python3-psutil`
- `python3-pyqt5` 或 GTK 绑定

可选依赖：

- `swayidle`：仅在发行版提供无 systemd 构建，或接受 logind/elogind 功能差异时启用。
- `mako`：仅在发行版不强制拉入 systemd-libs 时作为通知替代。
- `Waybar`：仅作为现代状态栏替代，不作为默认 CDE 风格 panel。
- systemd user units：仅作为 systemd 发行版的集成增强，不作为唯一启动机制。

如果开发原生 panel，还需要按选型补充：

- GTK3/GTK4 开发包。
- `gtk-layer-shell` 或对应语言绑定。
- StatusNotifierItem 支持库。

## 14. 推荐产品定位

不建议宣传为“NsCDE 原样 Wayland 移植”。更合适的定位是：

- `NsCDE-Wayland`
- `NsCDE-labwc`
- `NsCDE-zh Wayland Edition`

定位描述：

基于 labwc 的 CDE 风格 Wayland 桌面环境，复用 NsCDE 的中文本地化、图标、调色板、背景和主题理念，但重新实现 panel、菜单、设置管理器和 Wayland 集成。

## 15. 最小可行版本定义

`NsCDE-labwc Lite` 最小可行版本应包含：

1. 可从显示管理器登录。
2. labwc 使用 CDE 风格窗口装饰。
3. 默认背景和图标主题可用。
4. 有应用菜单。
5. 有底部前面板或临时代用 panel。
6. 基础快捷键可用。
7. 中文字体显示正常。
8. 可设置主题、字体和背景，至少通过命令行或配置文件实现。
9. 项目自带组件原生 Wayland 运行；允许用户应用通过 Xwayland 兼容运行。
10. 默认会话组件可在 `seatd`、`elogind` 或 `systemd-logind` 环境中运行；systemd 受支持但不是硬依赖。
11. 提供 `nscde-wayland-desktop` 元包或等价安装目标。

不要求首版实现：

- 完整 FvwmScript 设置窗口。
- 完整 FVWM page/desk 行为。
- 所有 CDE 子面板功能。
- 所有复杂窗口操作函数。
- 完整多显示器体验。
- suspend/resume 前后 idle hook 的完整 logind 集成。

## 16. 最终建议

建议先做 `NsCDE-labwc Lite`，重点复用视觉资产和主题生成逻辑，以 `labwc` + `seatd/elogind/systemd-logind` + `sfwbar` + `lavalauncher` + `fuzzel` + `fnott` 快速落地外观和基础工作流。等基础体验稳定后，再投入自研 `nscde-panel` 和设置中心。

这条路线可以最大程度降低风险：

- 保留 NsCDE-zh 最有价值的 CDE 风格资产和中文本地化。
- 避免被 FVWM 兼容性拖住。
- 让 Wayland 版本从第一阶段就能启动和体验。
- 保证 NsCDE 自带组件走原生 Wayland，同时不阻止用户运行 Xwayland 应用。
- 保证默认组件可运行在非 systemd 系统上，同时为 systemd 系统保留增强集成；不要求 `systemctl --user` 作为唯一启动机制。
- 后续可以逐步补齐功能，而不是一开始追求完全等价。

验收时可用 `xlsclients` 检查默认会话组件，不应出现 `sfwbar`、`lavalauncher`、`fuzzel`、`PCManFM-Qt`、`foot`、`fnott`、`swaybg` 等项目自带组件。另需分别验证非 systemd 的 `seatd`/`elogind` 启动路径和 systemd-logind 启动路径，并检查项目脚本不把 `systemctl --user` 作为唯一启动方式。
