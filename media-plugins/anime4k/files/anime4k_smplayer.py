#! /usr/bin/python
# coding=utf-8

import os, sys
import configparser
import re

SMPLAYER_INI_PATH = os.path.join(os.environ["HOME"], R".config/smplayer/smplayer.ini")
GLSL_PATH = R"/usr/share/anime4k"
MODE_CONFIG = (
    ("Mode off",),
    (
        "Mode A (HQ/1080p)",
        Rf"{GLSL_PATH}/Anime4K_Clamp_Highlights.glsl,{GLSL_PATH}/Anime4K_Restore_CNN_VL.glsl,{GLSL_PATH}/Anime4K_Upscale_CNN_x2_VL.glsl,{GLSL_PATH}/Anime4K_AutoDownscalePre_x2.glsl,{GLSL_PATH}/Anime4K_AutoDownscalePre_x4.glsl,{GLSL_PATH}/Anime4K_Upscale_CNN_x2_M.glsl"
    ),
    (
        "Mode A+A (HQ/1080p)",
        Rf"{GLSL_PATH}/Anime4K_Clamp_Highlights.glsl,{GLSL_PATH}/Anime4K_Restore_CNN_VL.glsl,{GLSL_PATH}/Anime4K_Upscale_CNN_x2_VL.glsl,{GLSL_PATH}/Anime4K_Restore_CNN_M.glsl,{GLSL_PATH}/Anime4K_AutoDownscalePre_x2.glsl,{GLSL_PATH}/Anime4K_AutoDownscalePre_x4.glsl,{GLSL_PATH}/Anime4K_Upscale_CNN_x2_M.glsl"
    ),
    (
        "Mode B (HQ/720p)",
        Rf"{GLSL_PATH}/Anime4K_Clamp_Highlights.glsl,{GLSL_PATH}/Anime4K_Restore_CNN_Soft_VL.glsl,{GLSL_PATH}/Anime4K_Upscale_CNN_x2_VL.glsl,{GLSL_PATH}/Anime4K_AutoDownscalePre_x2.glsl,{GLSL_PATH}/Anime4K_AutoDownscalePre_x4.glsl,{GLSL_PATH}/Anime4K_Upscale_CNN_x2_M.glsl"
    ),
    (
        "Mode B+B (HQ/720p)",
        Rf"{GLSL_PATH}/Anime4K_Clamp_Highlights.glsl,{GLSL_PATH}/Anime4K_Restore_CNN_Soft_VL.glsl,{GLSL_PATH}/Anime4K_Upscale_CNN_x2_VL.glsl,{GLSL_PATH}/Anime4K_AutoDownscalePre_x2.glsl,{GLSL_PATH}/Anime4K_AutoDownscalePre_x4.glsl,{GLSL_PATH}/Anime4K_Restore_CNN_Soft_M.glsl,{GLSL_PATH}/Anime4K_Upscale_CNN_x2_M.glsl"
    ),
    (
        "Mode C (HQ/480p)",
        Rf"{GLSL_PATH}/Anime4K_Clamp_Highlights.glsl,{GLSL_PATH}/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl,{GLSL_PATH}/Anime4K_AutoDownscalePre_x2.glsl,{GLSL_PATH}/Anime4K_AutoDownscalePre_x4.glsl,{GLSL_PATH}/Anime4K_Upscale_CNN_x2_M.glsl"
    ),
    (
        "Mode C+A (HQ/480p)",
        Rf"{GLSL_PATH}/Anime4K_Clamp_Highlights.glsl,{GLSL_PATH}/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl,{GLSL_PATH}/Anime4K_AutoDownscalePre_x2.glsl,{GLSL_PATH}/Anime4K_AutoDownscalePre_x4.glsl,{GLSL_PATH}/Anime4K_Restore_CNN_M.glsl,{GLSL_PATH}/Anime4K_Upscale_CNN_x2_M.glsl"
    )
)


def print_available_mode():
    print("")
    for i in range(0, len(MODE_CONFIG)):
        print(f"[{i}]  {MODE_CONFIG[i][0]}")


def print_usage():
    name=os.path.basename(__file__).split('.')[0]
    print(f"\n{name} set [n]")
    print_available_mode()


def get_current_mode() -> int:
    config = configparser.ConfigParser()
    config.read(SMPLAYER_INI_PATH)
    mplayer_additional_options = config.get("advanced", "mplayer_additional_options")

    for i in range(1, len(MODE_CONFIG)):
        if "--glsl-shaders=" + MODE_CONFIG[i][1] in mplayer_additional_options:
            return i

    return 0


def print_current_mode(mode_num: int):
    print(f"\ncurrent_mode: {[mode_num]}  {MODE_CONFIG[mode_num][0]}")


def get_arv_setting(argv: list[str]):
    if "set" in argv and argv[-1].isdigit() and int(argv[-1]) < len(MODE_CONFIG):
        return int(argv[-1])
    else:
        print_usage()
        print_current_mode(get_current_mode())


def set_mode(mode_num: int):
    with open(SMPLAYER_INI_PATH, "r") as f:
        config = f.read()

    mplayer_additional_options = re.search(R"mplayer_additional_options=(.*)", config)
    mpv_cmd = mplayer_additional_options.group(1)
    if not mpv_cmd:
        mpv_cmd = ""

    if "--glsl-shaders=" in mpv_cmd:
        parameter_list = mpv_cmd.split("--")
        c = -1
        for i in range(0, len(parameter_list)):
            if "glsl-shaders=" in parameter_list[i]:
                c = i
                break

        if mode_num == 0:
            del parameter_list[c]
        else:
            parameter_list[c] = "glsl-shaders=" + MODE_CONFIG[mode_num][1]

        new_cmd = ""
        for i in range(1, len(parameter_list)):
            new_cmd += " --" + parameter_list[i].strip()

        new_cmd = new_cmd.strip()
        if new_cmd:
            mpv_cmd = parameter_list[0] + new_cmd
            if mpv_cmd[-1] != '"':
                mpv_cmd += '"'
        else:
            mpv_cmd = ""
    elif mode_num > 0:
        temp = mpv_cmd[1:] + " --glsl-shaders=" + MODE_CONFIG[mode_num][1] + mpv_cmd[:-1]
        mpv_cmd = '"' + temp.strip() + '"'

    start_pos = mplayer_additional_options.start() + len("mplayer_additional_options=")
    end_pos = mplayer_additional_options.end()
    new_conf = config[:start_pos] + mpv_cmd + config[end_pos:]

    with open(SMPLAYER_INI_PATH, "w") as f:
        f.write(new_conf)


if __name__ == "__main__":
    new_mode = get_arv_setting(sys.argv[1:])
    if new_mode is not None:
        current_mode = get_current_mode()
        if new_mode != current_mode:
            set_mode(new_mode)
            current_mode = new_mode
        print_current_mode(current_mode)
