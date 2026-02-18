# Indigo Lb - Subproject Workflow

**Domain:** www.indigo-lb.com  
**Contact:** info@indigo-lb.com  
**Status:** ✅ COMPLETED (Feb 12, 2026)  
**Workspace:** `c:\Users\Alaa\Documents\githup\Selenium\indigo-lb\`

---

## Project Context

This is **subproject #5** of an 11-website migration project. Each domain gets its own isolated folder within the Selenium workspace.

**Reference Project:** `../limen groupe/` (Completed Feb 1, 2026)  
**Parent Guide:** `../PROJECT_WORKFLOW_GUIDE.md`

---

## Workflow Stages (From Parent Guide)

Follow the 11-stage workflow documented in PROJECT_WORKFLOW_GUIDE.md:

1. ⏳ Project Initialization
2. ⏳ Source Code Import
3. ⏳ Initial Local Testing
4. ⏳ Asset Localization - Images
5. ⏳ Asset Localization - CSS/JS
6. ⏳ Path Replacement
7. ⏳ JavaScript Localization
8. ⏳ Special Fixes
9. ⏳ Backend Implementation (Create contact_handler.php for email)
10. ⏳ Final Testing (Cross-browser, forms, responsive)
11. ⏳ Deployment Package (Create .htaccess, ZIP for Namecheap)

**Update this README as you complete each stage.**

---

## Critical Fixes Applied

### ✅ Project Status: COMPLETED (Feb 12, 2026)

All 8 pages working correctly with proper fonts, sizing, and layout matching live site.

### 🔥 FIX #1: Viewport Meta Tag (CRITICAL)

**Problem:** All pages except index.html showed oversized text, large icons, and wrong layout.

**Root Cause:** Viewport was incorrectly set to fixed width during "fix mobile view" attempt:
```html
<!-- WRONG (caused all sizing issues): -->
<meta name="viewport" content="width=1280, initial-scale=1.0"/>

<!-- CORRECT (matches live site): -->
<meta name="viewport" content="width=device-width, maximum-scale=1"/>
```

**Solution:** Restored correct viewport meta tag in 7 HTML files:
- about-indigo.html
- contact-us.html
- animation.html
- commercials.html
- branding.html
- digital-marketing.html
- web-services.html

**Impact:** Fixed responsive design calculations, text sizes now match live site perfectly.

---

### 🔥 FIX #2: Font URL Configuration

**Problem:** Fonts not loading correctly, causing rendering issues.

**Root Cause:** Font URLs pointing to local assets/ folder instead of Google CDN like live site.

**Solution:** Changed all font @font-face declarations to use Google CDN:
```css
/* BEFORE (local): */
src: url('assets/fonts/helveticaneuethn-webfont.eot');

