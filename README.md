# 🎓 UniFine

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org/)
[![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)](https://www.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A powerful, AI-driven iOS app designed to help students improve their writing. UniFine provides an intuitive interface for detecting and correcting various types of errors in text, from grammar and spelling to style and coherence.

## Features

* **Smart Text Analysis**: Real-time AI-powered detection of grammar, spelling, and style errors
* **Context-Aware Suggestions**: Intelligent recommendations based on the text's context and purpose
* **Multiple Text Types**: Support for essays, research papers, reports, and other academic writing
* **Learning Support**: Explanations and examples to help understand corrections
* **Progress Tracking**: Monitor improvement over time with detailed analytics

## Technology Stack

* **Language**: Swift
* **Architecture**: TCA with modular architecture by features
* **Frameworks**: SwiftUI
* **AI Integration**: OpenAI API for text analysis
* **Networking**: OpenAPI Runtime/Generator
* **Additional Libraries**: Dependencies as DI, Tagged by Point-Free

## Getting Started

### Prerequisites

* iOS 17.0+ / macOS 14+
* Xcode 16+

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yegormi/unifine-ios.git
   cd unifine-ios
   ```

2. Open the project in Xcode

3. Run the app by selecting your target device or simulator and pressing `Cmd + R`

## Usage Guide

### Initial Setup

1. Launch UniFine on your iOS device
2. Create an account:
   * Tap "Sign Up" on the welcome screen
   * Enter your email and create a password
   * Follow the setup prompts
   * Or sign in if you already have an account

### Using the App

1. Create a Document
   * Provide a document title
   * Choose a writing style (Formal, Informal, Friendly)
   * Tap Next to proceed

2. Input Text
   * Paste or type text directly into the editor
   * Upload a PDF file to extract content
   * Tap Next for analysis

3. Review Analysis
   * AI scans for grammar, spelling, style, and coherence errors
   * Review highlighted areas for suggested improvements
   * Tap highlighted sections to see:
     * Detailed suggestions
     * Explanations and recommendations

4. Plagiarism Detection
   * Tap "Check Plagiarism"
   * Wait for the comprehensive Internet search
   * Review matching source links

5. Progress Tracking (Coming Soon)
   * Visit the "Analytics" tab to monitor:
     * Total errors detected and corrected
     * Plagiarism detection accuracy
     * Grammar, style, and spelling improvements

## Key Capabilities

* Grammar & Spelling: Advanced error detection and correction
* Style Analysis: Suggestions for clarity and conciseness
* Academic Writing Support: Specialized checks for academic conventions
* Multilingual Support: Analysis available in multiple languages
* Privacy Focus: Secure handling of user texts and data

## Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Created by [@yegormi](https://github.com/yegormi) - feel free to reach out!
