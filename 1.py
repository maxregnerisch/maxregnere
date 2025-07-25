#!/usr/bin/env python3
"""
DeepSeek File Recoder
Recodes all compatible files to mrrom format with g0s S22 S906B optimizations
Requires: pip3 install openai tqdm
"""

import os
import argparse
from openai import OpenAI
from tqdm import tqdm
import time
import mimetypes
import hashlib

# Configuration
API_URL = "https://api.deepseek.com/v1/chat/completions"
SCRIPT_NAME = os.path.basename(__file__)
SUPPORTED_TYPES = [
    'application/x-sh'
]
DEVICE_SPEC = "g0s device s22 s906b"
MRROM_FEATURES = [
    "quantum_encryption", "neural_ui", "hw_accel_s906b", 
    "zero_latency_io", "adaptive_power_mgmt", "ai_vision_enhance"
]
MAX_FILE_SIZE = 128000  # 128KB (API limit consideration)

def get_file_hash(file_path):
    """Get SHA256 hash of file content"""
    hasher = hashlib.sha256()
    with open(file_path, "rb") as f:
        while chunk := f.read(4096):
            hasher.update(chunk)
    return hasher.hexdigest()

def recode_content(client, content, file_path):
    """Send content to DeepSeek API for recoding"""
    try:
        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=[
                {
                    "role": "system",
                    "content": (
                        f"Recode this file for {DEVICE_SPEC} with mrrom features. "
                        f"Include: {', '.join(MRROM_FEATURES)}. "
                        "Maintain original functionality while optimizing. "
                        "Return ONLY recoded content without explanations."
                    )
                },
                {
                    "role": "user",
                    "content": f"File: {file_path}\nContent:\n{content}"
                }
            ],
            temperature=0.1,
            max_tokens=4000,
            stream=False
        )
        return response.choices[0].message.content.strip()
    except Exception as e:
        print(f"\nAPI Error on {file_path}: {str(e)}")
        return None

def process_file(client, file_path):
    """Process individual file"""
    try:
        # Check file size
        if os.path.getsize(file_path) > MAX_FILE_SIZE:
            return "Skipped (size too large)"
        
        # Check MIME type
        mime_type, _ = mimetypes.guess_type(file_path)
        if not any(mime_type.startswith(t) for t in SUPPORTED_TYPES):
            return "Skipped (unsupported type)"
        
        # Read file content
        with open(file_path, 'r', encoding='utf-8') as f:
            original_content = f.read()
        
        # Skip empty files
        if not original_content.strip():
            return "Skipped (empty)"
        
        # Create backup
        backup_path = f"{file_path}.bak"
        if not os.path.exists(backup_path):
            with open(backup_path, 'w', encoding='utf-8') as f:
                f.write(original_content)
        
        # Recode content
        recoded = recode_content(client, original_content, file_path)
        if not recoded:
            return "Failed (API error)"
        
        # Write recoded content
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(recoded)
        
        return "Recoded"
    except UnicodeDecodeError:
        return "Skipped (binary file)"
    except Exception as e:
        return f"Error: {str(e)}"

def main():
    parser = argparse.ArgumentParser(
        description="DeepSeek MRROM File Recoder",
        epilog=f"Optimized for {DEVICE_SPEC}"
    )
    parser.add_argument("--api-key", help="DeepSeek API Key", required=True)
    parser.add_argument("--dir", default=".", help="Directory to process")
    args = parser.parse_args()

    client = OpenAI(
        api_key=args.api_key,
        base_url="https://api.deepseek.com"
    )

    print(f"⚡ Starting MRROM Recode for {DEVICE_SPEC}")
    print(f"✨ Features: {', '.join(MRROM_FEATURES)}")
    print(f"📂 Scanning: {os.path.abspath(args.dir)}")
    
    # Collect files with progress tracking
    file_queue = []
    for root, _, files in os.walk(args.dir):
        for file in files:
            if file == SCRIPT_NAME or file.endswith(".bak"):
                continue
            file_path = os.path.join(root, file)
            file_queue.append(file_path)
    
    # Process files with rate limiting
    print(f"\n🔄 Processing {len(file_queue)} files...")
    results = []
    for file_path in tqdm(file_queue, unit="file", desc="Recoding"):
        result = process_file(client, file_path)
        results.append((file_path, result))
        time.sleep(0.5)  # Rate limiting
    
    # Print summary
    print("\n📊 Recoding Summary:")
    for path, status in results:
        print(f"• {os.path.relpath(path)}: {status}")

if __name__ == "__main__":
    main()