/* AFTER (matches live site): */
src: url('https://storage.googleapis.com/xprs_resources/fonts/helveticaneuethn-webfont.eot');
```

**Files Updated:** All 8 HTML files (index, about-indigo, contact-us, animation, commercials, branding, digital-marketing, web-services)

---

### 🔥 FIX #3: fonts.css Missing Definitions

**Problem:** Many fonts undefined (freight-sans-pro, Montserrat, etc.) causing fallback to system fonts.

**Root Cause:** Local `assets/css/fonts.css` was empty placeholder.

**Solution:** Downloaded real fonts.css from Indigo CMS server:
```powershell
Invoke-WebRequest -Uri "https://www.indigo-cy.com/css/fonts.css?v=1.6.0f2-noimos" -OutFile "assets/css/fonts.css"
```

**Contents:** 
- freight-sans-pro → maps to Arial
- Montserrat, Roboto, Open Sans (Google Fonts)
- 50+ additional web fonts via @import

---

### 🔥 FIX #4: Contact Page Static CSS Empty

**Problem:** Contact page showing huge text and thick form borders, completely different from live site.

**Root Cause:** `assets/css/static_style_contact.css` was only 42 bytes (empty).

**Solution:** Downloaded page-specific CSS from Indigo CMS server:
```powershell
Invoke-WebRequest -Uri "https://www.indigo-cy.com/static_style?v=1.6.0f2-noimos&vbid=vbid-9f4faca0-lok1anrm&caller=live" -OutFile "assets/css/static_style_contact.css"
```

**Result:** 28KB of proper styling with font-size calculations using calc() and rem units.

---

### 📋 All Static CSS Files Verified

| File | Size | Status |
|------|------|--------|
| static_style_index.css | 60KB | ✅ Working |
| static_style_about.css | 53KB | ✅ Working |
| static_style_contact.css | 28KB | ✅ Fixed (was 42 bytes) |
| static_style_animation.css | 37KB | ✅ Working |
| static_style_commercials.css | 30KB | ✅ Working |
| static_style_branding.css | 36KB | ✅ Working |
| static_style_digital.css | 49KB | ✅ Working |
| static_style_webservices.css | 36KB | ✅ Working |

---

### 🔥 FIX #5: Email Backend & Apache Configuration

**Files Created:**
- `contact.php` - PHP email handler for contact form
- `.htaccess` - Apache server configuration for Namecheap

#### 📧 contact.php - Email Handler

**Location:** Root directory (same level as index.html)

**Features:**
- Processes contact form submissions (POST requests only)
- Validates name, email, and message fields
- Sanitizes all input to prevent XSS attacks
- Sends email with form data
- Returns JSON response for AJAX handling
- Includes IP address and timestamp for security

**⚠️ REQUIRED CONFIGURATION:**

Open `contact.php` and update line 44 with your email address:

```php
$to = 'info@indigo-lb.com'; // ← CHANGE THIS TO YOUR EMAIL
```

**How It Works:**
1. Contact form submits to `contact.php` via POST
2. Script validates and sanitizes all fields
3. Email sent using PHP's `mail()` function
4. Returns JSON: `{"success": true, "message": "..."}`
5. Frontend JavaScript displays success/error message

**Testing:** After deploying to Namecheap, test the contact form to ensure emails are received.

#### 🔧 .htaccess - Apache Configuration

**Location:** Root directory (same level as index.html)

**Features Configured:**

1. **Force HTTPS (SSL):**
   ```apache
   RewriteCond %{HTTPS} off
   RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
   ```
   - Redirects all HTTP traffic to HTTPS
   - Namecheap provides free SSL certificate

2. **Clean URLs (Remove .html extension):**
   ```apache
   # /about-indigo instead of /about-indigo.html
   RewriteCond %{REQUEST_FILENAME}.html -f
   RewriteRule ^(.*)$ $1.html [L]
   ```

3. **Security Headers:**
   - X-Frame-Options: Prevents clickjacking
   - X-XSS-Protection: Blocks XSS attacks
   - X-Content-Type-Options: Prevents MIME sniffing
   - Referrer-Policy: Controls referrer information

4. **Performance Optimization:**
   - Gzip compression for HTML, CSS, JS, fonts
   - Browser caching (1 year for images, 1 month for CSS/JS)
   - Reduces page load time significantly

5. **Security:**
   - Protects dotfiles (.git, .env, etc.)
   - Prevents directory browsing
   - Hides server information

**⚠️ CONFIGURATION CHOICE:**

Lines 17-25 in `.htaccess` - Choose www or non-www:

```apache
# Force www:
# RewriteCond %{HTTP_HOST} !^www\. [NC]
# RewriteRule ^(.*)$ https://www.%{HTTP_HOST}/$1 [R=301,L]

# Force non-www (CURRENTLY ACTIVE):
RewriteCond %{HTTP_HOST} ^www\.(.+)$ [NC]
RewriteRule ^(.*)$ https://%1/$1 [R=301,L]
```

**Default:** Configured for `indigo-lb.com` (non-www). Change if client prefers `www.indigo-lb.com`.

---

### 🔥 FIX #6: HTTPS/Mixed Content Security Fix

**Issue:** Insecure HTTP external links cause mixed content warnings on HTTPS deployment.

**Problem Identified (From Limen Groupe Reference):**
When deploying to HTTPS servers, HTTP URLs (instead of HTTPS) cause:
- Browser "Not Secure" warnings despite valid SSL
- Mixed content blocking by browsers
- Potential security vulnerabilities
- SEO penalties from search engines

**Symptoms:**
- Browser console shows mixed content warnings
- External resources may fail to load
- Social media links using HTTP instead of HTTPS

**Files Fixed:**
- `index.html` - Fixed 1 HTTP URL (indigo-cy.com link)
- `about-indigo.html` - Fixed 1 HTTP URL (indigo-cy.com link)
- `digital-marketing.html` - Fixed 26 HTTP URLs (social media links)

**URLs Converted to HTTPS:**
```
http://www.indigo-cy.com       → https://www.indigo-cy.com
http://www.linkedin.com         → https://www.linkedin.com
http://www.youtube.com          → https://www.youtube.com
http://www.facebook.com         → https://www.facebook.com
http://www.instagram.com        → https://www.instagram.com
```

**Total Fixed:** 28 HTTP URLs → HTTPS

**Solution Applied:**
```powershell
# Replace all HTTP external URLs with HTTPS
$content = Get-Content "file.html" -Raw -Encoding UTF8
$content = $content -creplace 'href="http://www.', 'href="https://www.'
$content = $content -creplace 'src="http://', 'src="https://'
$content | Set-Content "file.html" -Encoding UTF8 -NoNewline
```

**Verification:**
```powershell
# Check for remaining HTTP URLs
$content = Get-Content "file.html" -Raw
[regex]::Matches($content, 'href="http://(?!127\.0\.0\.1|localhost)|src="http://').Count
# Result: 0 (all fixed!)
```

**Security Benefits:**
- ✅ No mixed content warnings
- ✅ All external resources load securely
- ✅ Better SEO ranking (Google prefers HTTPS)
- ✅ Improved user trust (green padlock)
- ✅ Protects against man-in-the-middle attacks

**Prevention for Future Projects:**
1. Always use `https://` for external links (never `http://`)
2. Avoid protocol-relative URLs (`//domain.com`) - use explicit `https://`
3. Test on HTTPS server before deployment
4. Use browser DevTools to check for mixed content warnings

