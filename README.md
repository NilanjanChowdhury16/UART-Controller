# 🧠 Custom UART Controller in Verilog (RTL and Verification)

🚀 This project implements a fully custom **UART (Universal Asynchronous Receiver Transmitter) Controller** using **Verilog HDL**, designed for high-speed, full-duplex serial communication with a focus on **hardware and memory efficiency**. It supports baud rates up to **921600** with a **100 MHz core clock**, maintaining a communication error margin within **±2%**.

---

## 🔑 Key Implementation Details

### 🧱 Modular Architecture

Consists of three main blocks:

- 🔧 **Baud Generator**  
  Generates local clocks based on user-specified baud rate and core clock frequency, with **16× oversampling** support for precise receiver synchronization.

- 📤 **Transmitter**  
  Utilizes an **8-bit PISO shift register**, transmits 8-bit data with an **odd parity bit**, and is driven by a clean FSM:  
  `IDLE → START → DATA_OUT → PARITY → STOP → RESET`.

- 📥 **Receiver**  
  Implements an **8-bit SIPO shift register**, performs **parity and frame validation**, and is managed by its own FSM:  
  `IDLE → DATA_START → DATA_IN → DATA_PARITY → DATA_STOP`.

---

### 📶 High-Speed Communication

- Operates at baud rates up to **921600** with a **100 MHz clock**, ideal for high-performance serial interfaces.

---

### 💾 Memory-Efficient Design

- Built using **compact FSM logic** and **minimal shift register hardware**, ensuring low resource utilization.

---

### 🔋 Low Power Operation

- Employs **selective enable signals** for the main module, transmitter, and receiver, minimizing switching activity and power consumption when idle.

---

### ✅ Error-Tolerant Protocol

- Implements **start, parity, and stop bit** checks to ensure that only correctly framed and verified data is accepted and forwarded.

---

### 🔄 Full Duplex Communication

- Supports simultaneous **8-bit data transmission and reception** through completely independent and parallel transmitter and receiver paths.

---
