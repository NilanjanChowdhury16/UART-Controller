# 🔧 Baud Generator Block

This module dynamically generates local baud clocks for both the **transmitter** and **receiver**, based on configurable frequency parameters and a common core clock input.

---

## 🎛️ Inputs

- ⏱️ **Core Clock**: System clock used for all internal timing.
- 🟢 **Enable**: Activates counting and clock generation logic.

---

## ⚙️ Parameters

- 📐 **Transmitter Clock Frequency**: Desired clock frequency for the transmitter path.
- 📐 **Receiver Clock Frequency**: Typically set as **16× the Transmitter Clock** for oversampling.
- 🔢 **Baud Rate**: Used to calculate the number of core clock cycles per baud pulse.

---

## 📤 Outputs

- 🕒 **Transmitter Clock**: Pulses at the specified baud rate for transmitter FSM control.
- 🕒 **Receiver Clock**: Pulses at **16× baud rate** for accurate receiver sampling.

---

## 🧠 Key Feature

- 📈 **Oversampling Support**: Receiver clock is automatically set to **16× the transmitter baud rate**, enhancing data sampling and synchronization accuracy.

---

## 🔄 Working Principle

### 🧮 Baud Pulse Calculation

- Calculates pulse timing based on the formula:

  - **Transmitter**:  
    `Baud Pulse Count = Core Clock Frequency / Desired Baud Rate`

  - **Receiver**:  
    `Baud Pulse Count = (Core Clock Frequency / Desired Baud Rate) / 16`

### 🔁 Counter Logic

- Begins counting core clock cycles when **Enable** is high.
- When count equals the calculated baud count, corresponding clock pulse output goes **HIGH**.
- Counter resets and repeats the process for both **transmitter** and **receiver** clocks independently and simultaneously.

---