**Reference:** Applied same fix from Limen Groupe project (February 18, 2026)

**Commit Reference:** HTTPS/Mixed Content Security fix applied

---

### 🔥 FIX #7: Viewport Meta Tag Regression in index.html (Feb 18, 2026)

**Problem:** index.html homepage showing oversized text, wrong layout, and mobile view on desktop.

**Root Cause:** Viewport meta tag in index.html was accidentally set to fixed width instead of responsive width:
```html
<!-- WRONG (in index.html): -->
<meta name="viewport" content="width=1280, initial-scale=1.0"/>

<!-- CORRECT (should match other pages): -->
<meta name="viewport" content="width=device-width, maximum-scale=1"/>
```

**Impact:** 
- Homepage displaying in narrow/mobile layout on desktop browsers
- Text and images oversized
- Layout not responsive to screen size
- Inconsistent with other pages (about, services, etc.) which were already fixed

**Solution:** Fixed viewport meta tag in index.html to match other pages.

**Verification:**
```powershell
# Check all HTML files for correct viewport
$files = Get-ChildItem "*.html" | Where-Object { $_.Name -notlike "live_*" }
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match 'viewport.*width=1280') {
        Write-Host "$($file.Name) - WRONG viewport"
    } else {
        Write-Host "$($file.Name) - Correct viewport"
    }
}
```

**Files Fixed:**
- ✅ index.html (Feb 18, 2026)

**Deployment Status:**
- ✅ Fixed in source code
- ✅ Committed to git (commit 4902bac)
- ✅ Pushed to GitHub
- ✅ Updated deployment ZIP (8.89 MB)
- ⏳ Ready for re-upload to Webuzo/production

**Note:** This fix resolves layout issues reported after initial deployment. All 8 pages now have consistent, responsive viewport configuration.

---

### 🔥 FIX #8: .htaccess HTML Encoding Bug - 500 Internal Server Error (Feb 18, 2026)

**Problem:** Website returning 500 Internal Server Error on all pages when deployed to Webuzo/production.

**Root Cause:** .htaccess file was corrupted with HTML-encoded entities instead of actual brackets:
```apache
# WRONG (causing 500 error):
&lt;IfModule mod_rewrite.c&gt;
&lt;/IfModule&gt;

# CORRECT:
<IfModule mod_rewrite.c>
</IfModule>
```

**Impact:**
- Apache cannot parse HTML entities (`&lt;` `&gt;`) in .htaccess files
- Results in immediate 500 Internal Server Error for entire site
- Prevents any page from loading
- Affects both homepage and all subpages

**How It Happened:**
- .htaccess was likely created/edited through a tool that HTML-encoded the content
- File appeared correct in some editors but contained `&lt;` and `&gt;` instead of `<` and `>`

**Solution:**
```powershell
# Replace all HTML entities with actual characters
$content = Get-Content ".htaccess" -Raw -Encoding UTF8
$fixed = $content -replace '&lt;', '<' -replace '&gt;', '>'
$fixed | Set-Content ".htaccess" -Encoding UTF8 -NoNewline
```

**Verification:**
```powershell
# Check for HTML encoding
$content = Get-Content ".htaccess" -Raw
if ($content -match '&lt;|&gt;') {
    Write-Host "❌ Still has HTML encoding"
} else {
    Write-Host "✅ Clean"
}
```

