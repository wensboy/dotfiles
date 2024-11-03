#!/bin/bash 

#提示输入更改的亮度值
echo "change backlight to:"

#等待输入
read brightness_value

#检测输入是否合法
if ! [[ "$brightness_value" =~ ^[0-9]+$ ]] || [ "$brightness_value" -gt 100 ]
then
    echo "Invalid value"
    exit 1
fi

#设置亮度为输入值
#brightnessctl -l
brightnessctl s $brightness_value% 

#显示更改后的亮度值，提示更改成功
echo "Successful!"
