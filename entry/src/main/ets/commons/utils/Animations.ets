import { Component } from "@kit.TestKit"

export async function playScaleAnimation<T>(
  setScale: (value: number) => void,
  bigValue: number,
  smallValue: number,
  bigDuration: number = 100,
  smallDuration: number = 100
) {
  // 放大
  await animateToPromise(() => {
    setScale(bigValue)
  }, bigDuration)

  // 缩小
  await animateToPromise(() => {
    setScale(smallValue)
  }, smallDuration)
}


// 帮助方法：包装 animateTo 成 Promise
function animateToPromise(animator: () => void, duration: number): Promise<void> {
  return new Promise((resolve) => {
    animateTo({
      duration: duration,
      curve: Curve.Sharp,
      onFinish: () => {
        resolve()
      }
    }, animator)
  })
}
