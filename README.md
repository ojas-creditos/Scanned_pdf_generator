# PDF Scan Quality Generator

A lightweight Bash utility for converting digital PDFs into rasterized scanned PDFs and generating controlled moderate and poor-quality scan variants.

Useful for testing PDF quality checkers, OCR pipelines, document parsers, and scan-quality validation systems.

## Features

- Convert digital PDFs into image-based scanned PDFs
- Generate moderate-quality scanned PDFs
- Generate poor/reject-quality scanned PDFs
- Batch process multiple PDFs
- Randomized skew and blur per page
- Automatic output folder creation
- Temporary processing files are automatically cleaned up

## Requirements

The script requires:

- Ghostscript
- ImageMagick

### macOS

Install using Homebrew:

```bash
brew install ghostscript imagemagick
```

Ghostscript: https://www.ghostscript.com/

ImageMagick: https://imagemagick.org/

## Project Structure

Create an `input` folder and place your digital PDFs inside it.

```text
pdf-scan-quality-generator/
├── generate.sh
└── input/
    ├── statement1.pdf
    ├── statement2.pdf
    └── statement3.pdf
```

The `input/` folder is required.

Output folders are created automatically.

## Setup

Make the script executable:

```bash
chmod +x generate.sh
```

## Usage

### Generate all scan variants

```bash
./generate.sh all
```

For every PDF in `input/`, this generates:

```text
scanned/
moderate/
poor/
```

Example:

```text
input/
└── statement.pdf

scanned/
└── statement_scanned.pdf

moderate/
└── statement_moderate.pdf

poor/
└── statement_poor.pdf
```

One input PDF produces three output PDFs.

### Generate only a clean scanned PDF

```bash
./generate.sh scanned
```

Creates a 200 DPI rasterized, image-based PDF without artificial degradation.

### Generate moderate-quality scans

```bash
./generate.sh moderate
```

Moderate scans use approximately:

- 150 DPI
- ±1.2° random page skew
- 0.3–0.7 blur
- JPEG quality 70

Designed to simulate a degraded but generally usable scanned document.

### Generate poor-quality scans

```bash
./generate.sh poor
```

Poor scans use approximately:

- 90 DPI
- ±3° random page skew
- 1.0–2.0 blur
- JPEG quality 35

Designed to simulate low-quality or potentially rejectable scanned documents.

## Available Modes

| Mode | Description |
|---|---|
| `scanned` | Clean rasterized scanned PDF |
| `moderate` | Moderately degraded scan |
| `poor` | Poor/reject-quality scan |
| `all` | Generate all three variants |

## Notes

- Original PDFs inside `input/` are never modified.
- All processing happens locally.
- Scan degradation is randomized per page.
- Moderate and poor outputs may vary slightly between runs.
- Generated PDFs are image-based and do not preserve the original digital text layer.
- This tool generates synthetic scan-quality variants for testing purposes. It does not reproduce every characteristic of a physical scanner or phone camera.

## Example

```bash
mkdir input
cp statement.pdf input/

chmod +x generate.sh
./generate.sh all
```

Done.

## License

MIT
