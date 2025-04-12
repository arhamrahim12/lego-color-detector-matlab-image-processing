# LEGO Color Pattern Detector using MATLAB

This project detects and classifies color patterns from digital images of LEGO "Life of George" 4x4 boards. It automates the recognition of colors and evaluates accuracy by comparing outputs with ground truth data.

## 📌 Features

- Detects circular regions in noisy, rotated, or distorted images
- Corrects geometric distortions using projective transformation
- Applies median filtering and contrast enhancement for color extraction
- Matches colors using Euclidean distance from reference palette
- Displays color results in a structured 4x4 grid
- Evaluates detection accuracy against `.mat` files containing solutions

## 🧠 Methods

### 1. `findColours.m`

Main function that:
- Loads an image
- Detects circles
- Applies correction if necessary
- Extracts colors
- Outputs a 4x4 matrix of color names

### 2. Helper Functions

- `loadImage.m`: Loads and preprocesses the image
- `findCircles.m`: Identifies circle coordinates
- `correctImage.m`: Applies transformation to fix orientation
- `getColours.m`: Extracts and classifies color data

### 3. `runScript.m`

Batch processor for `.png` images with matching `.mat` files. Reports per-image and average detection accuracy.

## 📂 File Structure

├── findColours.m # Main function ├── runScript.m # Evaluation script ├── /data # Images and .mat solution files ├── README.md # Project documentation

## ✅ Requirements

- MATLAB with Image Processing Toolbox

## 💡 How to Use

1. Place your `.png` and corresponding `.mat` files in `data/`.
2. Run `runScript.m` to evaluate all files.
3. Visual results and accuracy will be printed in the console.

## 📊 Example Output

For `noise_1.png`:
{'blue', 'white', 'red', 'green', ...} Success: 100%

csharp
Copy code

## 📌 Credits

Developed as part of a university image processing assignment.
