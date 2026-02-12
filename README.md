# Verilog Adders Library  
*A structured study and implementation of classical and parallel prefix adders*

---

## Overview

This repository presents a systematic Verilog implementation of fundamental and high-performance digital adders.  
The emphasis is on **architectural understanding**, not just functional correctness.

The project progresses from basic combinational building blocks to scalable, high-speed prefix adders used in modern processors.

Key objectives:

- Understand carry propagation mechanisms  
- Compare speed vs area vs wiring trade-offs  
- Practise clean RTL design and parameterisation  
- Enable synthesis and timing exploration  


## Architectural Trade-Off Summary

| Adder | Speed | Area | Wiring | Practical Use |
|-------|------|------|--------|---------------|
| HA | Very low | Minimal | Minimal | Educational |
| FA | Low | Small | Minimal | Building block |
| RCA | Slowest | Smallest | Minimal | Low-power paths |
| CLA | Fast (small N) | High | Moderate | Small ALUs |
| Kogge-Stone | Fastest | Largest | Very high | High-speed CPUs |


## Design Philosophy

Binary addition is dominated by **carry computation delay**.

Different adder families represent different strategies:

- Let carry ripple (simple, slow)  
- Predict carry (fast for small widths)  
- Compute carry via prefix tree (fastest scalable approach)  

This repository implements each category explicitly.

---

## Bit-Width Control

### Global Parameterisation

A central header file:

### `params.vh`

defines the global design parameter:

'N' → Adder bit-width.

All scalable adders derive their width from **N**.

Changing **N** automatically updates:

- Ripple Carry Adder (RCA)  
- Kogge-Stone Adder (generic)  
- Any other parameterised designs  

---

## Fixed-Width Exception

### `CLA_8bit.v`

`CLA_8bit.v` is intentionally **not parameterised**.

**Reason**

Carry Lookahead logic scales poorly due to:

- Rapid growth of logic terms  
- Large fan-in  
- Routing complexity  

This reflects practical hardware design constraints.

---

## Project Structure
```
HA.v → Half Adder
FA.v → Full Adder
RCA.v → Ripple Carry Adder (parameterised)
CLA_8bit.v → Carry Lookahead Adder (fixed 8-bit)
KS.v → 4-bit Kogge-Stone Adder (manual topology)
kogge_stone.v → Generic N-bit Kogge-Stone Adder
All_adders.v → Integration / wrapper module(s)
params.vh → Global parameters
```
---

## Implemented Adders

---

### 1. Half Adder (HA)

**Function**

Adds two single-bit operands.

**Outputs**

- Sum  
- Carry  

**Role**

- Educational foundation  
- Used inside larger structures  

**Limitations**

- No carry-in  
- Not scalable alone  

---

### 2. Full Adder (FA)

**Function**

Adds:

- A  
- B  
- Carry-in  

**Outputs**

- Sum  
- Carry-out  

**Role**

- Atomic arithmetic unit  
- Basis of ripple architectures  

---

### 3. Ripple Carry Adder (RCA)

**Architecture**

Chain of full adders.

**Carry Behaviour**

Sequential ripple from LSB → MSB.

**Characteristics**

- Delay ∝ N  
- Minimal area  
- Very low complexity  

**Use Cases**

- Small datapaths  
- Low-power designs  
- Non-critical timing paths  

---

### 4. Carry Lookahead Adder (CLA) — Fixed 8-bit

**Architecture**

Carry computed using:

- Generate (G)  
- Propagate (P)  

**Strengths**

- Faster than RCA (small widths)  

**Weaknesses**

- Logic explosion for large N  
- High area & power  

**Purpose in Repository**

Demonstrate scalability limitations.

---

## Parallel Prefix Adders

Prefix adders treat carry computation as a **prefix problem**.

All follow three stages:

1. **Pre-processing** → Bit-level G/P  
2. **Prefix Network** → Group G/P via tree  
3. **Post-processing** → Carry & Sum  

---

### 5. Kogge-Stone Adder (KS / KSA)

#### a) `KS.v` (4-bit manual implementation)

Explicit prefix topology showing:

- Distance-1 stage  
- Distance-2 stage  

Useful for:

- Learning prefix mechanics  
- Debugging signal flow  

---

#### b) `kogge_stone.v` (Generic N-bit)

**Features**

- Fully parameterised  
- Uses `$clog2(N)` stages  
- Scales cleanly  

**Characteristics**

- Delay ≈ log₂(N)  
- Very high wiring  
- Large area  

**Strengths**

- Fastest practical carry computation  

**Weaknesses**

- Routing congestion  
- Higher switching power  

**Use Cases**

- High-performance ALUs  
- Timing-critical datapaths  

---

## Why Prefix Adders Matter

Compared to CLA:

| Aspect | CLA | Prefix Adders |
|--------|-----|---------------|
| Logic Growth | Rapid | Structured |
| Scalability | Poor | Excellent |
| Delay | Low (small N) | log₂(N) |
| Practicality | Limited | Industry standard |

Prefix adders dominate modern CPU arithmetic design.

---
## Learning Outcomes

This repository enables:

- Understanding carry propagation strategies  
- Prefix tree logic intuition  
- RTL parameterisation practice  
- Synthesis & timing comparison  

---

## Intended Audience

- Digital design students  
- RTL beginners → intermediate learners  
- GATE / VLSI preparation  
- Engineers revisiting arithmetic architectures  

---

## Suggested Experiments

1. Change `N` in `params.vh`  
2. Synthesize RCA vs Kogge-Stone  
3. Compare:

   - Logic depth  
   - Resource usage  
   - Fmax  

4. Observe wiring growth in prefix designs  

---

## Future Extensions

- Brent-Kung Adder (generic)  
- Han-Carlson hybrid prefix adder  
- Automated testbenches  
- Timing & area comparison reports  
- Power estimation studies  
- Signed / saturating adders  

---

## Final Note

This project is designed as a **study-grade RTL library**, bridging:

Theory → Architecture → Verilog → Synthesis

Understanding *why* an adder is chosen is as important as knowing *how* it works.

