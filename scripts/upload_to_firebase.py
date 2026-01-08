# upload_firestore.py
import json
from pathlib import Path
import firebase_admin
from firebase_admin import credentials, firestore

json_path = "jsons/2026-01-04.json"
firebase_cred_path = "serviceAccountKey.json"

cred = credentials.Certificate(firebase_cred_path)
firebase_admin.initialize_app(cred)
db = firestore.client()

collection_name = Path(json_path).stem


docs = db.collection(collection_name).stream()
for doc in docs:
    doc.reference.delete()

with open(json_path, "r", encoding="utf-8") as f:
    products = json.load(f)

for product in products:
    db.collection(collection_name).add(product)

print(f"Uploaded {len(products)} products to Firestore collection '{collection_name}'")
