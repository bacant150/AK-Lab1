/* linker script for stm32f1
 * platforms
 * Define the end of RAM and limit of stack memory
 */
MEMORY
{
  /* We mark flash memory as read-only, since that is where the program lives.
     STM32 chips map their flash memory to start at 0x08000000, and we have 1MB of
     flash memory available. */

  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1M

  /* We mark the RAM as read/write, and as mentioned above it is 128KB long
     starting at address 0x20000000. */
  RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

/* Define the start of the stack */
__stack_start = ORIGIN(RAM) + LENGTH(RAM);
