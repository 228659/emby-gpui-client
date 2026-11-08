# 📦 Emby GPUI Client - 完整测试与打包指南

本文档详细说明如何测试和打包你的 Emby GPUI 客户端项目。

---

## 🧪 一、测试验证流程

### 1.1 快速功能测试 (Quick Test)

```bash
# 1. 启动应用进行手动测试
cargo run --release

# 预期界面:
# ✅ Dark themed window with Mica material
# ✅ Sidebar navigation (Emby title + menu items)
# ✅ Main content area with Hero Banner
# ✅ Library rows for browsing media

# 2. 执行 API 集成测试
export EMBY_URL="http://your-emby-server:8096"
cargo test --test test_api_integration -- --nocapture

# 预期输出:
# ✅ Device PIN obtained!
# ✅ Login successful!
# ✅ Libraries found: 5
# ✅ Items loaded: 100+
```

### 1.2 单元测试套件

```bash
# 运行所有单元测试
cargo test --lib

# 查看覆盖率 (需安装 cargo-tarpaulin)
cargo tarpaulin --out Html && open target/cargo_tarpaulin/report.html

# 检查特定模块测试
cargo test state::cache_engine
cargo test api::emby_client  
cargo test features::multi_server

# 预期结果：ok. 25 passed; 0 failed
```

### 1.3 性能基准测试

```bash
# Home page load performance (< 1 second for 1000 items)
cargo test test_homepage_load_performance

# UI render FPS check (> 60fps)
cargo test test_ui_render_performance

# Expected output:
# ✅ 1000 items loaded in 856ms
# ✅ UI renders at 62.5 FPS
```

### 1.4 手动测试检查清单

在 GUI 中按以下步骤验证:

#### **首页导航**
- [ ] 应用启动 - 窗口显示深色主题/Mica 材质
- [ ] 点击侧边栏菜单项 - 平滑切换无卡顿
- [ ] 横向滚动库列表 - 连续性滚动效果
- [ ] Hover 媒体卡片 - 显示阴影/高亮效果
- [ ] Click 卡片 - 跳转详情页正确

#### **播放控制**
- [ ] 选择视频 → 点击 Play
- [ ] mpv 播放器出现且比例正确 (16:9)
- [ ] 进度条实时更新流畅
- [ ] Seek 前后跳转正常工作
- [ ] Volume 调节响应迅速
- [ ] F 键全屏切换正常
- [ ] Esc 退出全屏正常

#### **设置面板**
- [ ] 打开设置图标
- [ ] 修改 Accent Color - 实时应用到所有组件
- [ ] Mica/Acrylic开关生效
- [ ] Subtitle size 滑动条调整字体大小
- [ ] 保存后重启应用设置仍保留

---

## 📦 二、打包发布流程

### 2.1 本地构建脚本

**Windows PowerShell (`build.ps1`):**

```powershell
#!/usr/bin/env pwsh
$VERSION = "0.1.0"

Write-Host "🚀 Building Emby GPUI Client v$VERSION..." -ForegroundColor Cyan

# Clean old builds
cargo clean

# Build release binary
cargo build --release --target x86_64-pc-windows-msvc

# Create distribution folder
New-Item -ItemType Directory -Force -Path "dist" | Out-Null
Copy-Item "target\x86_64-pc-windows-msvc\release\emby-gpui.exe" "dist\"

# Add metadata
@{
    Version = $VERSION
    BuildDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    GitCommit = & git rev-parse --short HEAD
    Architecture = "x64"
} | Export-Clixml "dist\build-info.xml"

# Compress into zip
Compress-Archive -Path "dist\*" -DestinationPath "emby-gpui-v$VERSION-setup.zip" -Force

Write-Host "✅ Build complete!" -ForegroundColor Green
Write-Host "📦 Output: emby-gpui-v$VERSION-setup.zip" -ForegroundColor Yellow
```

**Linux/macOS Bash (`build.sh`):**

```bash
#!/bin/bash
set -e

echo "🚀 Building Emby GPUI Client..."
echo ""

VERSION=$(git describe --tags --always 2>/dev/null || echo "dev")

# Clean
cargo clean

# Build release
cargo build --release

# Copy artifacts
mkdir -p dist
cp target/release/emby-gpui dist/

# Create info file
cat > dist/INFO.txt << EOF
Version: $VERSION
Build Date: $(date -u +"%Y-%m-%d %H:%M UTC")
Architecture: $(uname -m)

Usage: ./emby-gpui
Ensure libmpv.so is available or bundled separately
EOF

# Compress
tar czf "emby-gpui-${VERSION}.tar.gz" dist/

echo "✅ Build complete: emby-gpui-${VERSION}.tar.gz"
du -h "emby-gpui-${VERSION}.tar.gz"
```

### 2.2 Windows 安装程序 (Inno Setup)

**Setup.iss 文件:**

```ini
[Setup]
AppName=Emby GPUI Client
AppVersion=0.1.0
DefaultDirName={autopf}\Emby GPUI
DefaultGroupName=Emby GPUI Client
OutputDir=.
OutputBaseFilename=emby-gpui-0.1.0-Setup

Compression=lzma2
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "dist\emby-gpui.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "dist\*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "README.txt"; DestDir: "{app}"; Flags: readmeonly

[Icons]
Name: "{group}\Emby GPUI Client"; Filename: "{app}\emby-gpui.exe"
Name: "{autodesktop}\Emby GPUI Client"; Filename: "{app}\emby-gpui.exe"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
```

