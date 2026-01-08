import pdfplumber
import json
import re
from pathlib import Path

# ---------------- CONFIG ----------------
pdf_path = "pdfs/2026-01-04.pdf"
output_json = "jsons/" + Path(pdf_path).stem + ".json"

products = []
current_category = None

HEADER_KEYWORDS = {
    "COMMODITY",
    "SPECIFICATION",
    "PREVAILING",
    "RETAIL",
    "PRICE",
    "UNIT",
    "P/UNIT",
    "DAILY",
    "INDEX",
    "NATIONAL",
    "REGION",
}

price_pattern = re.compile(r"\d+\.\d{2}$")  # price MUST end line
percent_pattern = re.compile(r"\d.*?%")     # handles 5%, 1-19%, etc.
pure_spec_pattern = re.compile(
    r"^\d+[,\d]*\s*(ml|l|g|kg|pcs|pc|pack|bottle|box)",
    re.IGNORECASE
)



# ---------------- HELPERS ----------------
def extract_name_and_spec(text: str):
    """
    Splits product name and specification correctly.
    Ensures ranges like 1-19% stay together.
    """
    match = percent_pattern.search(text)
    if match:
        name = text[:match.start()].strip()
        spec = text[match.start():].strip()
        return name, spec
    return text.strip(), "N/A"


def is_valid_category(line: str):
    """
    Detects category headers like:
    IMPORTED COMMERCIAL RICE
    FISH PRODUCTS
    """
    if not line.isupper():
        return False
    if re.search(r"\d", line):
        return False
    if any(keyword in line for keyword in HEADER_KEYWORDS):
        return False
    return True


# ---------------- MAIN ----------------
with pdfplumber.open(pdf_path) as pdf:
    for page in pdf.pages:
        text = page.extract_text()
        if not text:
            continue

        lines = [l.strip() for l in text.split("\n") if l.strip()]

        for line in lines:

            # ❌ Skip page markers
            if line.lower().startswith("page"):
                continue

            # ✅ CATEGORY detection
            if is_valid_category(line):
                current_category = line
                continue

            # ❌ Ignore anything before a category exists
            if current_category is None:
                continue

            # ✅ Must end with a valid price
            tokens = line.split()
            last_token = tokens[-1]

            if not price_pattern.match(last_token):
                continue

            price = float(last_token)

            # ❌ Filter garbage prices (years, page numbers)
            if price < 10:
                continue

            content = " ".join(tokens[:-1]).strip()

            # ❌ Skip header remnants
            if any(keyword in content.upper() for keyword in HEADER_KEYWORDS):
                continue

            # ❌ Skip lines that are PURE specifications
            if pure_spec_pattern.match(content):
                continue

            # ✅ Extract name & spec
            name, spec = extract_name_and_spec(content)


            if not name:
                continue

            products.append({
                "category": current_category,
                "name": name,
                "spec": spec,
                "price": price
            })


# ---------------- OUTPUT ----------------
with open(output_json, "w", encoding="utf-8") as f:
    json.dump(products, f, indent=2, ensure_ascii=False)

print(f"Saved {len(products)} products to {output_json}")
