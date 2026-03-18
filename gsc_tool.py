"""
GlycoTrace — Google Search Console CLI Tool
Usage:
    python gsc_tool.py status       — Check which pages are indexed
    python gsc_tool.py sitemap      — Submit sitemap to GSC
    python gsc_tool.py index        — Request indexing for all pages
    python gsc_tool.py analytics    — Pull last 30 days search analytics
    python gsc_tool.py all          — Run all of the above
"""

import sys
import os
import json
from pathlib import Path

from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build

SITE_URL = "sc-domain:glycotrace.co.uk"  # Domain property format
SCOPES = ["https://www.googleapis.com/auth/webmasters"]
CLIENT_SECRET = Path(__file__).parent / "client_secret_999245769998-5kkr2mon5j4ll3gkgafdpg9qqf54aj0k.apps.googleusercontent.com.json"
TOKEN_FILE = Path(__file__).parent / ".gsc_token.json"

PAGES = [
    "https://glycotrace.co.uk/",
    "https://glycotrace.co.uk/privacy_policy.html",
    "https://glycotrace.co.uk/tutorials.html",
    "https://glycotrace.co.uk/news.html",
    "https://glycotrace.co.uk/resources.html",
    "https://glycotrace.co.uk/freelance.html",
    "https://glycotrace.co.uk/community_guidelines.html",
    "https://glycotrace.co.uk/apply.html",
]


def authenticate():
    """Authenticate with Google OAuth (opens browser on first run, caches token)."""
    creds = None
    if TOKEN_FILE.exists():
        creds = Credentials.from_authorized_user_file(str(TOKEN_FILE), SCOPES)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(str(CLIENT_SECRET), SCOPES)
            creds = flow.run_local_server(port=0, open_browser=True)
        TOKEN_FILE.write_text(creds.to_json())

    return creds


def get_service(creds):
    return build("searchconsole", "v1", credentials=creds)


def cmd_status(service):
    """Check indexing status of all pages via URL Inspection API."""
    print("\n=== Page Indexing Status ===\n")
    for url in PAGES:
        try:
            result = service.urlInspection().index().inspect(
                body={"inspectionUrl": url, "siteUrl": SITE_URL}
            ).execute()
            inspection = result.get("inspectionResult", {})
            index_status = inspection.get("indexStatusResult", {})
            verdict = index_status.get("verdict", "UNKNOWN")
            coverage = index_status.get("coverageState", "N/A")
            last_crawl = index_status.get("lastCrawlTime", "Never")
            status_icon = "Y" if verdict == "PASS" else "X" if verdict == "FAIL" else "?"
            print(f"  [{status_icon}] {url}")
            print(f"      Verdict: {verdict} | Coverage: {coverage} | Last crawl: {last_crawl}")
        except Exception as e:
            print(f"  [!] {url}")
            print(f"      Error: {e}")
    print()


def cmd_sitemap(service):
    """Submit sitemap to Google Search Console."""
    print("\n=== Submitting Sitemap ===\n")
    sitemap_url = "https://glycotrace.co.uk/sitemap.xml"
    try:
        service.sitemaps().submit(siteUrl=SITE_URL, feedpath=sitemap_url).execute()
        print(f"  Submitted: {sitemap_url}")
    except Exception as e:
        print(f"  Error: {e}")

    # List current sitemaps
    try:
        result = service.sitemaps().list(siteUrl=SITE_URL).execute()
        sitemaps = result.get("sitemap", [])
        if sitemaps:
            print(f"\n  Registered sitemaps:")
            for sm in sitemaps:
                print(f"    - {sm['path']} (last submitted: {sm.get('lastSubmitted', 'N/A')})")
    except Exception as e:
        print(f"  Could not list sitemaps: {e}")
    print()


def cmd_index(service):
    """Request indexing for all pages via URL Inspection API."""
    print("\n=== Requesting Indexing ===\n")
    print("  Note: Google rate-limits indexing requests. Submitting for all pages...\n")
    for url in PAGES:
        try:
            result = service.urlInspection().index().inspect(
                body={"inspectionUrl": url, "siteUrl": SITE_URL}
            ).execute()
            inspection = result.get("inspectionResult", {})
            index_status = inspection.get("indexStatusResult", {})
            verdict = index_status.get("verdict", "UNKNOWN")
            print(f"  [{verdict}] {url}")
        except Exception as e:
            print(f"  [!] {url} — {e}")
    print("\n  Tip: Sitemap submission (gsc_tool.py sitemap) is the most effective")
    print("  way to get pages indexed. Google will crawl all URLs in the sitemap.\n")


def cmd_analytics(service):
    """Pull search analytics for the last 30 days."""
    print("\n=== Search Analytics (Last 30 Days) ===\n")
    try:
        result = service.searchanalytics().query(
            siteUrl=SITE_URL,
            body={
                "startDate": "2026-02-16",
                "endDate": "2026-03-18",
                "dimensions": ["query"],
                "rowLimit": 20,
            },
        ).execute()

        rows = result.get("rows", [])
        if not rows:
            print("  No search data yet. This is normal for a new site.")
            print("  Data typically appears 2-3 days after indexing.\n")
            return

        print(f"  {'Query':<40} {'Clicks':>6} {'Impressions':>11} {'CTR':>8} {'Position':>8}")
        print(f"  {'-'*40} {'-'*6} {'-'*11} {'-'*8} {'-'*8}")
        for row in rows:
            query = row["keys"][0][:40]
            clicks = int(row.get("clicks", 0))
            impressions = int(row.get("impressions", 0))
            ctr = f"{row.get('ctr', 0)*100:.1f}%"
            position = f"{row.get('position', 0):.1f}"
            print(f"  {query:<40} {clicks:>6} {impressions:>11} {ctr:>8} {position:>8}")
    except Exception as e:
        print(f"  Error: {e}")
    print()


def cmd_pages(service):
    """Pull per-page analytics."""
    print("\n=== Page Performance (Last 30 Days) ===\n")
    try:
        result = service.searchanalytics().query(
            siteUrl=SITE_URL,
            body={
                "startDate": "2026-02-16",
                "endDate": "2026-03-18",
                "dimensions": ["page"],
                "rowLimit": 20,
            },
        ).execute()

        rows = result.get("rows", [])
        if not rows:
            print("  No page data yet.\n")
            return

        print(f"  {'Page':<50} {'Clicks':>6} {'Impressions':>11}")
        print(f"  {'-'*50} {'-'*6} {'-'*11}")
        for row in rows:
            page = row["keys"][0].replace("https://glycotrace.co.uk", "")[:50] or "/"
            clicks = int(row.get("clicks", 0))
            impressions = int(row.get("impressions", 0))
            print(f"  {page:<50} {clicks:>6} {impressions:>11}")
    except Exception as e:
        print(f"  Error: {e}")
    print()


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return

    cmd = sys.argv[1].lower()

    print("Authenticating with Google Search Console...")
    creds = authenticate()
    service = get_service(creds)
    print("Authenticated.\n")

    commands = {
        "status": cmd_status,
        "sitemap": cmd_sitemap,
        "index": cmd_index,
        "analytics": cmd_analytics,
        "pages": cmd_pages,
    }

    if cmd == "all":
        cmd_sitemap(service)
        cmd_status(service)
        cmd_analytics(service)
        cmd_pages(service)
    elif cmd in commands:
        commands[cmd](service)
    else:
        print(f"Unknown command: {cmd}")
        print(__doc__)


if __name__ == "__main__":
    main()
