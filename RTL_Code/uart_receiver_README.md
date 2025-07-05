## 📥 Receiver Block

This module handles the **serial reception** of UART data using a **SIPO (Serial-In Parallel-Out) shift register**, and validates the received byte with **odd parity checking** and **stop bit confirmation**. It operates using a dedicated FSM for reliable and accurate frame decoding.

---

### 🎛️ Inputs

- 🕒 **Receiver Clock Pulses**: Baud pulses (16× oversampled) from the Baud Generator.
- 🔁 **Serial Data**: Incoming serial bitstream.
- 🟢 **Receiver Enable**: Activates the receiver module.

---

### 📤 Outputs

- 📦 **Parallel Data**: 8-bit parallel output after complete and verified reception.
- ✅ **Data Valid**: High when received frame passes parity and stop bit verification.

---

### 💡 Key Features

- 🧮 **8-bit SIPO Shift Register**: Accumulates serial bits into an 8-bit parallel word.
- 🔎 **Odd Parity Checking**: Verifies data integrity using odd parity logic.

---

### 🔄 Working Principle

- 🚦 Begins in the **IDLE** state, waiting for a valid **START bit** (`0`) when receiver is enabled.
- 📥 On detection of the START bit, transitions into data reception states.
- ✅ After receiving 8 data bits, the next bits are used for:
  - **Parity Check**: Confirms that the total number of `1`s is odd.
  - **Stop Bit Check**: Expects a logical `1` to mark the end of frame.
- 📤 If both checks pass, the parallel data is flagged as **valid** and output. Otherwise, the frame is discarded.

---

### 🧠 FSM States

| 🏷️ State       | 🔢 Hex Code | ⚙️ Description                                                                 |
| :------------: | :---------: | :------------------------------------------------------------------------------ |
| `IDLE`         | `0x0`       | Waits for START bit (`0`) when receiver is enabled                             |
| `DATA_START`   | `0x1`       | Detects and confirms valid START bit                                           |
| `DATA_IN`      | `0x2`       | Shifts in serial data bits (8-bit SIPO)                                        |
| `DATA_PARITY`  | `0x3`       | Checks if received parity matches expected odd parity                          |
| `DATA_STOP`    | `0x4`       | Validates STOP bit; outputs data if valid, otherwise discards the received frame |

---