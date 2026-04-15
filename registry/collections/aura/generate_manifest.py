#!/usr/bin/env python3
"""Generate manifest.json for the Aura component collection."""

import json
import os
import re

COMPONENTS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "components")
OUTPUT_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "manifest.json")

# Keywords to scan for in HTML content (lowercased)
TAG_KEYWORDS = ["gsap", "webgl", "three.js", "canvas", "tailwind", "animated", "interactive"]


def humanize_name(dir_name: str) -> str:
    """Convert directory name like '01-animated-ai-workflow-hero' to 'Animated AI Workflow Hero'."""
    # Remove leading number prefix
    name = re.sub(r"^\d+-", "", dir_name)
    # Split on hyphens and title-case
    words = name.split("-")
    # Special casing for known acronyms
    acronyms = {"ai", "3d", "webgl", "cta", "saas"}
    result = []
    for w in words:
        if w.lower() in acronyms:
            result.append(w.upper())
        else:
            result.append(w.capitalize())
    return " ".join(result)


def infer_category(name_lower: str) -> str:
    """Infer category from the component name."""
    if "hero" in name_lower:
        return "hero"
    if "pricing" in name_lower:
        return "pricing"
    if "feature" in name_lower or "metrics" in name_lower:
        return "features"
    if "dashboard" in name_lower or "visualization" in name_lower:
        return "dashboard"
    if "cta" in name_lower:
        return "cta"
    return "section"


def extract_tags(html_content: str) -> list:
    """Extract tags by scanning HTML content for known keywords."""
    content_lower = html_content.lower()
    tags = []
    for keyword in TAG_KEYWORDS:
        if keyword in content_lower:
            tags.append(keyword)
    return tags


def extract_description(html_content: str, fallback_name: str) -> str:
    """Extract description from HTML title tag or derive from name."""
    # Try <title> tag
    match = re.search(r"<title>(.*?)</title>", html_content, re.IGNORECASE | re.DOTALL)
    if match:
        title = match.group(1).strip()
        if title and title.lower() not in ("", "document", "untitled"):
            return title
    # Try first <h1>
    match = re.search(r"<h1[^>]*>(.*?)</h1>", html_content, re.IGNORECASE | re.DOTALL)
    if match:
        # Strip HTML tags from h1 content
        h1_text = re.sub(r"<[^>]+>", "", match.group(1)).strip()
        if h1_text:
            return h1_text[:120]
    # Fallback: derive from name
    return f"{fallback_name} component"


def find_formats(component_dir: str) -> dict:
    """Find available format files for a component."""
    formats = {}
    html_dir = os.path.join(component_dir, "html")
    react_dir = os.path.join(component_dir, "react")

    if os.path.isdir(html_dir):
        html_files = [f for f in os.listdir(html_dir) if f.endswith(".html")]
        if html_files:
            formats["html"] = f"html/{html_files[0]}"

    if os.path.isdir(react_dir):
        react_files = [f for f in os.listdir(react_dir) if f.endswith(".tsx") or f.endswith(".jsx")]
        if react_files:
            formats["react"] = f"react/{react_files[0]}"

    return formats


def main():
    components = []
    dirs = sorted(os.listdir(COMPONENTS_DIR))

    for dir_name in dirs:
        component_dir = os.path.join(COMPONENTS_DIR, dir_name)
        if not os.path.isdir(component_dir):
            continue

        name = humanize_name(dir_name)
        name_lower = dir_name.lower()
        category = infer_category(name_lower)
        formats = find_formats(component_dir)

        # Read HTML content for tags and description (only the HTML file)
        html_content = ""
        html_path = os.path.join(component_dir, "html", "index.html")
        if os.path.isfile(html_path):
            try:
                with open(html_path, "r", encoding="utf-8", errors="ignore") as f:
                    html_content = f.read()
            except Exception:
                pass

        tags = extract_tags(html_content)
        description = extract_description(html_content, name)

        component_entry = {
            "id": dir_name,
            "name": name,
            "category": category,
            "description": description,
            "tags": tags,
            "formats": formats,
        }
        components.append(component_entry)

    manifest = {
        "name": "aura",
        "version": "1.0.0",
        "source": "https://aura.build/components",
        "components": components,
    }

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)

    print(f"{len(components)} components loaded")


if __name__ == "__main__":
    main()
