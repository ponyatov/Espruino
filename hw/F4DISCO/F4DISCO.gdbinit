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

load
monitor reset halt
i reg pc sp msp xPSR

b Reset_Handler
b SystemInit
b main
c
# interrupt
# c
# 
# # layout src
# # layout reg
# # layout asm
# 
# # # mon shutdown
# # # mon exit
# # 
# # # ## manual run
# # # # set height 10
# # # # set pagination on
# # # layout split
# # # # layout asm
# # # # layout reg
# # # # set substitute-path /home/dponyatov/flic/ ./
# # # # set substitute-path /home/pere/src/newlib-salsa /home/dponyatov/stm32/ref/newlib-salsa
# # ## on load
# # # # 
# # # # "b SystemInit",
# # # # "b main",
# # # # "interrupt",
# # # # "c",
# # 
# # # b MX_GPIO_Init
# # # interrupt
# # # c
# # 
# # # set $gp = GPIO_InitStruct
# # # p $gp
# # 
# 
