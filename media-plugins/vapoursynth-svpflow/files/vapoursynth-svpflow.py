# coding=utf-8

import vapoursynth as vs
from vapoursynth import core

# gpu渲染帧需要opencl
# 1 开启gpu渲染加速, 0 关闭gpu渲染加速
GPU_Acceleration = "1"

core.std.LoadPlugin("/lib64/libsvpflow1.so")
core.std.LoadPlugin("/lib64/libsvpflow2.so")

clip = video_in
# 检查并强制设置帧率 (解决 "unable to determine source frame rate")
if clip.fps_num == 0:
    # 如果源文件没提供帧率，强制设为 24fps
    clip = core.std.AssumeFPS(clip, fpsnum = 24000, fpsden = 1001)

# 分析运动向量只支持YUV420P8输入
# 渲染插帧10bit输入需要开启gpu加速, cpu渲染只支持8bit输入
if clip.format.id != vs.YUV420P8:
    if GPU_Acceleration == "1":
        clip_p8 = clip.resize.Point(format = vs.YUV420P8)
    else:
        clip_p8 = clip.resize.Bicubic(format = vs.YUV420P8)
        clip = clip_p8
else:
    clip_p8 = clip

# gpu:1 时开启GPU帧渲染
super_params="{gpu:" + GPU_Acceleration + "}"
super  = core.svp1.Super(clip_p8, super_params)

# block:{overlap:2}, 块重叠值:0-3, 数值越大速度越慢
analyse_params="{block:{overlap:3}}"
vectors= core.svp1.Analyse(super["clip"], super["data"], clip_p8, analyse_params)

# rate: {num: 2, den: 1, abs: false}
# num / den 定义源帧率变化倍数; abs 如果为true, num / den 定义绝对值帧率
# algo: 13, 渲染算法, 可选值: 1, 2, 11, 13, 21, 23
# 2 适用于2D动画; 13 伪影最少
smoothfps_params="""
{
    rate: { num: 2, den: 1, abs: false },
    algo: 13
}
"""
clip = core.svp2.SmoothFps(clip, super["clip"], super["data"], vectors["clip"], vectors["data"], smoothfps_params)

clip.set_output()
