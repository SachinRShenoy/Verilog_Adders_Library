# Verilog Adders Library  
*A structured study and implementation of classical and parallel prefix adders*

## Overview

This repository is a systematic Verilog implementation of digital adders, starting from the most fundamental building blocks and scaling up to high-performance parallel prefix adders.

The goal of this project is not just functional correctness, but architectural understanding:  
how different adder families behave in terms of speed, area, power, scalability, and real-world usage.

The design is parameterised using a central Verilog header file that defines the bit-width `N`.  
With the exception of a fixed-width Carry Lookahead Adder (CLA), all adders automatically scale when `N` is modified.

This makes the project suitable for:
- Architecture comparison
- Timing and synthesis studies
- Academic reference
- GATE and VLSI interview preparation
- RTL design practice

---

## Comparative Summary

| Adder Type        | Speed        | Area        | Power       | Scalability | Real-World Usage |
|------------------|-------------|------------|------------|-------------|------------------|
| Half Adder        | Very Slow   | Minimal    | Minimal    | None        | Educational only |
| Full Adder        | Slow        | Small      | Low        | Building block | Everywhere |
| Ripple Carry      | Slowest     | Smallest   | Lowest     | Excellent   | Low-end systems |
| Carry Lookahead   | Fast (small N) | High     | High       | Poor        | Small ALUs |
| Kogge-Stone       | Fastest     | Largest    | Highest    | Good        | High-end CPUs |
| Brent-Kung        | Fast        | Medium     | Medium     | Excellent   | Very common |
| Sklansky          | Fast        | Medium     | High       | Poor fan-out | Rare |
| Han-Carlson       | Very Fast   | Medium-High | Medium     | Good        | Selective use |

---

## Project Structure and Bit-Width Control

### Global Bit-Width Parameter

- A single Verilog header file defines:
- N = adder bit width
- All scalable adders use `N` consistently.
- Changing `N` updates:
- Ripple Carry Adder
- Parallel Prefix Adders (Kogge-Stone, Brent-Kung, etc.)
- The Carry Lookahead Adder is intentionally implemented as fixed 8-bit, to highlight practical limitations of CLA scalability.

This reflects real design practice:  
not every theoretically fast adder scales cleanly in silicon.

---

## Adder Implementations Included

### 1. Half Adder

**Purpose**
- Adds two single-bit operands
- Produces Sum and Carry

**Why it exists**
- Educational foundation
- Used internally in larger adders
- Not used directly in real processors

**Key points**
- No carry-in
- Minimal hardware
- Zero scalability on its own

---

### 2. Full Adder

**Purpose**
- Adds two bits plus a carry-in
- Outputs Sum and Carry-out

**Why it matters**
- Core building block of ripple and array adders
- Every multi-bit adder is ultimately composed of full adders

**Trade-off**
- Simple
- Slow when chained linearly

---

### 3. Ripple Carry Adder (RCA)

**Concept**
- Full adders connected in series
- Carry ripples from LSB to MSB

**Characteristics**
- Delay increases linearly with bit-width
- Very small area
- Very low design complexity

**Performance**
- Slow for large `N`
- Predictable timing
- Easy to verify

**Real-world usage**
- Small datapaths
- Low-power microcontrollers
- Non-critical arithmetic blocks

---

### 4. Carry Lookahead Adder (CLA) (Fixed 8-bit)

**Concept**
- Computes carry signals using Generate (G) and Propagate (P)
- Avoids waiting for ripple carry

**Why fixed width**
- Carry logic grows rapidly with bit-width
- Wiring and logic fan-in become impractical
- Demonstrates why CLAs are rarely used beyond small widths

**Performance**
- Much faster than RCA (for small widths)
- Area increases quickly
- Power increases due to complex logic

**Real-world usage**
- Small ALUs
- Instruction decoders
- Rarely used standalone for large adders

---

## Parallel Prefix Adders

Parallel prefix adders compute carries using a tree structure rather than a chain.

All prefix adders share the same three stages:
1. Pre-processing (Generate and Propagate)
2. Prefix computation (carry tree)
3. Post-processing (sum generation)

What changes is how the tree is built.

---

### 5. Kogge-Stone Adder (KSA)

**Design goal**
- Minimum logic depth
- Fastest carry computation

**Characteristics**
- Log₂(N) delay
- Very high wiring complexity
- Large area
- High power consumption

**Strengths**
- Fastest adder in theory
- Ideal for timing-critical paths

**Weaknesses**
- Routing congestion
- Power hungry
- Poor scalability in dense designs

**Real-world usage**
- High-performance CPUs
- GPUs
- Critical datapaths where speed dominates everything else

---

### 6. Brent-Kung Adder (BKA)

**Design goal**
- Reduce area and wiring compared to Kogge-Stone

**Characteristics**
- Slightly higher delay than KSA
- Roughly half the number of prefix nodes
- Much cleaner routing

**Strengths**
- Excellent balance between speed and area
- Easier to place and route
- Lower power than KSA

**Weaknesses**
- Not the absolute fastest

**Real-world usage**
- Most commonly used prefix adder
- Practical CPU and DSP designs
- Industry-preferred architecture

---

### 7. Sklansky Adder (Divide and Conquer)

**Design goal**
- Minimise logic depth

**Characteristics**
- Very low depth
- High fan-out
- Uneven load distribution

**Strengths**
- Fast on paper
- Simple prefix structure

**Weaknesses**
- High fan-out causes timing issues
- Poor electrical behaviour
- Rarely used in real silicon

**Real-world usage**
- Academic studies
- Rare in production designs

---

### 8. Han-Carlson Adder

**Design goal**
- Hybrid between Kogge-Stone and Brent-Kung

**Characteristics**
- Balanced depth and area
- Reduced wiring compared to KSA
- Better timing than Brent-Kung

**Strengths**
- Good compromise architecture
- Scales well
- Balanced performance

**Weaknesses**
- More complex to implement

**Real-world usage**
- High-performance yet area-constrained designs
- Less common than Brent-Kung, but very practical


## How to Think About These Adders

Here’s the thing that actually matters:

- Ripple Carry  
Choose when simplicity and power matter more than speed.

- Carry Lookahead  
Understand it conceptually. Avoid scaling it blindly.

- Kogge-Stone  
Choose when timing is everything and cost is secondary.

- Brent-Kung  
The most sensible real-world choice for wide adders.

- Sklansky  
Know it. Respect it. Rarely use it.

- Han-Carlson  
When you want smart compromises and clean timing.

---

## Why This Repository Exists

Most adder explanations stop at equations or diagrams.  
This project connects theory, RTL design, and architectural trade-offs.

By parameterising the bit-width and implementing multiple adder families side-by-side, this repository allows:
- Direct comparison
- Synthesis exploration
- Timing and area intuition
- Better design decisions

---

## Intended Audience

- Digital design students
- GATE aspirants
- RTL engineers
- Anyone who wants to understand why an adder is chosen, not just how it works

---

## Future Extensions

- Synthesis reports comparison
- Power and timing plots
- Testbench automation
- Signed adders
- Wallace and Dadda adders for multiplication