**Files Fixed:**
- ✅ .htaccess (Feb 18, 2026)
- ✅ .htaccess_minimal (already clean)

**Deployment Status:**
- ✅ Fixed in source code
- ✅ Committed to git (commit 959ffda)
- ✅ Pushed to GitHub
- ✅ Updated deployment ZIP (8.89 MB)
- ⏳ Ready for re-upload to Webuzo/production

**Testing:**
After uploading fixed .htaccess, the site should load without 500 errors. Browser console may show Webuzo branding warnings (ignore those).

---

### 🔥 FIX #9: Simplify .htaccess for Webuzo Compatibility (Feb 18, 2026)

**Problem:** Website still returning 500 Internal Server Error after fixing HTML encoding. Other websites (matrixbs) work fine on same Webuzo server.

**Root Cause:** Complex .htaccess directives not supported by Webuzo shared hosting:
- `RewriteBase /` - can cause 500 errors on shared hosting
- `Header always set` vs `Header set` - "always" modifier not supported
- `<FilesMatch "^\.">` - complex regex pattern causing issues
- `<IfModule mod_php7.c>` - PHP settings not allowed on shared hosting
- Duplicate unset directives for X-Powered-By header

**Solution:** Simplified .htaccess based on proven working matrixbs configuration.

**Key Changes:**
```apache
# REMOVED:
- RewriteBase /
- Header always set (changed to Header set)
- Complex <FilesMatch "^\."> pattern
- PHP settings block
- Duplicate Header unset directives
- Overly complex deflate compression rules

# KEPT (essential):
- HTTPS redirect
- Clean URLs (.html removal)
- Security headers (simplified)
- Browser caching
- GZIP compression (simplified)
- Directory browsing protection
```

**Before:** 148 lines with complex enterprise-level directives  
**After:** 80 lines with Webuzo-compatible directives

**Files Modified:**
- ✅ .htaccess (simplified from 148 to 80 lines)
- ✅ Backup created (.htaccess.backup)

**Deployment Status:**
- ✅ Simplified in source code
- ✅ Committed to git (commit 456ad21)
- ✅ Pushed to GitHub
- ✅ Updated deployment ZIP (8.89 MB)
- ⏳ Ready for re-upload to Webuzo

**Testing:**
Upload new .htaccess and verify site loads without 500 errors. This configuration is proven to work on Webuzo (tested on matrixbs project).

**Reference:** Based on working .htaccess from matrixbs project.

---

### 🔥 CRITICAL: Indigo Platform Multi-Page vbid CSS Fix

**⚠️ THIS IS THE #1 ISSUE FOR INDIGO MULTI-PAGE SITES ⚠️**

**Problem:** Pages showing mobile/narrow view with oversized text and images, while home page displays correctly.

**Root Cause:** Indigo CMS platform generates unique CSS per page using different `vbid` (view-block-id) parameters. Each page has its own style rules identified by unique vbid codes. **NEVER use one shared `static_style.css` for all pages!**

**Symptoms:**
- Pages appear in mobile/narrow layout on desktop
- Text and images much larger than on live site
- Layout breaking, content too wide or misaligned
- Home page works but other pages don't

**Solution - Step-by-Step:**

**Step 1: Extract vbid from each HTML file**
```powershell
$files = @('index.html', 'about-us.html', 'services.html')  # Add all your pages
foreach ($file in $files) {
    $content = Get-Content $file -Raw
    if ($content -match 'data-root-id="(vbid-[^"]+)"') {
        $rootVbid = $matches[1]
        Write-Host "$file uses vbid: $rootVbid"
    }
}
```

**Step 2: Download page-specific CSS for each vbid**
```powershell
# Example for index.html with vbid-da6b7-bismj4tk
Invoke-WebRequest -Uri "https://www.indigo-cy.com/static_style?v=1.6.0f2-noimos-no-viewer&vbid=vbid-da6b7-bismj4tk&caller=live" -OutFile "assets\css\static_style_index.css"

# Example for about-us.html with different vbid
Invoke-WebRequest -Uri "https://www.indigo-cy.com/static_style?v=1.6.0f2-noimos-no-viewer&vbid=vbid-da6b7-jbw3cwyn&caller=live" -OutFile "assets\css\static_style_about.css"
```

**Step 3: Update each HTML to reference its specific CSS**
- index.html → static_style_index.css
- about-us.html → static_style_about.css
- Each page gets its own CSS file!

