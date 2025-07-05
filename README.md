🧠 Custom UART Controller in Verilog (RTL and Verification)

🚀 This project implements a fully custom UART (Universal Asynchronous Receiver Transmitter) Controller using Verilog HDL, designed for high-speed, full-duplex serial communication with a focus on hardware and memory efficiency. It supports baud rates up to 921600 with a 100 MHz core clock, maintaining a communication error margin within ±2%.

🔑 Key Implementation Details
🧱 Modular Architecture
Consists of three main blocks:

Baud Generator: Generates local clocks based on user-specified baud rate and core clock frequency, with 16x oversampling support for precise receiver synchronization.

Transmitter: Utilizes a PISO shift register and transmits 8-bit data with an odd parity bit, controlled by a clean FSM: IDLE → START → DATA_OUT → PARITY → STOP → RESET.

Receiver: Implements a SIPO shift register, performs parity and frame validation, and uses its own FSM: IDLE → DATA_START → DATA_IN → DATA_PARITY → DATA_STOP.

📶 High-Speed Communication
Operates at baud rates up to 921600, suitable for demanding serial interfaces.

💾 Memory-Efficient Design
Built using compact FSM logic and shift registers to minimize hardware and memory usage.

🔋 Low Power Operation
Selective enable signals for each module (transmitter, receiver, baud generator) reduce unnecessary switching when idle.

✅ Error-Tolerant Protocol
Includes start, parity, and stop bit checks to ensure only valid and verified data is received and forwarded.

🔄 Full Duplex Communication
Supports simultaneous 8-bit transmission and reception through independent paths.