**编译步骤:**
1. 下载并安装 Inno Setup (https://jrsoftware.org/isdl.php)
2. 放置 `Setup.iss` 在项目根目录
3. 双击运行或在命令行执行:
   ```bash
   C:\Program Files\(x86)\Inno Setup 6\ISCC.exe Setup.iss
   ```
4. 产出: `emby-gpui-0.1.0-Setup.exe` (~15MB)

### 2.3 Linux DEB 包创建

**debian-packaging/rules:**

```bash
#!/usr/bin/make -f

override_dh_auto_build:
	cargo build --release

override_dh_auto_install:
	mkdir -p $(CURDIR)/debian/emby-gpui/usr/bin
	install -m 755 target/release/emby-gpui $(CURDIR)/debian/emby-gpui/usr/bin/
	
	dh install
```

**debian/changelog:**

```text
emby-gpui-client (0.1.0) unstable; urgency=medium

  * Initial release of GPU-accelerated Emby client in Rust
  
 -- Your Name <you@email.com>  Thu, 07 Nov 2024 12:00:00 +0000
```

**打包命令:**
```bash
dpkg-buildpackage -us -uc
dpkg-scanpackages . /dev/null | gzip -9 > Packages
```

---

## 🔄 三、CI/CD自动化配置

### GitHub Actions Workflow (`.github/workflows/ci.yml`)

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  release:
    types: [published]

jobs:
  # Unit Tests
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Rust
        uses: dtolnay/rust-toolchain@stable
        
      - name: Run Clippy
        run: cargo clippy --all-targets --all-features -- -D warnings
        
      - name: Run Tests
        run: cargo test --lib
        
      - name: Upload Coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
          
  # Build Release
  build:
    needs: [test]
    runs-on: windows-latest
    if: startsWith(github.ref, 'refs/tags/v')
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Rust
        uses: dtolnay/rust-toolchain@stable
        with:
          target: x86_64-pc-windows-msvc
          
      - name: Build
        run: cargo build --release --target x86_64-pc-windows-msvc
        
      - name: Create Package
        run: .\build.ps1
        
      - name: Sign Binary
        uses: azure/trusted-signing-action@v1
        with:
          azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
          azure-client-secret: ${{ secrets.AZURE_CLIENT_SECRET }}
          trusted-signing-account-url: ${{ secrets.SIGNING_URL }}
          certificate-profile-name: ${{ secrets.CERT_PROFILE_NAME }}
          
      - name: Create Installer
        uses: minit/setup-innosetup@v1
        run: |
          ISCC Setup.iss
          
      - name: Upload Artifacts
        uses: actions/upload-artifact@v4
        with:
          name: installer
          path: emby-gpui-*-Setup.exe
          
      - name: Deploy to Releases
        if: github.event_name == 'release'
        uses: softprops/action-gh-release@v1
        with:
          files: |
            emby-gpui-*-Setup.exe
            CHANGELOG.md
```

---

## 🎨 四、后续 UI 定制说明

### 主题颜色调整

**位置:** `src/ui/utils/theme.rs`

```rust
// 修改 accent color
pub THEME_CONFIG = AppTheme {
    accent_color: Color::from_rgba_u8(0xE5, 0xA0, 0x0D, 0xFF), // 金色
    // 改成喜欢的颜色:
    // primary: Color::from_rgb_u32(0x0078D4), // Microsoft Blue
    // surface: Color::from_rgb_u32(0x1A1A2E), // Dark Navy
};
```

### 布局尺寸修改

**位置:** `src/views/home_view.rs`

```rust
pub struct HomeView {
    pub content_width: f32,     // px(1280.0) -> px(1920.0)
    pub card_size: Size,        // px(200)x(px(300)) -> px(250)x(px(375))
}
```

### 添加新页面路由

**位置:** `src/main.rs` + `src/ui/mod.rs`

```rust
// 新增 view
pub struct NewFeatureView {
    data: Vec<FeatureData>,
}

impl Render for NewFeatureView { ... }

// 在主窗口注册
fn render_page(view: Route) -> impl Element {
    match view {
        Route::Home => view!(HomeView),
        Route::NewFeature => view!(NewFeatureView), // ← 新增!
    }
}
```

---

## 📝 五、故障排查

| 问题 | 解决方案 |
|------|---------|
| `cargo build` 失败 | 确保安装了 Rust 1.80+, MSVC 工具链 |
| mpv 找不到 | 在 `mpv.exe` 目录运行或添加到 PATH |
| 界面不显示 | 检查是否有 DWM/合成器支持 |
| 音频无声 | 确认音频直通设置或更换音频设备 |
| 登录失败 | 检查 Emby 服务器 URL 和端口正确性 |

---

## ✅ 验收清单

部署前请确认:

- [ ] 所有单元测试通过 (25+)
- [ ] 性能基准达标 (加载<1 秒，FPS>60)
- [ ] API 连接测试成功
- [ ] 安装包可以正常安装/卸载
- [ ] 代码已签名 (发行版必须)
- [ ] README/CHANGELOG已更新
- [ ] GitHub Rele ase 上传了 artifact

---

**祝你开发顺利！有任何问题随时咨询!** 🚀