**Key Learning:** File sizes vary significantly (34KB vs 57KB) because each page has different styling needs.

**Reference:** See mirsat README for complete implementation example.

---

### Common Issues to Check

1. **🔥 INDIGO MULTI-PAGE SITES** - Extract vbid per page and download separate CSS files (see above)
2. **🔥 HTTPS REDIRECTS** - Comment out `if(window.location.protocol != 'https:')` scripts for local testing
3. **🔥 NAVIGATION LINKS** - Convert absolute paths (href="/about") to relative (href="about-us.html")
4. **🔥 IMAGE QUALITY** - ⚠️ NEVER download low-resolution images! Always download original/high-quality images from the live site. Check image URLs for size parameters (s1600, s800, etc.) and use the highest available or remove size parameters entirely.
5. **Path Issues** - Check for `/dist/` prefixes or absolute paths
6. **CDN URLs** - Identify and localize all external resources
7. **CSS url() References** - Check CSS files for image paths
8. **JavaScript CDNs** - Look for hardcoded URLs in JS files
9. **Tracking Scripts** - Disable Analytics/Facebook/YouTube for local testing
9. **UTF-8 Encoding** - Use `-Encoding UTF8` when saving files (preserves Arabic/international text)

---

### Local Testing Methods

**🔐 SSL Server (RECOMMENDED - No HTTPS redirect issues!):**

**Option 1: Quick Start (Current Project)**
```powershell
.\start.ps1
```
Opens indigo-lb with SSL on https://127.0.0.1:8080

**Option 2: Universal Launcher (Any Project)**
```powershell
cd "C:\Users\Alaa\Documents\githup\Selenium"
.\start_ssl_server.ps1 indigo-lb 8080        # Specific project + port
.\start_ssl_server.ps1 yellowecoenergy 8081 # Different project
.\start_ssl_server.ps1                      # Run from project folder
```

**Option 3: Manual SSL Server**
```powershell
cd "c:\Users\Alaa\Documents\githup\Selenium\indigo-lb"
http-server -S -C "C:\ssl\localhost+2.pem" -K "C:\ssl\localhost+2-key.pem" -p 8080
# Open: https://127.0.0.1:8080
```

**🛠️ SSL Setup (One-time - Already Done!)**
```powershell
# SSL certificates already created in C:\ssl\
# Certificates work for ALL projects!
# Valid until: May 3, 2028
```

**📋 Stop Server:**
```powershell
Get-Process node | Stop-Process
```

**Alternative Methods (if SSL not needed):**

1. **file:// Protocol (Basic testing):**
```powershell
start chrome "file:///c:/Users/Alaa/Documents/githup/Selenium/indigo-lb/index.html"
```

2. **http-server (No SSL):**
```powershell
cd "c:\Users\Alaa\Documents\githup\Selenium\indigo-lb"
http-server -p 8080
# Open: http://127.0.0.1:8080
```

---

### Complete Project Realization Checklist

⏳ **Stage 1-3: Initial Setup**
- [ ] Create folder structure
- [ ] Download HTML source
- [ ] Set up local testing environment
- [ ] Identify external dependencies (DevTools → Network tab)

⏳ **Stage 4: Image Localization**
- [ ] Extract image URLs with regex
- [ ] Download to images/ folder
- [ ] Replace URLs in HTML
- [ ] Check CSS files for url() image references

⏳ **Stage 5-6: CSS/JS Localization**
- [ ] Identify external CSS/JS files
- [ ] Download to assets/css/ and assets/js/
- [ ] Update script/link tags in HTML
- [ ] Check for page-specific CSS (vbid system)

⏳ **Stage 7: JavaScript Fixes**
- [ ] Check for hardcoded CDN URLs in JS files
- [ ] Disable HTTPS redirect scripts
- [ ] Disable tracking scripts (Analytics, Facebook)
- [ ] Modify image loading if needed

⏳ **Stage 8: Special Fixes**
- [ ] Fix navigation links (absolute → relative)
- [ ] Remove external server references
- [ ] Test all pages and features

⏳ **Stage 9: Backend Implementation**
- [ ] Create contact_handler.php for email
- [ ] Configure SMTP or PHP mail()
- [ ] Add form validation
- [ ] Test email delivery

⏳ **Stage 10: Final Testing**
- [ ] Test in Chrome, Firefox, Safari, Edge
- [ ] Validate responsive design
- [ ] Test all navigation links
- [ ] Verify form submissions
- [ ] Check image loading

