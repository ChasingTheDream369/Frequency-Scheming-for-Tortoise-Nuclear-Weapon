# Frequency Scheming for Tortoise Nuclear Weapon

<div align="center">
  <img src="https://github.com/YourUsername/YourRepoName/raw/main/assets/tortoise-logo.png" alt="Tortoise Logo">
</div>

---

## Table of Contents

- [About](#about)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

---

## About

Welcome to Frequency Scheming for Tortoise Nuclear Weapon! This repository contains a Haskell implementation for frequency-based scheming. With this codebase, you can explore and manipulate frequencies and intervals efficiently.

---

## Features

- **Frequency Manipulation**: Easily manipulate frequencies and intervals.
- **Histogram Creation**: Create histograms from frequency data.
- **Histogram Operations**: Sort, remove duplicates, and merge histograms.
- **Testing**: Comprehensive QuickCheck testing for code reliability.

Explore the power of frequency scheming with Tortoise Nuclear Weapon!

---

## Installation

To get started with Tortoise Nuclear Weapon, follow these installation steps:

```bash
$ git clone https://github.com/YourUsername/YourRepoName.git
$ cd YourRepoName
$ stack build
```

## Usage

**Problem 1: Inside Function**

```
haskell

-- Checks if a frequency is inside an interval
inside :: Freq -> Interval -> Bool
```

**Problem 2: Sorting and Manipulating Histograms**

```
haskell

-- Sorts a histogram by interval
sortHistogram :: [(Interval, Count)] -> [(Interval, Count)]

-- Removes duplicate intervals from the histogram
nubHistogram :: [(Interval, Count)] -> [(Interval, Count)]

-- Creates a histogram from a list of interval-count pairs
histogram :: [(Interval, Count)] -> Histogram
```

**Problem 3: Frequency Processing**

```
haskell

-- Processes a list of Freq and generates a histogram
process :: [Freq] -> Histogram

-- Merges two histograms
merge :: Histogram -> Histogram -> Histogram
```

Get hands-on with these functions and start scheming your frequencies!

## Contributing

We welcome contributions! If you have any ideas, bug fixes, or improvements, please open an issue or submit a pull request.

Check out our Contribution Guidelines for more details.

Collaboration

## License

This project is licensed under the MIT License - see the LICENSE file for details.
<div align="center">
  Made with ❤️ by Shubham Johar.
</div>
