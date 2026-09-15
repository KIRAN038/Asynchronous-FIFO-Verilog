# Asynchronous-FIFO-Verilog
RTL design and verification of an 8-bit × 8-depth asynchronous FIFO using Verilog HDL.

# Asynchronous FIFO Design and Verification using Verilog HDL

<p align="center">
  <img src="https://img.shields.io/badge/HDL-Verilog-blue" alt="Verilog">
  <img src="https://img.shields.io/badge/Design-Asynchronous%20FIFO-orange" alt="Async FIFO">
  <img src="https://img.shields.io/badge/Data%20Width-8--bit-green" alt="8-bit">
  <img src="https://img.shields.io/badge/Depth-8-purple" alt="8-depth">
  <img src="https://img.shields.io/badge/Simulation-Icarus%20Verilog-red" alt="Icarus Verilog">
  <img src="https://img.shields.io/badge/Waveform-GTKWave-yellow" alt="GTKWave">
</p>

<p align="center">
  <b>RTL Design and Verification of an 8-bit × 8-depth Asynchronous FIFO</b>
</p>

---

## 📌 Overview

This project presents the **RTL design and verification of an Asynchronous FIFO (First-In First-Out)** using **Verilog HDL**.

The FIFO is designed to transfer data between two independent clock domains:

- **Write Clock Domain (`wr_clk`)**
- **Read Clock Domain (`rd_clk`)**

Since the write and read sides operate using different clocks, the design uses **Gray-code pointers** and **2-flop synchronizers** for safe clock-domain crossing (CDC) of pointer information.

The complete design was simulated using **Icarus Verilog**, and the simulation waveforms were analyzed using **GTKWave**.

---

## 🎯 Project Objectives

The main objectives of this project are:

- Design an asynchronous FIFO using RTL Verilog.
- Implement independent write and read clock domains.
- Design separate write and read controllers.
- Implement binary write and read pointers.
- Convert binary pointers into Gray-code pointers.
- Safely synchronize pointer information across clock domains.
- Implement FIFO `full` and `empty` detection.
- Prevent writing when the FIFO is full.
- Prevent reading when the FIFO is empty.
- Develop a Verilog testbench for functional verification.
- Analyze and verify the design using simulation waveforms.

---

# 🏗️ FIFO Specifications

| Parameter | Specification |
|-----------|---------------|
| FIFO Type | Asynchronous FIFO |
| Data Width | 8 bits |
| FIFO Depth | 8 entries |
| Memory Size | 8 × 8 bits |
| Write Clock | `wr_clk` |
| Read Clock | `rd_clk` |
| Address Width | 3 bits |
| Write Pointer | 4-bit Binary + 4-bit Gray |
| Read Pointer | 4-bit Binary + 4-bit Gray |
| CDC Technique | Gray-code pointers |
| Synchronization | 2-flop synchronizers |
| Status Flags | `full`, `empty` |
| HDL | Verilog HDL |
| Simulation | Icarus Verilog |
| Waveform Analysis | GTKWave |

---

# 🔍 What is an Asynchronous FIFO?

A FIFO stores data according to the **First-In First-Out** principle.

The first data written into the FIFO is the first data read from it.

In a synchronous FIFO, the write and read operations use the same clock.

In an asynchronous FIFO, the write and read operations use **different clocks**.

```text
                 ASYNCHRONOUS FIFO

        WRITE DOMAIN                 READ DOMAIN
        ------------                 -----------

          wr_clk                       rd_clk
             │                            │
             ▼                            ▼
      Write Controller             Read Controller
             │                            │
             ▼                            ▼
       Write Pointer                 Read Pointer
             │                            │
             ▼                            ▼
        FIFO MEMORY
             │
             └───────────────┬───────────────┘
                             │
                       Data Transfer