⏳ **Stage 11: Deployment Package**
- [ ] Create .htaccess file
- [ ] Re-enable HTTPS redirect and tracking
- [ ] Create indigo-lb_deployment.zip
- [ ] Push to GitHub with ZIP included
- [ ] Test on Namecheap after upload

---

### Useful PowerShell Scripts

**Extract Image URLs:**
```powershell
$content = Get-Content "index.html" -Raw
$urls = [regex]::Matches($content, 'https://[^\"\\s]+\\.(jpg|jpeg|png|gif|svg|webp)') | 
    ForEach-Object { $_.Value } | Select-Object -Unique
$urls | Out-File "image_urls.txt"
Write-Host "Found $($urls.Count) unique images"
```

**Download Images:**
```powershell
$urls = Get-Content "image_urls.txt"
New-Item -ItemType Directory -Force -Path "images" | Out-Null
foreach ($url in $urls) {
    $filename = Split-Path $url -Leaf
    Invoke-WebRequest -Uri $url -OutFile "images/$filename"
    Write-Host "Downloaded: $filename"
}
```

**Fix HTTPS Redirect (Critical for Local Testing):**
```powershell
# Problem: Pages redirect to HTTPS causing SSL errors on localhost
# Solution: Comment out the HTTPS redirect script

$files = @('index.html', 'about-us.html', 'services.html', 'contact.html')
foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Find and comment out HTTPS redirect script
        $pattern = '(<script[^>]*>[\s\S]*?if\s*\(\s*window\.location\.protocol\s*!=\s*[''"]https:[''"][\s\S]*?</script>)'
        $replacement = "<!-- DISABLED FOR LOCAL TESTING:`n`$1`n-->"
        $content = $content -replace $pattern, $replacement
        
        # Save with UTF-8 encoding (preserves Arabic/international text)
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "✓ Fixed HTTPS redirect in $file"
    }
}

Write-Host "`n✅ HTTPS redirect disabled for local testing!"
Write-Host "💡 For deployment: Re-enable HTTPS redirect in production version"
```

**Fix Navigation Links (Absolute to Relative):**
```powershell
# Convert absolute paths to relative for local testing
$files = @('index.html', 'about-us.html', 'services.html', 'contact.html')
foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Fix common navigation patterns
        $content = $content -replace 'href="/"([^"])', 'href="index.html"'
        $content = $content -replace 'href="/about-us"', 'href="about-us.html"'
        $content = $content -replace 'href="/services"', 'href="services.html"'
        $content = $content -replace 'href="/contact"', 'href="contact.html"'
        
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "✓ Fixed navigation links in $file"
    }
}
```

**Replace URLs:**
```powershell
$content = Get-Content "index.html" -Raw
$content = $content -replace 'https://cdn\\.example\\.com/', ''
Set-Content "index.html" $content -NoNewline
```

**Disable HTTPS Redirect:**
```powershell
$content = Get-Content "index.html" -Raw
$content = $content -replace '(<script[^>]*>[\\s\\S]*?location\\.protocol[\\s\\S]*?https[\\s\\S]*?<\\/script>)', '<!-- DISABLED $1 -->'
Set-Content "index.html" $content -NoNewline
```

---

### Important Notes

- Study yellowecoenergy and limen groupe READMEs for detailed examples
- Always test locally before creating deployment package
- Document every fix in this README for future reference
- Never use file:// for sites with JavaScript navigation issues
- **GitHub:** Push repository with deployment ZIP included

---

## For New AI Conversations

**Start Here:**
1. Read `../PROJECT_WORKFLOW_GUIDE.md` (complete workflow)
2. Study `../limen groupe/README.md` (reference implementation)
3. Study `../yellowecoenergy/README.md` (8 critical methods)
4. Check `../publicmatterslebanon/README.md` (common issues)
5. Begin Stage 1 of workflow

**DO NOT:**
- Skip workflow stages
- Copy files from other projects
- Assume localhost setup without reading the guide

**Expected Timeline:** Single day (based on limen groupe)

---

**Created:** February 1, 2026  
**Status:** Awaiting initialization

---

## 🚀 Stage 11: Deployment Package - CRITICAL REQUIREMENTS

### ⚠️ BEFORE CREATING ZIP - CHECKLIST:

#### 1. **Email Backend Verification** (contact_handler.php)
```powershell
# MUST CHECK ORIGINAL SITE FOR EMAIL CONFIGURATION
# Go to: https://original-domain.com (inspect contact form submission)
# Find: Email recipient address in form action or backend

