# reg_FIFO Documentation

A parameterized FIFO (First-In, First-Out) queue implemented in Verilog.

---

## Overview

`reg_FIFO` implements a register-based FIFO. It has two main parameters:
- **width** (default = 32) – The number of entries (rows) in the FIFO.
- **depth** (default = 16) – The bit-width of each stored entry.

Internally, the module maintains:
- A 2D register array `reg_file[width - 1 : 0]` of `depth` bits each.
- Write/Read pointers (`w_ptr`/`r_ptr`).
- A counter `count` to track the current number of entries.

---

## Port Description

| **Port**     | **Direction** | **Width**                  | **Description**                                                            |
|--------------|---------------|----------------------------|----------------------------------------------------------------------------|
| `data_in`    | Input         | `[depth - 1 : 0]`         | Data to be written into the FIFO.                                         |
| `r_en`       | Input         | 1 bit                      | Read enable signal. High = read if FIFO is not empty.                     |
| `w_en`       | Input         | 1 bit                      | Write enable signal. High = write if FIFO is not full.                    |
| `reset`      | Input         | 1 bit                      | Asynchronous reset. Resets pointers, flags, etc.                          |
| `clk`        | Input         | 1 bit                      | Clock input, rising edge triggered.                                       |
| `data_out`   | Output        | `[depth - 1 : 0]`         | The data output from the FIFO on read operations.                         |
| `empty`      | Output        | 1 bit                      | Indicates FIFO empty status.                                              |
| `full`       | Output        | 1 bit                      | Indicates FIFO full status.                                               |
| `count_1`    | Output        | `[5 : 0]`                  | Reflects the internal count of elements stored in the FIFO.               |

---

## Internal Signals

1. **`reg_state [depth-1:0]`** – Holds the most recently read data.  
2. **`reg_file [width-1 : 0]` of `[depth-1 : 0]`** – The main storage for FIFO data.  
3. **`empty_flag`, `full_flag`** – Internal flags for empty/full conditions.  
4. **`count [5:0]`** – Tracks the number of valid elements in the FIFO.  
5. **`r_ptr [4:0]`, `w_ptr [4:0]`** – Read and write pointers.  

> Note: `4:0` pointer width supports a FIFO depth of up to 32 entries (since \(2^5 = 32\)).

---

## Operation

### Reset
- Asynchronous reset input (**reset**).
- Sets `w_ptr`, `r_ptr`, and `count` to 0.
- Forces `reg_state` to `16'bx`.
- By default, `empty` = 1 and `full` = 0 upon reset.

### Write Operation
- Triggered when `w_en == 1` **and** FIFO is not full.
- Data from `data_in` is written to `reg_file[w_ptr]`.
- `w_ptr` is incremented, wrapping to 0 if it reaches `width - 1`.
- `count` is incremented by 1.

### Read Operation
- Triggered when `r_en == 1` **and** FIFO is not empty.
- The content of `reg_file[r_ptr]` is moved into `reg_state` and output via `data_out`.
- `r_ptr` is incremented, wrapping to 0 if it reaches `width - 1`.
- `count` is decremented by 1.

### Read and Write Simultaneously
- If `r_en` and `w_en` are both high in the same clock cycle:
  - One new entry is written to `reg_file[w_ptr]`.
  - One entry is read from `reg_file[r_ptr]` into `reg_state`.
  - Both pointers (`w_ptr` and `r_ptr`) are incremented (with wrapping).
  - `count` remains effectively the same, because one item enters and another leaves.

---

## Empty/Full Logic

- **Empty** if `count == 0`:  
  - `empty_flag` = 1, `full_flag` = 0.  
- **Full** if `count >= width`:  
  - `full_flag` = 1, `empty_flag` = 0.  
- Otherwise, both flags are 0, indicating a partially filled FIFO.  

After the clock edge, `empty` and `full` outputs mirror `empty_flag` and `full_flag` unless `reset` is asserted (in which case, `empty = 1` and `full = 0`).

---

## Summary

This **reg_FIFO** module is a circular buffer using a register array, with synchronous read and write on the rising clock edge. The read pointer, write pointer, and counter track FIFO status. It supports:
- **Parameterizable** depth (`width`) and data width (`depth`).
- **Simultaneous** read and write in the same cycle.
- **Empty/Full** detection via flags and a counter.

It’s suitable for scenarios where a simple, parameterized FIFO is required, such as buffering data streams between different clock or enable domains (with the proper synchronization if needed).

