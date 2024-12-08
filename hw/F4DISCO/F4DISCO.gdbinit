## off paging
set startup-quietly on
set height 0
set pagination off

## remote
set tcp connect-timeout 1
set tcp auto-retry off
target extended-remote :3333
mon shutdown
mon exit

# ## manual run
# # set height 10
# # set pagination on
# layout split
# # layout asm
# # layout reg
# # set substitute-path /home/dponyatov/flic/ ./
# # set substitute-path /home/pere/src/newlib-salsa /home/dponyatov/stm32/ref/newlib-salsa
# ## on load
# # b Reset_Handler
# # b SystemInit
# # b main
# # 
# # "b SystemInit",
# # "b main",
# # "interrupt",
# # "c",

# b MX_GPIO_Init
# interrupt
# c
# monitor reset halt

# set $gp = GPIO_InitStruct
# p $gp