# Example: contact_handler.php should have:
$to = "info@client-domain.com";  // ← CHECK ORIGINAL SITE FOR THIS!
$subject = "Contact Form Submission from Website";
```

**Steps:**
1. Open original website in browser
2. Open DevTools → Network tab
3. Submit contact form
4. Check POST request for email destination
5. Update `contact_handler.php` with correct email address
6. Test locally before deploying

---

#### 2. **.htaccess Configuration** (Must be Namecheap-ready)
```apache
# filepath: .htaccess

# PRODUCTION CONFIGURATION FOR NAMECHEAP
# Force HTTPS (Namecheap provides SSL certificate)
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Remove .html extension from URLs
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^([^\.]+)$ $1.html [NC,L]

# Custom error pages (optional)
ErrorDocument 404 /404.html
ErrorDocument 500 /500.html

# Security headers
Header set X-Content-Type-Options "nosniff"
Header set X-Frame-Options "SAMEORIGIN"
Header set X-XSS-Protection "1; mode=block"

# Cache control for better performance
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
</IfModule>
```

**Important:** 
- ✅ Namecheap provides SSL certificate automatically
- ✅ Our local SSL (`C:\ssl\`) is ONLY for local testing
- ❌ Do NOT include local SSL certificates in deployment ZIP

---

#### 3. **HTTPS Redirect Scripts - RE-ENABLE FOR DEPLOYMENT**
```powershell
# If you disabled HTTPS redirect for local testing, RE-ENABLE IT NOW!

$files = @('index.html', 'about-us.html', 'services.html', 'contact.html')
foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        # Remove comment tags around HTTPS redirect script
        $content = $content -replace '<!-- DISABLED FOR LOCAL TESTING:\s*', ''
        $content = $content -replace '\s*-->\s*<!-- END DISABLED HTTPS REDIRECT -->', ''
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "✅ Re-enabled HTTPS redirect in $file"
    }
}
```

---

#### 4. **Remove Local Testing Files from ZIP**
**DO NOT INCLUDE:**
- ❌ `start.ps1` (local SSL launcher)
- ❌ `start_ssl_server.ps1` (universal SSL launcher)
- ❌ Any `.ps1` PowerShell scripts
- ❌ `README.md` (optional - keep if useful for client)
- ❌ `.git/` folder (if present)

**MUST INCLUDE:**
- ✅ All HTML files (8 pages)
- ✅ `images/` folder (106 JPG files, 8.66 MB)
- ✅ `assets/css/` folder (11 CSS files)
- ✅ `assets/js/` folder (7 JavaScript files)
- ✅ `assets/fonts/` folder (4 font files)
- ✅ `contact.php` (with correct email - UPDATE EMAIL ADDRESS!)
- ✅ `.htaccess` (production-ready)
- ✅ `README.md` (documentation)

---

#### 5. **Create Deployment ZIP**
```powershell
# Navigate to project folder
cd "C:\Users\Alaa\Documents\githup\Selenium\<project-name>"

# Create ZIP excluding local testing files
$exclude = @('*.ps1', 'README.md', '.git')
$source = Get-ChildItem -Exclude $exclude
Compress-Archive -Path $source -DestinationPath "project_deployment.zip" -Force

Write-Host "✅ Deployment package created: project_deployment.zip"
Write-Host "📦 Ready for Namecheap upload!"
```

---

### 📋 Pre-Deployment Checklist

Before uploading to Namecheap, verify:

- [x] **Email Backend**: `contact.php` created (⚠️ UPDATE EMAIL ADDRESS on line 44!)
- [x] **HTTPS Redirects**: Configured in `.htaccess`
- [x] **Navigation Links**: Using relative paths
- [ ] **.htaccess**: Production configuration (HTTPS redirect, clean URLs)
- [ ] **Tracking Scripts**: Re-enabled (Google Analytics, etc.)
- [ ] **Image Paths**: All using local paths (no CDN URLs)
- [ ] **CSS/JS Paths**: All using local paths (no CDN URLs)
- [ ] **No Local Testing Files**: Removed `.ps1` scripts from ZIP
- [ ] **Test ZIP Contents**: Extract and verify all files present

---

### 🎯 Namecheap Deployment Steps

1. **Login to Namecheap cPanel**
2. **Navigate to File Manager**
3. **Go to `public_html` directory**
4. **Delete existing files** (if replacing old site)
5. **Upload `project_deployment.zip`**
6. **Extract ZIP** (right-click → Extract)
7. **Delete ZIP file** after extraction
8. **Set file permissions** (if needed):
   - HTML files: 644
   - Folders: 755
   - PHP files: 644
9. **Test website**: Visit `https://yourdomain.com`
10. **Test contact form**: Submit and verify email received

