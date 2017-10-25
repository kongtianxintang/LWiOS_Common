/***********************************************************
 * 版权所有,2017,MeFood.
 * Copyright(C),2017,MeFood co. LTD.All rights reserved.
 * project:Li
 * Author:
 * Date:  17/10/25
 * QQ/Tel/Mail:qq 383118832
 * Description:获取slide adress 感谢@xiaoyi6409 https://github.com/xiaoyi6409
 * Others:
 * Modifier:
 * Reason:
 *************************************************************/

#import "SlideAdressTool.h"
#import <mach-o/dyld.h>

@implementation SlideAdressTool


//MARK: - 获取偏移量地址
long  calculate(void){
    long slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        if (_dyld_get_image_header(i)->filetype == MH_EXECUTE) {
            slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    return slide;
}


@end
