SDK_PREFIX ?= arm-none-eabi-
CC = $(SDK_PREFIX)gcc
LD = $(SDK_PREFIX)ld
SIZE = $(SDK_PREFIX)size
OBJCOPY = $(SDK_PREFIX)objcopy

QEMU = /home/io23huranets/opt/xPacks/qemu-arm/xpack-qemu-arm-7.2.0-1/bin/qemu-system-gnuarmeclipse

BOARD ?= STM32F4-Discovery
MCU = STM32F407VG
TARGET = firmware
CPU_CC = cortex-m4
TCP_ADDR = 1234

SRCS = start.S
OBJS = start.o
LDSCRIPT = lscript.ld

all: $(TARGET).bin

%.o: %.S
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU_CC) -Wall $< -o $@

$(TARGET).elf: $(OBJS)
	$(CC) $(OBJS) -mcpu=$(CPU_CC) -Wall --specs=nosys.specs -nostdlib -lgcc -T$(LDSCRIPT) -o $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary -F elf32-littlearm $< $@

qemu: $(TARGET).bin
	$(QEMU) --verbose --verbose --board $(BOARD) --mcu $(MCU) -d unimp,guest_errors --image $(TARGET).bin --semihosting-config enable=on,target=native -gdb tcp::$(TCP_ADDR) -S

clean:
	-rm -f *.o *.elf *.bin