---

### 🔒 SSL Certificate on Namecheap

- Namecheap provides **FREE SSL certificate** (Let's Encrypt)
- SSL activates automatically within 24 hours
- Our local SSL (`C:\ssl\`) is **ONLY for local testing**
- `.htaccess` HTTPS redirect will work once Namecheap SSL is active

---

### 📧 Email Configuration Notes

**Common Email Patterns:**
- `info@domain.com`
- `contact@domain.com`
- `admin@domain.com`
- `support@domain.com`

**How to Find:**
1. Check original site's contact form submission (DevTools → Network)
2. Ask client for their business email
3. Check domain's email hosting (Namecheap email, Gmail, etc.)

**Update in contact.php (line 44):**
```php
$to = "info@indigo-lb.com";  // ← CHANGE TO YOUR EMAIL!
$from = $_POST['email'];
$subject = "Contact Form Submission";
```

---

## 📦 Deployment Package Contents

**File:** `indigo-lb_deployment.zip` (8.89 MB, 139 files)

### Package Structure:
```
indigo-lb_deployment.zip
├── index.html (213 KB)
├── about-indigo.html (194 KB)
├── contact-us.html (131 KB)
├── animation.html (287 KB)
├── commercials.html (217 KB)
├── branding.html (293 KB)
├── digital-marketing.html (199 KB)
├── web-services.html (180 KB)
├── contact.php (2.3 KB) ⚠️ UPDATE EMAIL ADDRESS!
├── .htaccess (5.2 KB)
├── README.md (21 KB)
├── images/ (106 JPG files, 8.66 MB)
│   ├── High-res: 15 files (>100KB) - Portfolio images
│   ├── Medium-res: 11 files (50-100KB)
│   └── Low-res: 80 files (<50KB) - Icons, UI elements
├── assets/
│   ├── css/ (11 files, 339 KB)
│   │   ├── static_style_index.css (60 KB)
│   │   ├── static_style_about.css (53 KB)
│   │   ├── static_style_contact.css (28 KB)
│   │   ├── static_style_animation.css (37 KB)
│   │   ├── static_style_commercials.css (30 KB)
│   │   ├── static_style_branding.css (36 KB)
│   │   ├── static_style_digital.css (49 KB)
│   │   ├── static_style_webservices.css (36 KB)
│   │   ├── fonts.css (4.8 KB)
│   │   ├── effects.css (30 KB)
│   │   └── lightbox.css (1.6 KB)
│   ├── js/ (7 files, 394 KB)
│   │   ├── all_js.js (89 KB)
│   │   ├── jquery-2.x-git.min.js (84 KB)
│   │   ├── jquery.mobile.custom.min.js (7.6 KB)
│   │   ├── lightbox.js (15 KB)
│   │   ├── spimeengine.js (73 KB)
│   │   ├── spimeengine_working.js (7.4 KB)
│   │   └── xprs_helper.js (117 KB)
│   └── fonts/ (4 files, 118 KB)
│       ├── helveticaneuethn-webfont.eot (18 KB)
│       ├── helveticaneuethn-webfont.svg (48 KB)
│       ├── helveticaneuethn-webfont.ttf (32 KB)
│       └── helveticaneuethn-webfont.woff (20 KB)
```

### ⚠️ BEFORE DEPLOYMENT:

**1. Update Email Address in contact.php:**
```powershell
# Open contact.php and change line 44:
$to = 'your-email@indigo-lb.com';  # ← CHANGE THIS!
```

**2. Choose www vs non-www in .htaccess:**
- Currently configured for: `indigo-lb.com` (non-www)
- To use `www.indigo-lb.com`, edit lines 17-25 in `.htaccess`

**3. Verify Package Contents:**
```powershell
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('indigo-lb_deployment.zip')
Write-Host "Total files: $($zip.Entries.Count)"
$zip.Dispose()
```

### Ready for Upload! 🚀

---

### ✅ Final Verification

After deployment to Namecheap:
- [ ] Website loads with HTTPS (green padlock)
- [ ] All pages accessible and display correctly
- [ ] Images load properly
- [ ] Navigation works (all links functional)
- [ ] Contact form submits successfully
- [ ] Email received at correct address
- [ ] Mobile responsive design working
- [ ] No console errors (F12 DevTools)

---
