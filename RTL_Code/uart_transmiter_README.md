## 📤 Transmitter Block

This module manages **serial transmission** of UART data using an **8-bit PISO (Parallel-In Serial-Out) shift register**. It converts valid parallel data into a serial bitstream, appending **odd parity** and framing bits according to the UART protocol. A dedicated FSM handles bit-level sequencing and ensures proper framing.

---

### 🎛️ Inputs

- 📦 **Parallel Data**: 8-bit data to be transmitted.
- ✅ **Data Valid**: Signal indicating the input data is ready to transmit.
- 🕒 **Transmitter Clock**: Baud clock signal for timing the bit transmission.
- 🟢 **Transmitter Enable**: Activates transmission logic.

---

### 📤 Outputs

- 🟠 **Transmitter Ready**: Indicates that the module is ready to accept new data.
- 🔁 **Serial Data**: Bitstream output representing the serialized UART frame.

---

### 💡 Key Features

- 🔄 **8-bit PISO Shift Register**: Shifts parallel data out one bit at a time.
- 🧮 **Odd Parity Generation**: Appends a parity bit for basic error detection.

---

### 🔄 Working Principle

- 🚦 Begins in the **IDLE** state, where the serial line is held HIGH (`1`).
- 📥 On detecting **valid input data**, transitions to send a **START bit** (`0`).
- 📤 The **8-bit data** is then shifted out serially.
- 🧾 A **parity bit** is generated and sent based on **odd parity** logic.
- 🛑 A **STOP bit** (`1`) is transmitted to complete the frame.
- 🔁 FSM transitions to **RESET** before returning to **IDLE** for the next data byte.

---

### 🧠 FSM States

| 🏷️ State     | 🔢 Hex Code | ⚙️ Description                                                  |
| :----------: | :---------: | :-------------------------------------------------------------- |
| `IDLE`       | `0x0`       | Serial line held HIGH, waiting for valid data                   |
| `START`      | `0x1`       | Transmits logic LOW to indicate start of frame                  |
| `DATA_OUT`   | `0x2`       | Sends 8-bit parallel data serially through PISO register        |
| `PARITY`     | `0x3`       | Outputs calculated odd parity bit                               |
| `STOP`       | `0x4`       | Sends logic HIGH to mark the end of the data frame              |
| `RESET`      | `0x5`       | Clears internal registers and prepares for next transmission    |

---