; ModuleID = 'tests/hello_world.bc'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@globaliz = global [300 x i8] zeroinitializer

define i32 @main() {
entry:
  %buffer = alloca i8, i32 1000, align 4
  %bundled = bitcast i8* %buffer to i104*
  store i104 31079605376604435891501163880, i104* %bundled, align 4 ; hello world in there
  call i32 (i8*)* @puts(i8* %buffer)

  %loaded = load i104* %bundled, align 4 ; save for later

  %backcast = bitcast i104* %bundled to i8*
  call i32 (i8*)* @puts(i8* %backcast)

  %temp.buffer = bitcast i8* %buffer to [0 x i8]*
  %buffer1 = getelementptr [0 x i8]* %temp.buffer, i32 0, i32 1
  %bundled1 = bitcast i8* %buffer1 to i104*
  store i104 31079605376604435891501163880, i104* %bundled1, align 1 ; unaligned
  call i32 (i8*)* @puts(i8* %buffer)

; shifts
  %shifted = lshr i104 %loaded, 16
  store i104 %shifted, i104* %bundled, align 4
  call i32 (i8*)* @puts(i8* %buffer)
  %shifted2 = lshr i104 %loaded, 32
  store i104 %shifted2, i104* %bundled, align 4
  call i32 (i8*)* @puts(i8* %buffer)

; store %loaded, make sure has not been modified
  store i104 %loaded, i104* %bundled, align 4
  call i32 (i8*)* @puts(i8* %buffer)

  %shifted3 = shl i104 %loaded, 8
  store i104 %shifted3, i104* %bundled, align 4
  store i8 113, i8* %buffer ; remove initial 0 ; 'q'
  call i32 (i8*)* @puts(i8* %buffer)

; trunc
  %shifted4 = shl i104 %loaded, 64
  store i104 %shifted4, i104* %bundled, align 4
  %nonzero64 = trunc i104 %loaded to i64 ; remove initial zeros
  %bundled64 = bitcast i104* %bundled to i64*
  store i64 %nonzero64, i64* %bundled64, align 4
  call i32 (i8*)* @puts(i8* %buffer)

  store i104 0, i104* %bundled, align 4 ; wipe it out
  %small32 = trunc i104 %loaded to i32
  %buffer32 = bitcast i8* %buffer to i32*
  store i32 %small32, i32* %buffer32, align 4
  call i32 (i8*)* @puts(i8* %buffer)

  store i104 0, i104* %bundled, align 4 ; wipe it out
  %small16 = trunc i104 %loaded to i16
  %buffer16 = bitcast i8* %buffer to i16*
  store i16 %small16, i16* %buffer16, align 4
  call i32 (i8*)* @puts(i8* %buffer)

  store i104 0, i104* %bundled, align 4 ; wipe it out
  %small64 = trunc i104 %loaded to i64
  %buffer64 = bitcast i8* %buffer to i64*
  store i64 %small64, i64* %buffer64, align 4
  call i32 (i8*)* @puts(i8* %buffer)

; zext
  store i104 0, i104* %bundled, align 4 ; wipe it out
  %pre32 = or i32 6382179, 0
  %big = zext i32 %pre32 to i104
  store i104 %big, i104* %bundled, align 4
  call i32 (i8*)* @puts(i8* %buffer)

  store i104 0, i104* %bundled, align 4 ; wipe it out
  %pre64 = zext i32 1684366951 to i64
  %post64 = shl i64 %pre64, 32
  %big64 = or i64 %pre64, %post64
  %bigb = zext i64 %big64 to i104
  store i104 %bigb, i104* %bundled, align 4
  call i32 (i8*)* @puts(i8* %buffer)

; or, and, xor
  %ored = or i104 %loaded, 119683656141956040435433472 ; constant
  store i104 %ored, i104* %bundled, align 4
  call i32 (i8*)* @puts(i8* %buffer)

  %ander = trunc i128 79037149320135189491510935551 to i104
  %anded = and i104 %loaded, %ander ; variable
  store i104 %anded, i104* %bundled, align 4
  call i32 (i8*)* @puts(i8* %buffer)

  %xored = xor i104 %loaded, 78580178274950896355901440
  store i104 %xored, i104* %bundled, align 4
  call i32 (i8*)* @puts(i8* %buffer)

; unfolding
  store i104 %loaded, i104* bitcast ([300 x i8]* @globaliz to i104*), align 4
  %loaded.short = load i80* bitcast ([300 x i8]* @globaliz to i80*), align 4
  store i104 0, i104* bitcast ([300 x i8]* @globaliz to i104*), align 4
  store i80 %loaded.short, i80* bitcast ([300 x i8]* @globaliz to i80*), align 4
  call i32 (i8*)* @puts(i8* bitcast ([300 x i8]* @globaliz to i8*))

  ret i32 1
}

declare i32 @puts(i8*)
