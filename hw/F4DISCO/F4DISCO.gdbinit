# -e: exec-file   bin/F4DISCO_2v22.elf
# -s: symbol-file bin/F4DISCO_2v22.elf

## off paging
set startup-quietly on
set height 0
set pagination off

## remote
set tcp connect-timeout 1
set tcp auto-retry off
target extended-remote :3333

monitor reset halt
# load

b Reset_Handler
b SystemInit
b SystemClock_Config
b MX_GPIO_Init
b main
set $pc = Reset_Handler
si

# # layout src reg asm split
# 
# # # mon shutdown
# # # mon exit
# # 
# # # ## manual run
# # # # set height 10
# # # # set pagination on
# # # # set substitute-path /home/dponyatov/flic/ ./
# # # # set substitute-path /home/pere/src/newlib-salsa /home/dponyatov/stm32/ref/newlib-salsa
# # 
# # # set $gp = GPIO_InitStruct
# # # p $gp
